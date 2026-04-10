package com.crm;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/leads")
public class LeadServlet extends HttpServlet {

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
            listLeads(request, response);
        } else if (action.equals("edit")) {
            showEditForm(request, response);
        } else if (action.equals("delete")) {
            deleteLead(request, response);
        } else if (action.equals("convert")) {
            convertToClient(request, response);
        } else if (action.equals("search")) {
            searchLeads(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            addLead(request, response);
        } else if ("update".equals(action)) {
            updateLead(request, response);
        }
    }

    private void listLeads(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Lead> leads = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("SELECT * FROM leads ORDER BY created_at DESC");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                leads.add(new Lead(
                    rs.getInt("lead_id"),
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getString("phone"),
                    rs.getString("source"),
                    rs.getString("status"),
                    rs.getTimestamp("created_at")
                ));
            }
            request.setAttribute("leadList", leads);
            request.getRequestDispatcher("leads.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=db");
        } finally {
            closeResources(con, ps);
        }
    }

    private void searchLeads(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String query = request.getParameter("query");
        List<Lead> leads = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM leads WHERE name LIKE ? OR email LIKE ? OR source LIKE ?";
            ps = con.prepareStatement(sql);
            String searchTerm = "%" + query + "%";
            ps.setString(1, searchTerm);
            ps.setString(2, searchTerm);
            ps.setString(3, searchTerm);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                leads.add(new Lead(
                    rs.getInt("lead_id"),
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getString("phone"),
                    rs.getString("source"),
                    rs.getString("status"),
                    rs.getTimestamp("created_at")
                ));
            }
            request.setAttribute("leadList", leads);
            request.setAttribute("searchQuery", query);
            request.getRequestDispatcher("leads.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("leads?error=search");
        } finally {
            closeResources(con, ps);
        }
    }

    private void addLead(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String source = request.getParameter("source");

        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("INSERT INTO leads (name, email, phone, source, status) VALUES (?, ?, ?, ?, 'New')");
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, source);
            ps.executeUpdate();
            response.sendRedirect("leads");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("leads?error=add");
        } finally {
            closeResources(con, ps);
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("SELECT * FROM leads WHERE lead_id = ?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Lead lead = new Lead(
                    rs.getInt("lead_id"),
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getString("phone"),
                    rs.getString("source"),
                    rs.getString("status"),
                    rs.getTimestamp("created_at")
                );
                request.setAttribute("lead", lead);
                request.getRequestDispatcher("edit-lead.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("leads");
        } finally {
            closeResources(con, ps);
        }
    }

    private void updateLead(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int id = Integer.parseInt(request.getParameter("leadId"));
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String source = request.getParameter("source");
        String status = request.getParameter("status");

        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("UPDATE leads SET name=?, email=?, phone=?, source=?, status=? WHERE lead_id=?");
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, source);
            ps.setString(5, status);
            ps.setInt(6, id);
            ps.executeUpdate();
            response.sendRedirect("leads");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("leads?error=update");
        } finally {
            closeResources(con, ps);
        }
    }

    private void deleteLead(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("DELETE FROM leads WHERE lead_id = ?");
            ps.setInt(1, id);
            ps.executeUpdate();
            response.sendRedirect("leads");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("leads?error=delete");
        } finally {
            closeResources(con, ps);
        }
    }

    private void convertToClient(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);
            
            PreparedStatement ps1 = con.prepareStatement("SELECT * FROM leads WHERE lead_id = ?");
            ps1.setInt(1, id);
            ResultSet rs = ps1.executeQuery();
            
            if (rs.next()) {
                PreparedStatement ps2 = con.prepareStatement(
                    "INSERT INTO clients (name, email, phone, status) VALUES (?, ?, ?, 'Active')");
                ps2.setString(1, rs.getString("name"));
                ps2.setString(2, rs.getString("email"));
                ps2.setString(3, rs.getString("phone"));
                ps2.executeUpdate();

                PreparedStatement ps3 = con.prepareStatement("DELETE FROM leads WHERE lead_id = ?");
                ps3.setInt(1, id);
                ps3.executeUpdate();

                con.commit();
                response.sendRedirect("clients");
            } else {
                con.rollback();
                response.sendRedirect("leads?error=notfound");
            }
        } catch (SQLException e) {
            if(con != null) try { con.rollback(); } catch(SQLException ex) {}
            e.printStackTrace();
            response.sendRedirect("leads?error=convert");
        } finally {
            if(con != null) try { con.setAutoCommit(true); con.close(); } catch(SQLException e) {}
        }
    }

    private void closeResources(Connection con, PreparedStatement ps) {
        if(ps != null) try { ps.close(); } catch(SQLException e) {}
        if(con != null) try { con.close(); } catch(SQLException e) {}
    }
}