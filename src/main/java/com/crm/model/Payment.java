package com.crm.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Payment {
    private int paymentId;
    private int bookingId;
    private double amount;
    private Date paymentDate;
    private String paymentMethod;
    private String notes;
    private Timestamp createdAt;

    public Payment(int paymentId, int bookingId, double amount, Date paymentDate, String paymentMethod, String notes, Timestamp createdAt) {
        this.paymentId = paymentId;
        this.bookingId = bookingId;
        this.amount = amount;
        this.paymentDate = paymentDate;
        this.paymentMethod = paymentMethod;
        this.notes = notes;
        this.createdAt = createdAt;
    }

    public int getPaymentId() { return paymentId; }
    public int getBookingId() { return bookingId; }
    public double getAmount() { return amount; }
    public Date getPaymentDate() { return paymentDate; }
    public String getPaymentMethod() { return paymentMethod; }
    public String getNotes() { return notes; }
    public Timestamp getCreatedAt() { return createdAt; }
}