package com.crm.model;

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
    private String imageUrl;
    private Timestamp createdAt;

    public Flat(int flatId, String flatNumber, String buildingName, int floor, String bhk, double areaSqft, double price, String status, String imageUrl, Timestamp createdAt) {
        this.flatId = flatId;
        this.flatNumber = flatNumber;
        this.buildingName = buildingName;
        this.floor = floor;
        this.bhk = bhk;
        this.areaSqft = areaSqft;
        this.price = price;
        this.status = status;
        this.imageUrl = imageUrl;
        this.createdAt = createdAt;
    }

    public int getFlatId() { return flatId; }
    public String getFlatNumber() { return flatNumber; }
    public String getBuildingName() { return buildingName; }
    public int getFloor() { return floor; }
    public String getBhk() { return bhk; }
    public double getAreaSqft() { return areaSqft; }
    public double getPrice() { return price; }
    public String getStatus() { return status; }
    public String getImageUrl() { return imageUrl; }
    public Timestamp getCreatedAt() { return createdAt; }
}