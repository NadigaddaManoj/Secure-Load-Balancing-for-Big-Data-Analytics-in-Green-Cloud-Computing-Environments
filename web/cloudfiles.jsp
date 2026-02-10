<%@ page import="java.sql.*, com.db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Cloud Files</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f7f7f7; }
        .navbar { background-color: #BC77D0; color: white; padding: 15px 20px; display: flex; justify-content: space-between; align-items: center; }
        .navbar .logo h1 { margin: 0; }
        .navbar .nav-links a { color: white; text-decoration: none; margin: 0 15px; font-weight: bold; }
        .section { padding: 20px; max-width: 1200px; margin: 0 auto; }
        .file-table { width: 100%; border-collapse: collapse; background-color: white; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .file-table th, .file-table td { padding: 12px; border: 1px solid #ddd; text-align: left; }
        .file-table th { background-color: #f0e6f7; }
        .btn { background-color: #BC77D0; color: white; padding: 8px 12px; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; }
        .btn:hover { opacity: 0.8; }
        footer { text-align: center; padding: 10px; background-color: #BC77D0; color: white; margin-top: 20px; }
    </style>
</head>
<body>
    <jsp:include page="userMenu.jsp" />
    <div class="section">
        <h2>Cloud Files</h2>
        <p>Browse files uploaded by other users and request access to download them.</p>
        <table class="file-table">
            <thead>
                <tr>
                    <th>File Name</th>
                    <th>Uploaded By</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Integer currentUserId = (Integer) session.getAttribute("user_id");
                    if (currentUserId == null) {
                        response.sendRedirect("login.jsp");
                        return;
                    }

                    try {
                        Connection con = DBConnection.getConnection();
                        // Join with file_requests to get the status for the current user
                        String sql = "SELECT t.task_id, t.file_name, u.name AS owner_name, t.user_id AS owner_id, fr.status " +
                                     "FROM tasks t " +
                                     "JOIN users u ON t.user_id = u.user_id " +
                                     "LEFT JOIN file_requests fr ON t.task_id = fr.task_id AND fr.requester_id = ? " +
                                     "WHERE t.user_id != ?";
                        PreparedStatement ps = con.prepareStatement(sql);
                        ps.setInt(1, currentUserId);
                        ps.setInt(2, currentUserId);
                        ResultSet rs = ps.executeQuery();

                        while (rs.next()) {
                            int taskId = rs.getInt("task_id");
                            String fileName = rs.getString("file_name");
                            String ownerName = rs.getString("owner_name");
                            int ownerId = rs.getInt("owner_id");
                            String status = rs.getString("status");
                %>
                <tr>
                    <td><%= fileName %></td>
                    <td><%= ownerName %></td>
                    <td>
                        <% if (status == null) { %>
                            <a href="SendRequestServlet?task_id=<%= taskId %>&owner_id=<%= ownerId %>" class="btn">Send Request</a>
                        <% } else if ("pending".equals(status)) { %>
                            <button class="btn" disabled>Requested</button>
                        <% } else if ("accepted".equals(status)) { %>
                            <a href="CloudFileDownloadServlet?task_id=<%= taskId %>" class="btn" style="background-color: #28a745;">Download</a>
                        <% } else if ("rejected".equals(status)) { %>
                            <button class="btn" disabled style="background-color: #dc3545;">Rejected</button>
                        <% } %>
                    </td>
                </tr>
                <%
                        }
                        con.close();
                    } catch (Exception e) {
                        out.println("<tr><td colspan='3'>Error loading files: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </tbody>
        </table>
    </div>
    <footer>&copy; 2025 Secure Load Balancing Project</footer>
</body>
</html>
