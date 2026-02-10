package com.servlets;

import com.corelogic.LoadBalancer;
import com.corelogic.VMNode;
import com.db.DBConnection;
import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/UploadTaskServlet")
@MultipartConfig
public class UploadTaskServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        Part filePart = req.getPart("file");
        String fileName = filePart.getSubmittedFileName();
        String algorithm = req.getParameter("algorithm");

        Integer userIdObj = (Integer) req.getSession().getAttribute("user_id");
        if (userIdObj == null) {
            resp.sendRedirect("login.jsp?error=Please login first");
            return;
        }
        int userId = userIdObj;

        // Read file
        BufferedReader reader =
                new BufferedReader(new InputStreamReader(filePart.getInputStream()));
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line).append("\n");
        }
        String fileData = sb.toString();

        Connection con = null;

        try {
            LoadBalancer lb = new LoadBalancer(req);

            if (lb.getVms().isEmpty()) {
                resp.sendRedirect("uploadTask.jsp?error=No active servers available");
                return;
            }

            // ✅ PICK SERVER BASED ON SELECTED ALGORITHM
            VMNode selectedVm;

            switch (algorithm) {
                case "RoundRobin":
                    selectedVm = lb.getRoundRobinServer();
                    break;

                case "Throttled":
                    selectedVm = lb.getThrottledServer();
                    break;

                case "Dynamic":
                    selectedVm = lb.getDynamicServer();
                    break;

                default:
                    selectedVm = lb.getLeastLoadedServer();
            }

            con = DBConnection.getConnection();

            // ✅ Insert task
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO tasks (user_id, server_id, file_name, file_data, algorithm_used) " +
                "VALUES (?, ?, ?, ?, ?)",
                Statement.RETURN_GENERATED_KEYS
            );

            ps.setInt(1, userId);
            ps.setInt(2, selectedVm.getId());
            ps.setString(3, fileName);
            ps.setString(4, lb.encrypt(fileData));
            ps.setString(5, algorithm);
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            int taskId = rs.next() ? rs.getInt(1) : 0;

            // ✅ UPDATE SERVER METRICS
            selectedVm.acceptTask();      // load +1
            selectedVm.increaseEnergy();  // energy +5%
            selectedVm.increaseTrust();   // trust +0.01

            lb.updateVmInDatabase(selectedVm);

            // ✅ Mark task completed after 5 seconds
            markTaskCompletedAfterDelay(taskId);

            con.close();
            resp.sendRedirect("myTasks.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().println("Upload failed: " + e.getMessage());
        } finally {
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }
    }

    // ✅ Change status after delay
    private void markTaskCompletedAfterDelay(final int taskId) {
        new Thread(() -> {
            try {
                Thread.sleep(5000); // 5 seconds

                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(
                    "UPDATE tasks SET status='Completed', completed_at=NOW() WHERE task_id=?"
                );
                ps.setInt(1, taskId);
                ps.executeUpdate();

                ps.close();
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }).start();
    }
}
