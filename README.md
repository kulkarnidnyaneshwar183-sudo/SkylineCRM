# Skyline CRM - Real Estate Management System

Skyline CRM is a comprehensive Customer Relationship Management (CRM) application designed specifically for the real estate industry. It helps manage leads, clients, property inventory (flats), bookings, payments, and expenses within a single, streamlined platform.

## 🚀 Key Features

- **📊 Dashboard:** Quick overview of business performance and key metrics.
- **🤝 Lead & Client Management:** Track potential buyers from initial contact through closing.
- **🏢 Property Inventory (Flats):** Real-time tracking of available, reserved, and booked properties.
- **📅 Advanced Booking Module:**
    - **Searchable Selection:** Find clients and flats instantly with searchable inputs.
    - **Instant Details:** See BHK, area, and price details as soon as a flat is selected.
    - **Auto-Fill Prices:** Automatically populate the deal price based on the selected inventory.
    - **Payment Progress:** Interactive progress bars tracking paid vs. remaining amounts.
- **💰 Financial Tracking:** Manage client payments, installments, and business expenses.
- **👔 Vendor & Task Management:** Keep track of services and daily operations.
- **📂 Document Repository:** Centralized storage for client and property documents.

## 🛠️ Tech Stack

- **Backend:** Java 8, Servlets 4.0, JSP 2.3
- **Frontend:** Bootstrap 5, Bootstrap Icons, HTML5 Datalist
- **Database:** MySQL 8.0+
- **Build Tool:** Apache Maven
- **Server:** Apache Tomcat 9.0

## 📦 Installation & Setup

### Prerequisites

- Java Development Kit (JDK) 8 or higher
- Apache Maven
- MySQL Server 8.0+
- Apache Tomcat 9.0

### Database Setup

1. Open your MySQL client and create a new database:
   ```sql
   CREATE DATABASE skyline_crm;
   ```
2. Import the schema from the `schema.sql` file provided in the project root:
   ```bash
   mysql -u [username] -p skyline_crm < schema.sql
   ```

### Configuration

Update your database credentials in `src/main/resources/db.properties`:
```properties
db.url=jdbc:mysql://localhost:3306/skyline_crm
db.user=your_username
db.password=your_password
```

### Running the Application

For a quick start on Windows, run the provided batch file:
```bash
run.bat
```
This will build the project with Maven, deploy the WAR to your local Tomcat 9, and start the server.

Alternatively, use Maven:
```bash
mvn clean install tomcat7:run
```
*(Note: For Tomcat 9, deploy the generated `.war` file from `/target` to your Tomcat `webapps` folder).*

## 🔒 Default Admin Credentials

- **Username:** `admin`
- **Password:** `admin123`

## 👤 Author

- **Dnyaneshwar Kulkarni** - [@kulkarnidnyaneshwar183-sudo](https://github.com/kulkarnidnyaneshwar183-sudo)

---
*Developed for Skyline Real Estate CRM.*
