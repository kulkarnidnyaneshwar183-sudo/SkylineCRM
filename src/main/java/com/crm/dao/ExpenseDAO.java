package com.crm.dao;

import com.crm.model.Expense;
import com.crm.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ExpenseDAO {
    public List<Expense> getAllExpenses() {
        List<Expense> expenses = new ArrayList<>();
        String sql = "SELECT e.*, u.full_name as recorder_name FROM expenses e JOIN users u ON e.recorded_by = u.user_id ORDER BY e.expense_date DESC, e.created_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                expenses.add(new Expense(
                    rs.getInt("expense_id"),
                    rs.getString("title"),
                    rs.getString("category"),
                    rs.getDouble("amount"),
                    rs.getString("payment_method"),
                    rs.getDate("expense_date"),
                    rs.getString("description"),
                    rs.getString("recorded_by"),
                    rs.getString("recorder_name"),
                    rs.getTimestamp("created_at")
                ));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return expenses;
    }

    public boolean addExpense(Expense expense) {
        String sql = "INSERT INTO expenses (title, category, amount, payment_method, expense_date, description, recorded_by) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, expense.getTitle());
            ps.setString(2, expense.getCategory());
            ps.setDouble(3, expense.getAmount());
            ps.setString(4, expense.getPaymentMethod());
            ps.setDate(5, expense.getExpenseDate());
            ps.setString(6, expense.getDescription());
            ps.setString(7, expense.getRecordedBy());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean deleteExpense(int id) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("DELETE FROM expenses WHERE expense_id = ?")) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}