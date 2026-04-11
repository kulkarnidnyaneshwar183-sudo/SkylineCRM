package com.crm.servlet;

import com.crm.dao.VendorDAO;
import com.crm.model.Vendor;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/vendors")
public class VendorServlet extends HttpServlet {
    private VendorDAO vendorDAO = new VendorDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            vendorDAO.deleteVendor(id);
            response.sendRedirect("vendors");
        } else {
            List<Vendor> vendors = vendorDAO.getAllVendors();
            request.setAttribute("vendorList", vendors);
            request.getRequestDispatcher("vendors.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            String name = request.getParameter("vendorName");
            String contact = request.getParameter("contactPerson");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String service = request.getParameter("serviceType");
            double due = Double.parseDouble(request.getParameter("totalDue"));

            Vendor vendor = new Vendor(0, name, contact, email, phone, service, due, null);
            vendorDAO.addVendor(vendor);
        } else if ("pay".equals(action)) {
            int vendorId = Integer.parseInt(request.getParameter("vendorId"));
            double amount = Double.parseDouble(request.getParameter("amount"));
            Date date = Date.valueOf(request.getParameter("paymentDate"));
            String method = request.getParameter("paymentMethod");
            String ref = request.getParameter("referenceNo");
            String userId = (String) request.getSession().getAttribute("userId");
            vendorDAO.recordPayment(vendorId, amount, date, method, ref, userId);
        }
        response.sendRedirect("vendors");
    }
}