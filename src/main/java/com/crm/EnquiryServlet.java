package com.crm;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/enquiries")
public class EnquiryServlet extends HttpServlet {

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
            listEnquiries(request, response);
        } else if (action.equals("delete")) {
            deleteEnquiry(request, response);
        } else if (action.equals("resolve")) {
            resolveEnquiry(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            addEnquiry(request, response);
        }
    }

    private void listEnquiries(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Enquiry> enquiries = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM enquiries ORDER BY created_at DESC";
            ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                enquiries.add(new Enquiry(
                    rs.getInt("enquiry_id"),
                    rs.getString("customer_name"),
                    rs.getString("email"),
                    rs.getString("subject"),
                    rs.getString("message"),
                    rs.getString("status"),
                    rs.getTimestamp("created_at")
                ));
            }
            request.setAttribute("enquiryList", enquiries);
            request.getRequestDispatcher("enquiries.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=db");
        } finally {
            closeResources(con, ps);
        }
    }

    private void addEnquiry(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String name = request.getParameter("customerName");
        String email = request.getParameter("email");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("INSERT INTO enquiries (customer_name, email, subject, message, status) VALUES (?, ?, ?, ?, 'Open')");
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, subject);
            ps.setString(4, message);
            ps.executeUpdate();
            response.sendRedirect("enquiries");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("enquiries?error=add");
        } finally {
            closeResources(con, ps);
        }
    }

    private void resolveEnquiry(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("UPDATE enquiries SET status = 'Resolved' WHERE enquiry_id = ?");
            ps.setInt(1, id);
            ps.executeUpdate();
            response.sendRedirect("enquiries");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("enquiries?error=resolve");
        } finally {
            closeResources(con, ps);
        }
    }

    private void deleteEnquiry(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("DELETE FROM enquiries WHERE enquiry_id = ?");
            ps.setInt(1, id);
            ps.executeUpdate();
            response.sendRedirect("enquiries");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("enquiries?error=delete");
        } finally {
            closeResources(con, ps);
        }
    }

    private void closeResources(Connection con, PreparedStatement ps) {
        if(ps != null) try { ps.close(); } catch(SQLException e) {}
        if(con != null) try { con.close(); } catch(SQLException e) {}
    }
}