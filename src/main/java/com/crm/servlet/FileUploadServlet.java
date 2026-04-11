package com.crm.servlet;

import com.crm.util.DBConnection;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.File;
import java.io.IOException;
import java.sql.*;
import java.util.UUID;

@WebServlet("/upload")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class FileUploadServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userId");
        String type = request.getParameter("type"); // 'profile' or 'document'

        String applicationPath = request.getServletContext().getRealPath("");
        String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;
        
        File uploadDir = new File(uploadFilePath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        Part part = request.getPart("file");
        String fileName = getFileName(part);
        String uniqueName = UUID.randomUUID().toString() + "_" + fileName;

        try {
            part.write(uploadFilePath + File.separator + uniqueName);

            if ("profile".equals(type)) {
                updateProfileImage(userId, uniqueName, session);
                response.sendRedirect("dashboard.jsp");
            } else {
                String title = request.getParameter("title");
                saveDocument(title, fileName, uniqueName, userId);
                response.sendRedirect("documents.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=upload");
        }
    }

    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }

    private void updateProfileImage(String userId, String fileName, HttpSession session) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("UPDATE users SET profile_image = ? WHERE user_id = ?")) {
            ps.setString(1, fileName);
            ps.setString(2, userId);
            ps.executeUpdate();
            session.setAttribute("profileImage", fileName);
        }
    }

    private void saveDocument(String title, String originalName, String uniqueName, String userId) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("INSERT INTO documents (title, file_name, file_path, uploaded_by) VALUES (?, ?, ?, ?)")) {
            ps.setString(1, title);
            ps.setString(2, originalName);
            ps.setString(3, uniqueName);
            ps.setString(4, userId);
            ps.executeUpdate();
        }
    }
}