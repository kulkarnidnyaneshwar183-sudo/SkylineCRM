package com.crm;

import java.sql.Date;
import java.sql.Timestamp;

public class Task {
    private int taskId;
    private String title;
    private String description;
    private String assignedTo;
    private String assignedToName; // Joined from users table
    private Date deadline;
    private String status;
    private Timestamp createdAt;

    public Task(int taskId, String title, String description, String assignedTo, String assignedToName, Date deadline, String status, Timestamp createdAt) {
        this.taskId = taskId;
        this.title = title;
        this.description = description;
        this.assignedTo = assignedTo;
        this.assignedToName = assignedToName;
        this.deadline = deadline;
        this.status = status;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getTaskId() { return taskId; }
    public void setTaskId(int taskId) { this.taskId = taskId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getAssignedTo() { return assignedTo; }
    public void setAssignedTo(String assignedTo) { this.assignedTo = assignedTo; }
    public String getAssignedToName() { return assignedToName; }
    public void setAssignedToName(String assignedToName) { this.assignedToName = assignedToName; }
    public Date getDeadline() { return deadline; }
    public void setDeadline(Date deadline) { this.deadline = deadline; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}