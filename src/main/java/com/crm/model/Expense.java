package com.crm.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Expense {
    private int expenseId;
    private String title;
    private String category;
    private double amount;
    private String paymentMethod;
    private Date expenseDate;
    private String description;
    private String recordedBy;
    private String recorderName;
    private Timestamp createdAt;

    public Expense(int expenseId, String title, String category, double amount, String paymentMethod, Date expenseDate, String description, String recordedBy, String recorderName, Timestamp createdAt) {
        this.expenseId = expenseId;
        this.title = title;
        this.category = category;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.expenseDate = expenseDate;
        this.description = description;
        this.recordedBy = recordedBy;
        this.recorderName = recorderName;
        this.createdAt = createdAt;
    }

    public int getExpenseId() { return expenseId; }
    public String getTitle() { return title; }
    public String getCategory() { return category; }
    public double getAmount() { return amount; }
    public String getPaymentMethod() { return paymentMethod; }
    public Date getExpenseDate() { return expenseDate; }
    public String getDescription() { return description; }
    public String getRecordedBy() { return recordedBy; }
    public String getRecorderName() { return recorderName; }
    public Timestamp getCreatedAt() { return createdAt; }
}