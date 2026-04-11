package com.crm.model;

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

    public int getEnquiryId() { return enquiryId; }
    public String getCustomerName() { return customerName; }
    public String getEmail() { return email; }
    public String getSubject() { return subject; }
    public String getMessage() { return message; }
    public String getStatus() { return status; }
    public Timestamp getCreatedAt() { return createdAt; }
}