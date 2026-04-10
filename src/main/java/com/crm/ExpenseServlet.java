package com.crm;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/expenses")
public class ExpenseServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        if (session.getAttribute("userId") == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.equals("list")) {
            listExpenses(request, response);
        } else if (action.equals("delete")) {
            deleteExpense(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            addExpense(request, response);
        }
    }

    private void listExpenses(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Expense> expenses = new ArrayList<>();
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT e.*, u.full_name as recorder_name FROM expenses e JOIN users u ON e.recorded_by = u.user_id ORDER BY e.expense_date DESC, e.created_at DESC";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
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
            request.setAttribute("expenseList", expenses);
            request.getRequestDispatcher("expenses.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=db");
        }
    }

    private void addExpense(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userId");
        
        String title = request.getParameter("title");
        String category = request.getParameter("category");
        double amount = Double.parseDouble(request.getParameter("amount"));
        String paymentMethod = request.getParameter("paymentMethod");
        Date expenseDate = Date.valueOf(request.getParameter("expenseDate"));
        String description = request.getParameter("description");

        try (Connection con = DBConnection.getConnection()) {
            String sql = "INSERT INTO expenses (title, category, amount, payment_method, expense_date, description, recorded_by) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, title);
            ps.setString(2, category);
            ps.setDouble(3, amount);
            ps.setString(4, paymentMethod);
            ps.setDate(5, expenseDate);
            ps.setString(6, description);
            ps.setString(7, userId);
            ps.executeUpdate();
            response.sendRedirect("expenses");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("expenses?error=add");
        }
    }

    private void deleteExpense(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("DELETE FROM expenses WHERE expense_id = ?");
            ps.setInt(1, id);
            ps.executeUpdate();
            response.sendRedirect("expenses");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("expenses?error=delete");
        }
    }
}