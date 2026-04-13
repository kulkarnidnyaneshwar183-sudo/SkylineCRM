package com.crm.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Booking {
    private int bookingId;
    private int clientId;
    private String clientName;
    private int flatId;
    private String flatNumber;
    private String bookingType;
    private Date bookingDate;
    private double totalAmount;
    private double paidAmount;
    private double remainingAmount;
    private String status;
    private Timestamp createdAt;

    public Booking(int bookingId, int clientId, String clientName, int flatId, String flatNumber, String bookingType, Date bookingDate, double totalAmount, double paidAmount, double remainingAmount, String status, Timestamp createdAt) {
        this.bookingId = bookingId;
        this.clientId = clientId;
        this.clientName = clientName;
        this.flatId = flatId;
        this.flatNumber = flatNumber;
        this.bookingType = bookingType;
        this.bookingDate = bookingDate;
        this.totalAmount = totalAmount;
        this.paidAmount = paidAmount;
        this.remainingAmount = remainingAmount;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getBookingId() { return bookingId; }
    public int getClientId() { return clientId; }
    public String getClientName() { return clientName; }
    public int getFlatId() { return flatId; }
    public String getFlatNumber() { return flatNumber; }
    public String getBookingType() { return bookingType; }
    public Date getBookingDate() { return bookingDate; }
    public double getTotalAmount() { return totalAmount; }
    public double getPaidAmount() { return paidAmount; }
    public double getRemainingAmount() { return remainingAmount; }
    public String getStatus() { return status; }
    public Timestamp getCreatedAt() { return createdAt; }
}