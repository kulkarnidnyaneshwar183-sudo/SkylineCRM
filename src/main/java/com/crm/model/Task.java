package com.crm.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Task {
    private int taskId;
    private String title;
    private String description;
    private String assignedTo;
    private String userName;
    private Date deadline;
    private String status;
    private Timestamp createdAt;

    public Task(int taskId, String title, String description, String assignedTo, String userName, Date deadline, String status, Timestamp createdAt) {
        this.taskId = taskId;
        this.title = title;
        this.description = description;
        this.assignedTo = assignedTo;
        this.userName = userName;
        this.deadline = deadline;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getTaskId() { return taskId; }
    public String getTitle() { return title; }
    public String getDescription() { return description; }
    public String getAssignedTo() { return assignedTo; }
    public String getUserName() { return userName; }
    public Date getDeadline() { return deadline; }
    public String getStatus() { return status; }
    public Timestamp getCreatedAt() { return createdAt; }
}