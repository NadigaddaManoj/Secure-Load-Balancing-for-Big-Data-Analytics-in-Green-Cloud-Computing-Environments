<%@ page import="java.sql.*, com.db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>File Requests</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f7f7f7; }
        .navbar { background-color: #BC77D0; color: white; padding: 15px 20px; display: flex; justify-content: space-between; align-items: center; }
        .navbar .logo h1 { margin: 0; }
        .navbar .nav-links a { color: white; text-decoration: none; margin: 0 15px; font-weight: bold; }
        .section { padding: 20px; max-width: 1200px; margin: 0 auto; }
        .request-table { width: 100%; border-collapse: collapse; background-color: white; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .request-table th, .request-table td { padding: 12px; border: 1px solid #ddd; text-align: left; }
        .request-table th { background-color: #f0e6f7; }
        .btn { padding: 8px 12px; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; color: white; }
        .btn-accept { background-color: #28a745; }
        .btn-reject { background-color: #dc3545; }
        .btn:hover { opacity: 0.8; }
        footer { text-align: center; padding: 10px; background-color: #BC77D0; color: white; margin-top: 20px; }
    </style>
</head>
<body>
    <jsp:include page="userMenu.jsp" />
    <div class="section">
        <h2>Incoming File Requests</h2>
        <p>Manage requests from other users to download your files.</p>
        <table class="request-table">
            <thead>
                <tr>
                    <th>File Name</th>
                    <th>Requested By</th>
                    <th>Date</th>
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
                        String sql = "SELECT fr.request_id, t.file_name, u.name AS requester_name, fr.request_date " +
                                     "FROM file_requests fr " +
                                     "JOIN tasks t ON fr.task_id = t.task_id " +
                                     "JOIN users u ON fr.requester_id = u.user_id " +
                                     "WHERE fr.owner_id = ? AND fr.status = 'pending'";
                        PreparedStatement ps = con.prepareStatement(sql);
                        ps.setInt(1, currentUserId);
                        ResultSet rs = ps.executeQuery();

                        while (rs.next()) {
                            int requestId = rs.getInt("request_id");
                            String fileName = rs.getString("file_name");
                            String requesterName = rs.getString("requester_name");
                            Timestamp requestDate = rs.getTimestamp("request_date");
                %>
                <tr>
                    <td><%= fileName %></td>
                    <td><%= requesterName %></td>
                    <td><%= requestDate %></td>
                    <td>
                        <a href="HandleRequestServlet?request_id=<%= requestId %>&action=accept" class="btn btn-accept">Accept</a>
                        <a href="HandleRequestServlet?request_id=<%= requestId %>&action=reject" class="btn btn-reject">Reject</a>
                    </td>
                </tr>
                <%
                        }
                        con.close();
                    } catch (Exception e) {
                        out.println("<tr><td colspan='4'>Error loading requests: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </tbody>
        </table>
    </div>
    <footer>&copy; 2025 Secure Load Balancing Project</footer>
</body>
</html>
