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
import javax.servlet.http.HttpSession;

@WebServlet("/DownloadFileServlet")
public class DownloadFileServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int taskId = Integer.parseInt(request.getParameter("task_id"));
            Connection con = DBConnection.getConnection();

            // Check if the user has an accepted request for this file
            String checkSql = "SELECT * FROM file_requests WHERE task_id = ? AND requester_id = ? AND status = 'accepted'";
            PreparedStatement checkPs = con.prepareStatement(checkSql);
            checkPs.setInt(1, taskId);
            checkPs.setInt(2, userId);
            ResultSet checkRs = checkPs.executeQuery();

            if (checkRs.next()) {
                // If request is valid, get the file data
                String getFileSql = "SELECT file_name, file_data FROM tasks WHERE task_id = ?";
                PreparedStatement getFilePs = con.prepareStatement(getFileSql);
                getFilePs.setInt(1, taskId);
                ResultSet fileRs = getFilePs.executeQuery();

                if (fileRs.next()) {
                    String fileName = fileRs.getString("file_name");
                    String encryptedData = fileRs.getString("file_data");

                    // Decrypt the file data
                    LoadBalancer lb = new LoadBalancer(request);
                    String decryptedData = lb.decrypt(encryptedData);

                    // Set response headers for file download
                    response.setContentType("application/octet-stream");
                    response.setHeader("Content-Disposition", "attachment;filename=" + fileName);

                    // Write the file content to the response
                    OutputStream out = response.getOutputStream();
                    out.write(decryptedData.getBytes());
                    out.flush();
                    out.close();
                }
                fileRs.close();
                getFilePs.close();
            } else {
                response.sendRedirect("cloudfiles.jsp?error=You do not have permission to download this file.");
            }
            checkRs.close();
            checkPs.close();
            con.close();
        } catch (Exception e) {
            response.getWriter().println("Error downloading file: " + e.getMessage());
        }
    }
}
