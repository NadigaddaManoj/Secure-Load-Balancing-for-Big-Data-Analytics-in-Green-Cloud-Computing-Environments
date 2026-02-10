package com.corelogic;

public class Task {
    private int id, userId, serverId;
    private String fileName, fileData, status, algorithmUsed;

    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getServerId() { return serverId; }
    public void setServerId(int serverId) { this.serverId = serverId; }
    public String getFileName() { return fileName; }
    public void setFileName(String fileName) { this.fileName = fileName; }
    public String getFileData() { return fileData; }
    public void setFileData(String fileData) { this.fileData = fileData; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getAlgorithmUsed() { return algorithmUsed; }
    public void setAlgorithmUsed(String algorithmUsed) { this.algorithmUsed = algorithmUsed; }
}