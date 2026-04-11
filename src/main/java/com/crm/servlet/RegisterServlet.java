package com.crm.servlet;

import com.crm.dao.UserDAO;
import com.crm.model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.UUID;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        String userId = "U" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        User user = new User(userId, fullName, username, password, role, "Active", "default.png");

        if (userDAO.registerUser(user)) {
            response.sendRedirect("login?registered=true");
        } else {
            request.setAttribute("error", "Registration failed! Username might already exist.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}