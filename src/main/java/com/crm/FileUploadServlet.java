package com.crm;

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
        if (userId == null) {
            response.sendRedirect("login");
            return;
        }

        String type = request.getParameter("type"); // profile or document
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        Part filePart = request.getPart("file");
        String fileName = getFileName(filePart);
        String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
        String filePath = uploadPath + File.separator + uniqueFileName;

        try {
            filePart.write(filePath);
            
            if ("profile".equals(type)) {
                updateProfileImage(userId, uniqueFileName);
                session.setAttribute("profileImage", uniqueFileName);
                response.sendRedirect("dashboard.jsp?upload=success");
            } else if ("document".equals(type)) {
                String title = request.getParameter("title");
                saveDocumentInfo(userId, title, fileName, uniqueFileName);
                response.sendRedirect("documents.jsp?upload=success");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?upload=error");
        }
    }

    private String getFileName(Part part) {
        for (String content : part.getHeader("content-disposition").split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf("=") + 2, content.length() - 1);
            }
        }
        return "default.file";
    }

    private void updateProfileImage(String userId, String fileName) throws SQLException {
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("UPDATE users SET profile_image = ? WHERE user_id = ?");
            ps.setString(1, fileName);
            ps.setString(2, userId);
            ps.executeUpdate();
        }
    }

    private void saveDocumentInfo(String userId, String title, String originalName, String uniqueName) throws SQLException {
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("INSERT INTO documents (title, file_name, file_path, uploaded_by) VALUES (?, ?, ?, ?)");
            ps.setString(1, title);
            ps.setString(2, originalName);
            ps.setString(3, uniqueName);
            ps.setString(4, userId);
            ps.executeUpdate();
        }
    }
}