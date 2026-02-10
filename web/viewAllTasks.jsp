<%@ page import="java.sql.*, com.db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>All Tasks</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f7f7f7;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .navbar {
            background-color: #BC77D0;
            color: white;
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        .navbar .title {
            margin: 0;
            font-size: 24px;
            font-weight: bold;
        }
        .navbar .nav-links a {
            color: white;
            text-decoration: none;
            margin: 0 15px;
            font-weight: bold;
            transition: color 0.3s;
        }
        .navbar .nav-links a:hover {
            color: #f0e6f7;
            text-decoration: underline;
        }
        .section {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            padding: 20px;
        }
        .tasks-table {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 800px;
            text-align: center;
        }
        .tasks-table table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 0;
        }
        .tasks-table th, .tasks-table td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: left;
        }
        .tasks-table th {
            background-color: #BC77D0;
            color: white;
        }
        footer {
            text-align: center;
            padding: 10px;
            background-color: #BC77D0;
            color: white;
            margin-top: auto;
        }
        @media (max-width: 768px) {
            .navbar {
                flex-direction: column;
                text-align: center;
                padding: 10px;
            }
            .navbar .nav-links a {
                margin: 10px 0;
            }
            .navbar .title {
                margin-bottom: 10px;
            }
            .section {
                padding: 10px;
            }
            .tasks-table {
                padding: 15px;
                max-width: 100%;
            }
            .tasks-table th, .tasks-table td {
                padding: 8px;
                font-size: 14px;
            }
        }
    </style>
</head>
<body>
<%
    if (session.getAttribute("admin_user") == null) {
        response.sendRedirect("adminLogin.jsp");
        return;
    }
%>
<jsp:include page="adminMenu.jsp" /> <!-- Corrected from adminMenu.jsp to adminNavbar.jsp -->
<div class="section">
    <div class="tasks-table">
        <h2>All Tasks</h2>
        <table border="1">
            <tr><th>ID</th><th>User</th><th>File</th><th>Server</th><th>Status</th></tr>
            <%
                Connection con = null;
                ResultSet rs = null;
                try {
                    con = DBConnection.getConnection();
                    // Join tasks, users, and servers to get server_name
                    rs = con.createStatement().executeQuery(
                        "SELECT t.*, u.name, s.server_name " +
                        "FROM tasks t " +
                        "JOIN users u ON t.user_id = u.user_id " +
                        "LEFT JOIN servers s ON t.server_id = s.server_id"
                    );
                    while (rs.next()) { %>
            <tr>
                <td><%= rs.getInt("task_id") %></td>
                <td><%= rs.getString("name") != null ? rs.getString("name") : "N/A" %></td>
                <td><%= rs.getString("file_name") != null ? rs.getString("file_name") : "N/A" %></td>
                <td><%= rs.getString("server_name") != null ? rs.getString("server_name") : "N/A" %></td>
                <td><%= rs.getString("status") != null ? rs.getString("status") : "N/A" %></td>
            </tr>
            <% }
            } catch (SQLException e) {
                out.println("<tr><td colspan='5'>Error fetching tasks: " + e.getMessage() + "</td></tr>");
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException e) { }
                if (con != null) try { con.close(); } catch (SQLException e) { }
            }
            %>
        </table>
    </div>
</div>
<footer>&copy; 2025 Secure Load Balancing Project</footer>
</body>
</html>