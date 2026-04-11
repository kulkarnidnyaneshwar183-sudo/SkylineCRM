package com.crm.servlet;

import com.crm.dao.FollowUpDAO;
import com.crm.dao.LeadDAO;
import com.crm.model.FollowUp;
import com.crm.model.Lead;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

@WebServlet("/followups")
public class FollowUpServlet extends HttpServlet {
    private FollowUpDAO followUpDAO = new FollowUpDAO();
    private LeadDAO leadDAO = new LeadDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            followUpDAO.deleteFollowUp(id);
            response.sendRedirect("followups");
        } else if ("complete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            followUpDAO.updateStatus(id, "Completed");
            response.sendRedirect("followups");
        } else {
            List<FollowUp> followUps = followUpDAO.getAllFollowUps();
            List<Lead> leads = leadDAO.getAllLeads();
            request.setAttribute("followUpList", followUps);
            request.setAttribute("leadList", leads);
            request.getRequestDispatcher("followups.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            int leadId = Integer.parseInt(request.getParameter("leadId"));
            String followDateStr = request.getParameter("followDate");
            String followType = request.getParameter("followType");
            String notes = request.getParameter("notes");

            Timestamp followDate = Timestamp.valueOf(followDateStr.replace("T", " ") + ":00");
            FollowUp f = new FollowUp(0, leadId, null, followDate, followType, notes, "Scheduled", null);
            followUpDAO.addFollowUp(f);
        }
        response.sendRedirect("followups");
    }
}