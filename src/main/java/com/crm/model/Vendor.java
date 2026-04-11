package com.crm.model;

import java.sql.Timestamp;

public class Vendor {
    private int vendorId;
    private String vendorName;
    private String contactPerson;
    private String email;
    private String phone;
    private String serviceType;
    private double totalDue;
    private Timestamp createdAt;

    public Vendor(int vendorId, String vendorName, String contactPerson, String email, String phone, String serviceType, double totalDue, Timestamp createdAt) {
        this.vendorId = vendorId;
        this.vendorName = vendorName;
        this.contactPerson = contactPerson;
        this.email = email;
        this.phone = phone;
        this.serviceType = serviceType;
        this.totalDue = totalDue;
        this.createdAt = createdAt;
    }

    public int getVendorId() { return vendorId; }
    public String getVendorName() { return vendorName; }
    public String getContactPerson() { return contactPerson; }
    public String getEmail() { return email; }
    public String getPhone() { return phone; }
    public String getServiceType() { return serviceType; }
    public double getTotalDue() { return totalDue; }
    public Timestamp getCreatedAt() { return createdAt; }
}