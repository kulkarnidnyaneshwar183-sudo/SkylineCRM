package com.crm.servlet;

import com.crm.dao.ClientDAO;
import com.crm.model.Client;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/clients")
public class ClientServlet extends HttpServlet {
    private ClientDAO clientDAO = new ClientDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Client> clients = clientDAO.getAllClients();
        request.setAttribute("clientList", clients);
        request.getRequestDispatcher("clients.jsp").forward(request, response);
    }
}