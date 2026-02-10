/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.corelogic;
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.GCMParameterSpec;
import java.security.SecureRandom;
import java.util.*;
import java.util.concurrent.*;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

/**
 * Stand-alone demo implementing Secure Load Balancing (Java 1.8 compatible)
 * — Round-Robin, Throttled, Dynamic Routing + AES-GCM encryption
 */
public class SecureLoadBalancerDemo {

    // ===== VM Node =====
    static class VMNode {
        String id;
        double cpuUtil;
        double energyEfficiency;
        int capacity;
        int activeTasks = 0;

        VMNode(String id, double cpuUtil, double energyEfficiency, int capacity) {
            this.id = id;
            this.cpuUtil = clamp(cpuUtil, 0, 1);
            this.energyEfficiency = clamp(energyEfficiency, 0, 1);
            this.capacity = Math.max(1, capacity);
        }

        synchronized boolean acceptTask() {
            if (activeTasks < capacity) {
                activeTasks++;
                cpuUtil = clamp(cpuUtil + 0.05, 0, 1);
                return true;
            }
            return false;
        }

        synchronized void completeTask() {
            if (activeTasks > 0) {
                activeTasks--;
                cpuUtil = clamp(cpuUtil - 0.05, 0, 1);
            }
        }

        public String toString() {
            return String.format("VM[%s] cpu=%.2f eff=%.2f cap=%d active=%d",
                    id, cpuUtil, energyEfficiency, capacity, activeTasks);
        }

        private static double clamp(double v, double a, double b) {
            return Math.max(a, Math.min(b, v));
        }
    }

    // ===== AES Encryption Utility =====
    static class EncryptionUtil {
        private static final int AES_KEY_BITS = 128;   // use 128-bit for JDK8
        private static final int GCM_TAG_LEN = 128;
        private static final int GCM_IV_LEN = 12;

        static SecretKey generateKey() throws Exception {
            KeyGenerator kg = KeyGenerator.getInstance("AES");
            kg.init(AES_KEY_BITS);
            return kg.generateKey();
        }

        static String encrypt(SecretKey key, String plain) throws Exception {
            byte[] iv = new byte[GCM_IV_LEN];
            new SecureRandom().nextBytes(iv);
            Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
            GCMParameterSpec spec = new GCMParameterSpec(GCM_TAG_LEN, iv);
            cipher.init(Cipher.ENCRYPT_MODE, key, spec);
            byte[] ct = cipher.doFinal(plain.getBytes(StandardCharsets.UTF_8));
            byte[] out = new byte[iv.length + ct.length];
            System.arraycopy(iv, 0, out, 0, iv.length);
            System.arraycopy(ct, 0, out, iv.length, ct.length);
            return Base64.getEncoder().encodeToString(out);
        }

        static String decrypt(SecretKey key, String cipherTextB64) throws Exception {
            byte[] in = Base64.getDecoder().decode(cipherTextB64);
            byte[] iv = Arrays.copyOfRange(in, 0, GCM_IV_LEN);
            byte[] ct = Arrays.copyOfRange(in, GCM_IV_LEN, in.length);
            Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
            GCMParameterSpec spec = new GCMParameterSpec(GCM_TAG_LEN, iv);
            cipher.init(Cipher.DECRYPT_MODE, key, spec);
            byte[] pt = cipher.doFinal(ct);
            return new String(pt, StandardCharsets.UTF_8);
        }
    }

    // ===== Load Balancer =====
    static class LoadBalancer {
        private List<VMNode> vms;
        private int rrIndex = 0;
        private SecretKey key;

        LoadBalancer(List<VMNode> vms, SecretKey key) {
            this.vms = vms;
            this.key = key;
        }

        List<String> partitionData(String bigPayload, int chunks) {
            List<String> out = new ArrayList<String>();
            if (chunks <= 1) {
                out.add(bigPayload);
                return out;
            }
            int len = bigPayload.length();
            int chunkSize = Math.max(1, len / chunks);
            for (int i = 0; i < len; i += chunkSize) {
                int end = Math.min(len, i + chunkSize);
                out.add(bigPayload.substring(i, end));
            }
            return out;
        }

        synchronized VMNode pickNextRR() {
            VMNode vm = vms.get(rrIndex % vms.size());
            rrIndex = (rrIndex + 1) % vms.size();
            return vm;
        }

