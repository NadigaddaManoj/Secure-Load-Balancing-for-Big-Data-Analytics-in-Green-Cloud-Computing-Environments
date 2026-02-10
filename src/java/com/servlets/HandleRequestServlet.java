package com.servlets;

import com.db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/HandleRequestServlet")
public class HandleRequestServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer ownerId = (Integer) session.getAttribute("user_id");

        if (ownerId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int requestId = Integer.parseInt(request.getParameter("request_id"));
            String action = request.getParameter("action");
            String newStatus = "";

            if ("accept".equals(action)) {
                newStatus = "accepted";
            } else if ("reject".equals(action)) {
                newStatus = "rejected";
            } else {
                response.sendRedirect("requests.jsp?error=Invalid action");
                return;
            }

            Connection con = DBConnection.getConnection();
            // Ensure the user owns the file associated with the request before updating
            String sql = "UPDATE file_requests SET status = ? WHERE request_id = ? AND owner_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, newStatus);
            ps.setInt(2, requestId);
            ps.setInt(3, ownerId);
            ps.executeUpdate();
            con.close();

            response.sendRedirect("requests.jsp?message=Request " + newStatus);
        } catch (Exception e) {
            response.sendRedirect("requests.jsp?error=Failed to handle request: " + e.getMessage());
        }
    }
}
