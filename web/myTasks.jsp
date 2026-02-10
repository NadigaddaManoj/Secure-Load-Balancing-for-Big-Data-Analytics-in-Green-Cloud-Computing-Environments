<%@ page import="java.sql.*, com.db.DBConnection, com.corelogic.LoadBalancer" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>My Tasks</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f7f7f7; }
        .navbar { background-color: #BC77D0; color: white; padding: 15px 20px; display: flex; justify-content: space-between; align-items: center; }
        .navbar .logo h1 { margin: 0; font-size: 24px; }
        .navbar .nav-links a { color: white; text-decoration: none; margin: 0 15px; font-weight: bold; }
        .navbar .nav-links a:hover { text-decoration: underline; }
        .section { padding: 50px 20px; max-width: 1200px; margin: 0 auto; }
        .section h2 { color: #BC77D0; }
        table { border-collapse: collapse; width: 100%; margin-bottom: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #BC77D0; color: white; }
        .btn { background-color: #BC77D0; color: white; padding: 5px 10px; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; text-decoration: none; display: inline-block; }
        .btn:hover { opacity: 0.8; }
        .delete-btn { background-color: #ff4444; margin-left: 10px; }
        .delete-btn:hover { background-color: #cc0000; }
        @media (max-width: 768px) { .navbar { flex-direction: column; text-align: center; } .navbar .nav-links a { margin: 10px 0; } .section { padding: 20px; } }
    </style>
</head>
<body>
<jsp:include page="userMenu.jsp" />
<div class="section">
    <h2>My Tasks</h2>
    <table border="1">
        <tr><th>ID</th><th>File</th><th>Status</th><th>Algorithm</th><th>Action</th></tr>
        <%
            int userId = (Integer) session.getAttribute("user_id");
            boolean isAdmin = session.getAttribute("is_admin") != null && (boolean) session.getAttribute("is_admin");
            if (userId == 0) {
                response.sendRedirect("login.jsp");
                return;
            }
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM tasks WHERE user_id = ?");
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int taskId = rs.getInt("task_id");
                int taskUserId = rs.getInt("user_id"); // Get the user_id of the task
        %>
        <tr>
            <td><%= taskId %></td>
            <td><%= rs.getString("file_name") %></td>
            <td><%= rs.getString("status") %></td>
            <td><%= rs.getString("algorithm_used") %></td>
            <td>
                <a href="viewEncryptedData.jsp?task_id=<%= taskId %>" class="btn">View Encrypted Data</a>
                <% if (isAdmin || userId == taskUserId) { %>
                    <a href="DeleteTaskServlet?task_id=<%= taskId %>" class="btn delete-btn" onclick="return confirm('Are you sure you want to delete this task?')">Delete</a>
                <% } %>
            </td>
        </tr>
        <% } con.close(); %>
    </table>
</div>
<footer>&copy; 2025 Secure Load Balancing Project</footer>
</body>
</html>