        Map<VMNode, String> roundRobinAssign(List<String> partitions) throws Exception {
            Map<VMNode, String> map = new LinkedHashMap<VMNode, String>();
            for (String p : partitions) {
                VMNode chosen = pickNextRR();
                String encrypted = EncryptionUtil.encrypt(key, p);
                if (!chosen.acceptTask()) {
                    // pick least loaded
                    chosen = Collections.min(vms, new Comparator<VMNode>() {
                        public int compare(VMNode a, VMNode b) {
                            return a.activeTasks - b.activeTasks;
                        }
                    });
                    chosen.acceptTask();
                }
                map.put(chosen, encrypted);
            }
            return map;
        }

        Map<VMNode, String> throttledAssign(List<String> partitions) throws Exception {
            Map<VMNode, String> map = new LinkedHashMap<VMNode, String>();
            for (String p : partitions) {
                VMNode chosen = null;
                for (VMNode vm : vms) {
                    if (vm.activeTasks < vm.capacity) {
                        if (chosen == null || vm.cpuUtil < chosen.cpuUtil)
                            chosen = vm;
                    }
                }
                if (chosen == null) {
                    chosen = Collections.max(vms, new Comparator<VMNode>() {
                        public int compare(VMNode a, VMNode b) {
                            return Double.compare(a.energyEfficiency, b.energyEfficiency);
                        }
                    });
                }
                chosen.acceptTask();
                map.put(chosen, EncryptionUtil.encrypt(key, p));
            }
            return map;
        }

        Map<VMNode, String> dynamicRoutingAssign(List<String> partitions) throws Exception {
            Map<VMNode, String> map = new LinkedHashMap<VMNode, String>();
            for (String p : partitions) {
                VMNode best = null;
                double bestScore = -1;
                for (VMNode vm : vms) {
                    double score = dynamicScore(vm);
                    if (score > bestScore) {
                        bestScore = score;
                        best = vm;
                    }
                }
                best.acceptTask();
                map.put(best, EncryptionUtil.encrypt(key, p));
            }
            return map;
        }

        double dynamicScore(VMNode vm) {
            double avail = 1 - vm.cpuUtil;
            double energy = vm.energyEfficiency;
            double capacity = (vm.capacity - vm.activeTasks) / (double) vm.capacity;
            return 0.5 * avail + 0.35 * energy + 0.15 * capacity;
        }

        void simulateCompletionAsync(final Map<VMNode, String> assignments, long delayMs) {
            ScheduledExecutorService s = Executors.newScheduledThreadPool(1);
            for (final VMNode vm : assignments.keySet()) {
                s.schedule(new Runnable() {
                    public void run() {
                        vm.completeTask();
                    }
                }, delayMs, TimeUnit.MILLISECONDS);
            }
            s.shutdown();
        }

        String decryptPayload(String enc) throws Exception {
            return EncryptionUtil.decrypt(key, enc);
        }
    }

    // ===== Helper method to safely truncate preview text =====
    private static String truncate(String text, int length) {
        if (text == null) return "";
        if (text.length() <= length) return text;
        return text.substring(0, length) + "...";
    }

    // ===== Main Demo =====
    public static void main(String[] args) throws Exception {
        List<VMNode> vms = Arrays.asList(
                new VMNode("vm1", 0.10, 0.90, 3),
                new VMNode("vm2", 0.40, 0.75, 2),
                new VMNode("vm3", 0.25, 0.65, 4)
        );
        SecretKey key = EncryptionUtil.generateKey();
        LoadBalancer lb = new LoadBalancer(vms, key);

        String payload = "Big data analytics secure load balancing simulation payload example...";
        List<String> parts = lb.partitionData(payload, 4);

        System.out.println("=== Round Robin ===");
        Map<VMNode, String> rr = lb.roundRobinAssign(parts);
        for (Map.Entry<VMNode, String> e : rr.entrySet()) {
            System.out.println(e.getKey().id + " -> " +
                    truncate(lb.decryptPayload(e.getValue()), 20));
        }

        System.out.println("\n=== Throttled ===");
        Map<VMNode, String> th = lb.throttledAssign(parts);
        for (Map.Entry<VMNode, String> e : th.entrySet()) {
            System.out.println(e.getKey().id + " -> " +
                    truncate(lb.decryptPayload(e.getValue()), 20));
        }

        System.out.println("\n=== Dynamic Routing ===");
        Map<VMNode, String> dy = lb.dynamicRoutingAssign(parts);
        for (Map.Entry<VMNode, String> e : dy.entrySet()) {
            System.out.println(e.getKey().id + " -> " +
                    truncate(lb.decryptPayload(e.getValue()), 20));
        }

        System.out.println("\nFinal VM states:");
        for (VMNode vm : vms) System.out.println(vm);
    }
}
