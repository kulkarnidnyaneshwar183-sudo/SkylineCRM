package com.crm.servlet;

import com.crm.dao.BookingDAO;
import com.crm.dao.ClientDAO;
import com.crm.dao.FlatDAO;
import com.crm.model.Booking;
import com.crm.model.Client;
import com.crm.model.Flat;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/bookings")
public class BookingServlet extends HttpServlet {
    private BookingDAO bookingDAO = new BookingDAO();
    private ClientDAO clientDAO = new ClientDAO();
    private FlatDAO flatDAO = new FlatDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            bookingDAO.deleteBooking(id);
            response.sendRedirect("bookings");
        } else {
            List<Booking> bookings = bookingDAO.getAllBookings();
            List<Client> clients = clientDAO.getAllClients();
            List<Flat> flats = flatDAO.getAllFlats();
            
            request.setAttribute("bookingList", bookings);
            request.setAttribute("clientList", clients);
            request.setAttribute("flatList", flats);
            request.getRequestDispatcher("bookings.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            int clientId = Integer.parseInt(request.getParameter("clientId"));
            int flatId = Integer.parseInt(request.getParameter("flatId"));
            String type = request.getParameter("bookingType");
            Date date = Date.valueOf(request.getParameter("bookingDate"));
            double total = Double.parseDouble(request.getParameter("totalAmount"));
            double initialPay = Double.parseDouble(request.getParameter("initialPayment"));

            Booking booking = new Booking(0, clientId, null, flatId, null, type, date, total, initialPay, "Confirmed", null);
            bookingDAO.addBooking(booking, initialPay);
        } else if ("addPayment".equals(action)) {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            double amount = Double.parseDouble(request.getParameter("amount"));
            Date date = Date.valueOf(request.getParameter("paymentDate"));
            String method = request.getParameter("paymentMethod");
            bookingDAO.addPayment(bookingId, amount, date, method);
        }
        response.sendRedirect("bookings");
    }
}