package com.crm.servlet;

import com.crm.dao.EnquiryDAO;
import com.crm.model.Enquiry;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/enquiries")
public class EnquiryServlet extends HttpServlet {
    private EnquiryDAO enquiryDAO = new EnquiryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Enquiry> enquiries = enquiryDAO.getAllEnquiries();
        request.setAttribute("enquiryList", enquiries);
        request.getRequestDispatcher("enquiries.jsp").forward(request, response);
    }
}