package com.servlets;

import com.corelogic.LoadBalancer;
import com.db.DBConnection;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/CloudFileDownloadServlet")
public class CloudFileDownloadServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int taskId = Integer.parseInt(request.getParameter("task_id"));
            Connection con = DBConnection.getConnection();

            // Get file info
            String sql = "SELECT file_name, file_data FROM tasks WHERE task_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, taskId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String fileName = rs.getString("file_name");
                String encryptedData = rs.getString("file_data");

                // Prepare download headers
                response.setContentType("application/octet-stream");
                response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
                response.setCharacterEncoding("UTF-8");

                // TRY DECRYPTION FIRST
                String downloadContent = encryptedData; // Default to encrypted if decryption fails
                try {
                    LoadBalancer lb = new LoadBalancer(request);
                    String decryptedData = lb.decrypt(encryptedData);
                    if (decryptedData != null && !decryptedData.isEmpty()) {
                        downloadContent = decryptedData;
                        System.out.println("✓ Decryption successful for task_id: " + taskId);
                    }
                } catch (Exception e) {
                    System.out.println("⚠ Decryption failed for task_id: " + taskId + " - Downloading encrypted data");
                    // FALLBACK: Download encrypted data as-is
                }

                // Write content to response
                try (OutputStream out = response.getOutputStream()) {
                    out.write(downloadContent.getBytes("UTF-8"));
                    out.flush();
                    System.out.println("✓ File downloaded: " + fileName + " (" + downloadContent.length() + " bytes)");
                }

            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().println("File not found for task_id: " + taskId);
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().println("Download error: " + e.getMessage());
        }
    }
}