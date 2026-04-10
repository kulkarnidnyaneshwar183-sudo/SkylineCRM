package com.crm;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/clients")
public class ClientServlet extends HttpServlet {

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
            listClients(request, response);
        } else if (action.equals("edit")) {
            showEditForm(request, response);
        } else if (action.equals("delete")) {
            deleteClient(request, response);
        } else if (action.equals("search")) {
            searchClients(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            addCustomer(request, response);
        } else if ("update".equals(action)) {
            updateCustomer(request, response);
        }
    }

    private void listClients(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Client> clients = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("SELECT * FROM clients ORDER BY created_at DESC");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                clients.add(new Client(
                    rs.getInt("client_id"),
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getString("phone"),
                    rs.getString("company"),
                    rs.getString("status"),
                    rs.getTimestamp("created_at")
                ));
            }
            request.setAttribute("clientList", clients);
            request.getRequestDispatcher("clients.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=db");
        } finally {
            if(ps != null) try { ps.close(); } catch(SQLException e) {}
            if(con != null) try { con.close(); } catch(SQLException e) {}
        }
    }

    private void searchClients(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String query = request.getParameter("query");
        List<Client> clients = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM clients WHERE name LIKE ? OR email LIKE ? OR company LIKE ?";
            ps = con.prepareStatement(sql);
            String searchTerm = "%" + query + "%";
            ps.setString(1, searchTerm);
            ps.setString(2, searchTerm);
            ps.setString(3, searchTerm);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                clients.add(new Client(
                    rs.getInt("client_id"),
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getString("phone"),
                    rs.getString("company"),
                    rs.getString("status"),
                    rs.getTimestamp("created_at")
                ));
            }
            request.setAttribute("clientList", clients);
            request.setAttribute("searchQuery", query);
            request.getRequestDispatcher("clients.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("clients?error=search");
        } finally {
            if(ps != null) try { ps.close(); } catch(SQLException e) {}
            if(con != null) try { con.close(); } catch(SQLException e) {}
        }
    }

    private void addCustomer(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String company = request.getParameter("company");

        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("INSERT INTO clients (name, email, phone, company, status) VALUES (?, ?, ?, ?, 'Active')");
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, company);
            ps.executeUpdate();
            response.sendRedirect("clients");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("clients?error=add");
        } finally {
            if(ps != null) try { ps.close(); } catch(SQLException e) {}
            if(con != null) try { con.close(); } catch(SQLException e) {}
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("SELECT * FROM clients WHERE client_id = ?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Client client = new Client(
                    rs.getInt("client_id"),
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getString("phone"),
                    rs.getString("company"),
                    rs.getString("status"),
                    rs.getTimestamp("created_at")
                );
                request.setAttribute("client", client);
                request.getRequestDispatcher("edit-customer.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("clients");
        } finally {
            if(ps != null) try { ps.close(); } catch(SQLException e) {}
            if(con != null) try { con.close(); } catch(SQLException e) {}
        }
    }

    private void updateCustomer(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int id = Integer.parseInt(request.getParameter("clientId"));
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String company = request.getParameter("company");
        String status = request.getParameter("status");

        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("UPDATE clients SET name=?, email=?, phone=?, company=?, status=? WHERE client_id=?");
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, company);
            ps.setString(5, status);
            ps.setInt(6, id);
            ps.executeUpdate();
            response.sendRedirect("clients");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("clients?error=update");
        } finally {
            if(ps != null) try { ps.close(); } catch(SQLException e) {}
            if(con != null) try { con.close(); } catch(SQLException e) {}
        }
    }

    private void deleteClient(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("DELETE FROM clients WHERE client_id = ?");
            ps.setInt(1, id);
            ps.executeUpdate();
            response.sendRedirect("clients");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("clients?error=delete");
        } finally {
            if(ps != null) try { ps.close(); } catch(SQLException e) {}
            if(con != null) try { con.close(); } catch(SQLException e) {}
        }
    }
}