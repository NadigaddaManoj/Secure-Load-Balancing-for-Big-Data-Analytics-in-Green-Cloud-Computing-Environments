package com.corelogic;

public class VMNode {
    private int id;
    private String name;
    private double cpuUtil;
    private double energyEfficiency;
    private int capacity;
    private int activeTasks;
    private float trustScore;

    public VMNode(int id, String name, int capacity, float trustScore,
                  double energyEfficiency, int activeTasks) {
        this.id = id;
        this.name = name;
        this.capacity = Math.max(1, capacity);
        this.trustScore = trustScore;
        this.energyEfficiency = clamp(energyEfficiency, 0, 1);
        this.cpuUtil = clamp(activeTasks * 0.1, 0, 1);
        this.activeTasks = activeTasks;
    }

    // Accept task (capacity check)
    public synchronized boolean acceptTask() {
        if (activeTasks < capacity) {
            activeTasks++;
            cpuUtil = clamp(cpuUtil + 0.05, 0, 1);
            return true;
        }
        return false;
    }

    // Complete task
    public synchronized void completeTask() {
        if (activeTasks > 0) {
            activeTasks--;
            cpuUtil = clamp(cpuUtil - 0.05, 0, 1);
        }
    }

    // 🔥 NEW: energy update
    public void increaseEnergy() {
        energyEfficiency = clamp(energyEfficiency + 0.05, 0, 1);
    }

    // 🔥 NEW: trust update
    public void increaseTrust() {
        trustScore = Math.min(1.0f, trustScore + 0.01f);
    }

    // Getters
    public int getId() { return id; }
    public String getName() { return name; }
    public double getCpuUtil() { return cpuUtil; }
    public double getEnergyEfficiency() { return energyEfficiency; }
    public int getCapacity() { return capacity; }
    public int getActiveTasks() { return activeTasks; }
    public float getTrustScore() { return trustScore; }

    public void setActiveTasks(int activeTasks) {
        this.activeTasks = activeTasks;
    }

    @Override
    public String toString() {
        return String.format(
            "VM[%s] cpu=%.2f eff=%.2f cap=%d active=%d trust=%.2f",
            name, cpuUtil, energyEfficiency, capacity, activeTasks, trustScore
        );
    }

    private static double clamp(double v, double a, double b) {
        return Math.max(a, Math.min(b, v));
    }
}
