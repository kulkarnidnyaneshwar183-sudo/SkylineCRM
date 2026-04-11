package com.crm.servlet;

import com.crm.dao.TaskDAO;
import com.crm.dao.UserDAO;
import com.crm.model.Task;
import com.crm.model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/tasks")
public class TaskServlet extends HttpServlet {
    private TaskDAO taskDAO = new TaskDAO();
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("complete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            taskDAO.updateTaskStatus(id, "Completed");
            response.sendRedirect("tasks");
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            taskDAO.deleteTask(id);
            response.sendRedirect("tasks");
        } else {
            List<Task> tasks = taskDAO.getAllTasks();
            List<User> users = userDAO.getAllUsers();
            request.setAttribute("taskList", tasks);
            request.setAttribute("userList", users);
            request.getRequestDispatcher("tasks.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String assignedTo = request.getParameter("assignedTo");
            Date deadline = Date.valueOf(request.getParameter("deadline"));

            Task task = new Task(0, title, description, assignedTo, null, deadline, "Pending", null);
            taskDAO.addTask(task);
        }
        response.sendRedirect("tasks");
    }
}