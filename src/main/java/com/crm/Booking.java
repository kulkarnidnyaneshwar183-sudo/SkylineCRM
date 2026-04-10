package com.crm;

import java.sql.Date;

public class Booking {
    private int bookingId;
    private int clientId;
    private String clientName; // Joined from clients table
    private String serviceName;
    private Date bookingDate;
    private double amount;
    private String status;

    public Booking(int bookingId, int clientId, String clientName, String serviceName, Date bookingDate, double amount, String status) {
        this.bookingId = bookingId;
        this.clientId = clientId;
        this.clientName = clientName;
        this.serviceName = serviceName;
        this.bookingDate = bookingDate;
        this.amount = amount;
        this.status = status;
    }

    // Getters and Setters
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }
    public int getClientId() { return clientId; }
    public void setClientId(int clientId) { this.clientId = clientId; }
    public String getClientName() { return clientName; }
    public void setClientName(String clientName) { this.clientName = clientName; }
    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }
    public Date getBookingDate() { return bookingDate; }
    public void setBookingDate(Date bookingDate) { this.bookingDate = bookingDate; }
    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}