import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    // Show login page
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp")
                .forward(request, response);
    }

    // Handle login form submit
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT * FROM users WHERE username=? " +
                    "AND password=? AND status='Active'";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Login success
                HttpSession session = request.getSession();
                session.setAttribute("userId", rs.getString("user_id"));
                session.setAttribute("fullName", rs.getString("full_name"));
                session.setAttribute("role", rs.getString("role"));

                response.sendRedirect("dashboard.jsp");
            } else {
                // Login failed
                request.setAttribute("error",
                        "Invalid username or password!");
                request.getRequestDispatcher("login.jsp")
                        .forward(request, response);
            }
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}