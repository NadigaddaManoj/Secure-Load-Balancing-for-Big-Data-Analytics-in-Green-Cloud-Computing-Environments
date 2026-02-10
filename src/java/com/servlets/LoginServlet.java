package com.servlets;

import com.db.DBConnection;
import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE email = ? AND password = ?");
            ps.setString(1, req.getParameter("email"));
            ps.setString(2, req.getParameter("password"));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                HttpSession session = req.getSession();
                session.setAttribute("user_id", rs.getInt("user_id"));
                session.setAttribute("email", rs.getString("email"));
                resp.sendRedirect("userHome.jsp");
            } else {
                // Invalid credentials
                resp.sendRedirect("login.jsp?error=1");
            }
            con.close();
        } catch (Exception e) {
            // Database or other error
            e.printStackTrace(); // Log the error for the developer
            resp.sendRedirect("login.jsp?error=2");
        }
    }
}
