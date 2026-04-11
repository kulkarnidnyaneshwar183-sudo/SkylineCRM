package com.crm.model;

import java.sql.Timestamp;

public class FollowUp {
    private int followId;
    private int leadId;
    private String leadName;
    private Timestamp followDate;
    private String followType;
    private String notes;
    private String status;
    private Timestamp createdAt;

    public FollowUp(int followId, int leadId, String leadName, Timestamp followDate, String followType, String notes, String status, Timestamp createdAt) {
        this.followId = followId;
        this.leadId = leadId;
        this.leadName = leadName;
        this.followDate = followDate;
        this.followType = followType;
        this.notes = notes;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getFollowId() { return followId; }
    public int getLeadId() { return leadId; }
    public String getLeadName() { return leadName; }
    public Timestamp getFollowDate() { return followDate; }
    public String getFollowType() { return followType; }
    public String getNotes() { return notes; }
    public String getStatus() { return status; }
    public Timestamp getCreatedAt() { return createdAt; }
}