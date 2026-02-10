package com.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.db.DBConnection;
import java.util.logging.Logger;
import java.util.logging.Level;

@WebServlet("/DeleteTaskServlet")
public class DeleteTaskServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(DeleteTaskServlet.class.getName());

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is authorized (admin or task owner)
        Integer userId = (Integer) request.getSession().getAttribute("user_id");
        Boolean isAdmin = (Boolean) request.getSession().getAttribute("is_admin");

        if (userId == null) {
            LOGGER.warning("User ID is null in session");
            response.sendRedirect("myTasks.jsp?error=Session expired, please login again");
            return;
        }
        if (isAdmin == null) {
            isAdmin = false; // Default to non-admin if not set
        }
        if (!isAdmin && userId == null) { // Should never happen due to earlier check
            response.sendRedirect("myTasks.jsp?error=Unauthorized access");
            return;
        }

        // Get task_id parameter
        int taskId;
        try {
            taskId = Integer.parseInt(request.getParameter("task_id"));
        } catch (NumberFormatException e) {
            LOGGER.warning("Invalid task_id parameter: " + request.getParameter("task_id"));
            response.sendRedirect("myTasks.jsp?error=Invalid task ID");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        PreparedStatement checkPs = null;
        PreparedStatement deleteLogPs = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            // Verify the task belongs to the user or user is admin
            checkPs = con.prepareStatement("SELECT user_id FROM tasks WHERE task_id = ?");
            checkPs.setInt(1, taskId);
            rs = checkPs.executeQuery();
            if (rs.next()) {
                Integer taskUserId = rs.getInt("user_id");
                if (taskUserId == null) {
                    LOGGER.warning("Task user_id is null for task_id: " + taskId);
                    response.sendRedirect("myTasks.jsp?error=Invalid task data");
                    return;
                }
                if (!isAdmin && !userId.equals(taskUserId)) {
                    response.sendRedirect("myTasks.jsp?error=Unauthorized access");
                    return;
                }
            } else {
                response.sendRedirect("myTasks.jsp?error=Task not found");
                return;
            }

            // Delete related energy_log entries first
            deleteLogPs = con.prepareStatement("DELETE FROM energy_log WHERE task_id = ?");
            deleteLogPs.setInt(1, taskId);
            int logRowsAffected = deleteLogPs.executeUpdate();
            LOGGER.info("Deleted " + logRowsAffected + " energy log entries for task_id: " + taskId);

            // Delete the task
            ps = con.prepareStatement("DELETE FROM tasks WHERE task_id = ?");
            ps.setInt(1, taskId);
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected == 0) {
                LOGGER.warning("No rows deleted for task_id: " + taskId);
                response.getWriter().println("Task not found or already deleted.");
            } else {
                response.sendRedirect("myTasks.jsp?message=Task deleted successfully");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQL Error deleting task: taskId=" + taskId, e);
            response.getWriter().println("Error deleting task: " + e.getMessage());
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(DeleteTaskServlet.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { }
            if (checkPs != null) try { checkPs.close(); } catch (SQLException e) { }
            if (deleteLogPs != null) try { deleteLogPs.close(); } catch (SQLException e) { }
            if (ps != null) try { ps.close(); } catch (SQLException e) { }
            if (con != null) try { con.close(); } catch (SQLException e) { }
        }
    }
}