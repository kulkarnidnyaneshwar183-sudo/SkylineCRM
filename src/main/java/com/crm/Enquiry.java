package com.crm;

import java.sql.Timestamp;

public class Enquiry {
    private int enquiryId;
    private String customerName;
    private String email;
    private String subject;
    private String message;
    private String status;
    private Timestamp createdAt;

    public Enquiry(int enquiryId, String customerName, String email, String subject, String message, String status, Timestamp createdAt) {
        this.enquiryId = enquiryId;
        this.customerName = customerName;
        this.email = email;
        this.subject = subject;
        this.message = message;
        this.status = status;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getEnquiryId() { return enquiryId; }
    public void setEnquiryId(int enquiryId) { this.enquiryId = enquiryId; }
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}