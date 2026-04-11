package com.crm.servlet;

import com.crm.dao.FlatDAO;
import com.crm.model.Flat;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/inventory")
public class FlatServlet extends HttpServlet {
    private FlatDAO flatDAO = new FlatDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            flatDAO.deleteFlat(id);
            response.sendRedirect("inventory");
        } else {
            List<Flat> flats = flatDAO.getAllFlats();
            request.setAttribute("flatList", flats);
            request.getRequestDispatcher("inventory.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            String flatNumber = request.getParameter("flatNumber");
            String buildingName = request.getParameter("buildingName");
            int floor = Integer.parseInt(request.getParameter("floor"));
            String bhk = request.getParameter("bhk");
            double areaSqft = Double.parseDouble(request.getParameter("areaSqft"));
            double price = Double.parseDouble(request.getParameter("price"));
            String status = request.getParameter("status");

            Flat flat = new Flat(0, flatNumber, buildingName, floor, bhk, areaSqft, price, status, null);
            flatDAO.addFlat(flat);
        } else if ("update".equals(action)) {
            int flatId = Integer.parseInt(request.getParameter("flatId"));
            String status = request.getParameter("status");
            double price = Double.parseDouble(request.getParameter("price"));
            flatDAO.updateFlatStatus(flatId, status, price);
        }
        response.sendRedirect("inventory");
    }
}