package com.servlets;

import com.db.DBConnection;
import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("INSERT INTO users (name, password, email, mobile, address, dob, gender, pincode) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
            ps.setString(1, req.getParameter("name"));
            ps.setString(2, req.getParameter("password"));
            ps.setString(3, req.getParameter("email"));
            ps.setString(4, req.getParameter("mobile"));
            ps.setString(5, req.getParameter("address"));
            ps.setString(6, req.getParameter("dob"));
            ps.setString(7, req.getParameter("gender"));
            ps.setString(8, req.getParameter("pincode"));
            ps.executeUpdate();
            con.close();
            resp.sendRedirect("login.jsp");
        } catch (Exception e) {
            resp.getWriter().println("Error: " + e.getMessage());
        }
    }
}