package com.crm.servlet;

import com.crm.dao.LeadDAO;
import com.crm.model.Lead;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/leads")
public class LeadServlet extends HttpServlet {
    private LeadDAO leadDAO = new LeadDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Lead> leads = leadDAO.getAllLeads();
        request.setAttribute("leadList", leads);
        request.getRequestDispatcher("leads.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String source = request.getParameter("source");
        String status = request.getParameter("status");

        Lead lead = new Lead(0, name, email, phone, source, status, null);
        if (leadDAO.addLead(lead)) {
            response.sendRedirect("leads");
        } else {
            response.sendRedirect("leads?error=add");
        }
    }
}