package com.crm.servlet;

import com.crm.dao.ExpenseDAO;
import com.crm.model.Expense;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/expenses")
public class ExpenseServlet extends HttpServlet {
    private ExpenseDAO expenseDAO = new ExpenseDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            expenseDAO.deleteExpense(id);
            response.sendRedirect("expenses");
        } else {
            List<Expense> expenses = expenseDAO.getAllExpenses();
            request.setAttribute("expenseList", expenses);
            request.getRequestDispatcher("expenses.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            String title = request.getParameter("title");
            String category = request.getParameter("category");
            double amount = Double.parseDouble(request.getParameter("amount"));
            String paymentMethod = request.getParameter("paymentMethod");
            Date expenseDate = Date.valueOf(request.getParameter("expenseDate"));
            String description = request.getParameter("description");
            String userId = (String) request.getSession().getAttribute("userId");

            Expense expense = new Expense(0, title, category, amount, paymentMethod, expenseDate, description, userId, null, null);
            expenseDAO.addExpense(expense);
        }
        response.sendRedirect("expenses");
    }
}