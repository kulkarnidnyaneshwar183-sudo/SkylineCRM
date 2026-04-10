package com.crm;

import java.sql.Timestamp;

public class Flat {
    private int flatId;
    private String flatNumber;
    private String buildingName;
    private int floor;
    private String bhk;
    private double areaSqft;
    private double price;
    private String status;
    private Timestamp createdAt;

    public Flat(int flatId, String flatNumber, String buildingName, int floor, String bhk, double areaSqft, double price, String status, Timestamp createdAt) {
        this.flatId = flatId;
        this.flatNumber = flatNumber;
        this.buildingName = buildingName;
        this.floor = floor;
        this.bhk = bhk;
        this.areaSqft = areaSqft;
        this.price = price;
        this.status = status;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getFlatId() { return flatId; }
    public void setFlatId(int flatId) { this.flatId = flatId; }
    public String getFlatNumber() { return flatNumber; }
    public void setFlatNumber(String flatNumber) { this.flatNumber = flatNumber; }
    public String getBuildingName() { return buildingName; }
    public void setBuildingName(String buildingName) { this.buildingName = buildingName; }
    public int getFloor() { return floor; }
    public void setFloor(int floor) { this.floor = floor; }
    public String getBhk() { return bhk; }
    public void setBhk(String bhk) { this.bhk = bhk; }
    public double getAreaSqft() { return areaSqft; }
    public void setAreaSqft(double areaSqft) { this.areaSqft = areaSqft; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}