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

@WebServlet("/SendRequestServlet")
public class SendRequestServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer requesterId = (Integer) session.getAttribute("user_id");

        if (requesterId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int taskId = Integer.parseInt(request.getParameter("task_id"));
            int ownerId = Integer.parseInt(request.getParameter("owner_id"));

            Connection con = DBConnection.getConnection();
            String sql = "INSERT INTO file_requests (task_id, requester_id, owner_id) VALUES (?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, taskId);
            ps.setInt(2, requesterId);
            ps.setInt(3, ownerId);
            ps.executeUpdate();
            con.close();

            response.sendRedirect("cloudfiles.jsp?message=Request sent successfully!");
        } catch (Exception e) {
            response.sendRedirect("cloudfiles.jsp?error=Failed to send request: " + e.getMessage());
        }
    }
}
