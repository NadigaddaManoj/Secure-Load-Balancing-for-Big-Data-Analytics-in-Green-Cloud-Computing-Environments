package com.corelogic;

public class Server {
    private int id, capacity, currentLoad;
    private float energyUsage, trustScore;
    private String name, status;

    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }
    public int getCurrentLoad() { return currentLoad; }
    public void setCurrentLoad(int currentLoad) { this.currentLoad = currentLoad; }
    public float getEnergyUsage() { return energyUsage; }
    public void setEnergyUsage(float energyUsage) { this.energyUsage = energyUsage; }
    public float getTrustScore() { return trustScore; }
    public void setTrustScore(float trustScore) { this.trustScore = trustScore; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}