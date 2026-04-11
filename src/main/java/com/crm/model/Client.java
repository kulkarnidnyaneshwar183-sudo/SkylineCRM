package com.crm.model;

import java.sql.Timestamp;

public class Client {
    private int clientId;
    private String name;
    private String email;
    private String phone;
    private String company;
    private String status;
    private Timestamp createdAt;

    public Client(int clientId, String name, String email, String phone, String company, String status, Timestamp createdAt) {
        this.clientId = clientId;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.company = company;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getClientId() { return clientId; }
    public String getName() { return name; }
    public String getEmail() { return email; }
    public String getPhone() { return phone; }
    public String getCompany() { return company; }
    public String getStatus() { return status; }
    public Timestamp getCreatedAt() { return createdAt; }
}