package com.corelogic;

import com.db.DBConnection;
import javax.crypto.SecretKey;
import java.sql.*;
import java.util.*;
import javax.servlet.http.HttpServletRequest;

public class LoadBalancer {

    private List<VMNode> vms;
    private SecretKey sharedKey;
    private static int rrIndex = 0; // 🔁 Round Robin pointer

    public LoadBalancer(HttpServletRequest request) throws Exception {
        this.vms = new ArrayList<>();
        this.sharedKey = KeyManager.getKey(request.getServletContext());

        if (sharedKey == null) {
            throw new Exception("Encryption key not found");
        }

        loadVmsFromDatabase();
    }

    /* ================= LOAD SERVERS ================= */
    private void loadVmsFromDatabase() throws SQLException, ClassNotFoundException {

        Connection con = DBConnection.getConnection();
        PreparedStatement ps = con.prepareStatement(
            "SELECT server_id, server_name, capacity, current_load, energy_usage, trust_score, status FROM servers"
        );

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            if ("Active".equals(rs.getString("status"))) {
                vms.add(new VMNode(
                    rs.getInt("server_id"),
                    rs.getString("server_name"),
                    rs.getInt("capacity"),
                    rs.getFloat("trust_score"),
                    rs.getFloat("energy_usage") / 100,
                    rs.getInt("current_load")
                ));
            }
        }

        rs.close();
        ps.close();
        con.close();

        if (vms.isEmpty()) {
            throw new IllegalStateException("No active servers");
        }
    }

    /* ================= ROUND ROBIN ================= */
    public synchronized VMNode getRoundRobinServer() {

        int attempts = 0;

        while (attempts < vms.size()) {
            VMNode vm = vms.get(rrIndex);
            rrIndex = (rrIndex + 1) % vms.size();

            if (vm.getActiveTasks() < vm.getCapacity()) {
                return vm;
            }
            attempts++;
        }

        throw new IllegalStateException("All servers are full");
    }

    /* ================= THROTTLED ================= */
    public VMNode getThrottledServer() {

        for (VMNode vm : vms) {
            if (vm.getActiveTasks() < vm.getCapacity()) {
                return vm;
            }
        }

        throw new IllegalStateException("No free server available");
    }

    /* ================= DYNAMIC ROUTING ================= */
    public VMNode getDynamicServer() {

        VMNode best = null;
        double bestScore = -1;

        for (VMNode vm : vms) {

            if (vm.getActiveTasks() >= vm.getCapacity())
                continue;

            double loadFactor = 1.0 - ((double) vm.getActiveTasks() / vm.getCapacity());
            double score = loadFactor
                         + vm.getEnergyEfficiency()
                         + vm.getTrustScore();

            if (best == null || score > bestScore) {
                best = vm;
                bestScore = score;
            }
        }

        if (best == null) {
            throw new IllegalStateException("No suitable server found");
        }

        return best;
    }

    /* ================= LEAST LOADED (DEFAULT) ================= */
    public VMNode getLeastLoadedServer() {

        VMNode best = null;

        for (VMNode vm : vms) {
            if (vm.getActiveTasks() < vm.getCapacity()) {
                if (best == null || vm.getActiveTasks() < best.getActiveTasks()) {
                    best = vm;
                }
            }
        }

        if (best == null) {
            throw new IllegalStateException("All servers full");
        }

        return best;
    }

    /* ================= UPDATE SERVER ================= */
    public void updateVmInDatabase(VMNode vm) throws SQLException, ClassNotFoundException {

        Connection con = DBConnection.getConnection();
        PreparedStatement ps = con.prepareStatement(
            "UPDATE servers SET current_load=?, energy_usage=?, trust_score=? WHERE server_id=?"
        );

        ps.setInt(1, vm.getActiveTasks());
        ps.setFloat(2, (float) (vm.getEnergyEfficiency() * 100));
        ps.setFloat(3, vm.getTrustScore());
        ps.setInt(4, vm.getId());

        ps.executeUpdate();
        ps.close();
        con.close();
    }

    /* ================= ENCRYPT ================= */
    public String encrypt(String plain) throws Exception {
        return EncryptionUtil.encrypt(sharedKey, plain);
    }

    public List<VMNode> getVms() {
        return vms;
    }
    
    /* ================= ENCRYPT ================= */


/* ================= DECRYPT ================= */
public String decrypt(String cipherText) throws Exception {
    return EncryptionUtil.decrypt(sharedKey, cipherText);
}

}
