package com.servlets;

import com.db.DBConnection;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            /* ========== ADD SERVER ========== */
            if ("addServer".equals(action)) {

                String serverName = req.getParameter("server_name");
                int capacity = Integer.parseInt(req.getParameter("capacity"));

                ps = con.prepareStatement(
                    "INSERT INTO servers (server_name, capacity, current_load, energy_usage, trust_score, status) " +
                    "VALUES (?, ?, 0, 0, 0.5, 'Inactive')"
                );
                ps.setString(1, serverName);
                ps.setInt(2, capacity);
                ps.executeUpdate();

            /* ========== ACTIVATE SERVER ========== */
            } else if ("activateServer".equals(action)) {

                int serverId = Integer.parseInt(req.getParameter("server_id"));
                ps = con.prepareStatement(
                    "UPDATE servers SET status='Active' WHERE server_id=?"
                );
                ps.setInt(1, serverId);
                ps.executeUpdate();

            /* ========== DEACTIVATE SERVER ========== */
            } else if ("deactivateServer".equals(action)) {

                int serverId = Integer.parseInt(req.getParameter("server_id"));
                ps = con.prepareStatement(
                    "UPDATE servers SET status='Inactive' WHERE server_id=?"
                );
                ps.setInt(1, serverId);
                ps.executeUpdate();

            /* ========== DELETE SERVER (FINAL FIX) ========== */
            } else if ("deleteServer".equals(action)) {

                int serverId = Integer.parseInt(req.getParameter("server_id"));

                /* 1️⃣ DELETE file_requests (child of tasks) */
                ps = con.prepareStatement(
                    "DELETE FROM file_requests WHERE task_id IN " +
                    "(SELECT task_id FROM tasks WHERE server_id = ?)"
                );
                ps.setInt(1, serverId);
                ps.executeUpdate();

                /* 2️⃣ DELETE energy_log */
                ps = con.prepareStatement(
                    "DELETE FROM energy_log WHERE server_id = ?"
                );
                ps.setInt(1, serverId);
                ps.executeUpdate();

                /* 3️⃣ DELETE trust_log */
                ps = con.prepareStatement(
                    "DELETE FROM trust_log WHERE server_id = ?"
                );
                ps.setInt(1, serverId);
                ps.executeUpdate();

                /* 4️⃣ DELETE tasks */
                ps = con.prepareStatement(
                    "DELETE FROM tasks WHERE server_id = ?"
                );
                ps.setInt(1, serverId);
                ps.executeUpdate();

                /* 5️⃣ DELETE server */
                ps = con.prepareStatement(
                    "DELETE FROM servers WHERE server_id = ?"
                );
                ps.setInt(1, serverId);
                ps.executeUpdate();
            }

            con.commit();
            resp.sendRedirect("viewServers.jsp");

        } catch (Exception e) {
            try { if (con != null) con.rollback(); } catch (Exception ignored) {}
            e.printStackTrace();
            resp.getWriter().println("Error: " + e.getMessage());

        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }
    }
}
