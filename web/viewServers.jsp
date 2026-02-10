<%@ page import="java.sql.*, com.db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>View Servers</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background-color: #f7f7f7;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .navbar {
            background-color: #BC77D0;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .section {
            flex: 1;
            display: flex;
            justify-content: center;
            padding: 30px;
        }

        .servers-table {
            background: white;
            padding: 25px;
            border-radius: 10px;
            width: 100%;
            max-width: 950px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        .servers-table h2 {
            color: #BC77D0;
            text-align: center;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: center;
        }

        th {
            background-color: #BC77D0;
            color: white;
        }

        .btn {
            background-color: #BC77D0;
            color: white;
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .btn:hover {
            opacity: 0.85;
        }

        .add-server-btn {
            background-color: #4CAF50;
            color: white;
            padding: 8px 15px;
            text-decoration: none;
            border-radius: 5px;
            margin-bottom: 15px;
            display: inline-block;
        }

        footer {
            background-color: #BC77D0;
            color: white;
            text-align: center;
            padding: 10px;
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

<jsp:include page="adminMenu.jsp" />

<div class="section">
    <div class="servers-table">
        <h2>Servers</h2>

        <a href="serverRoom.jsp" class="add-server-btn" style="background-color:#2196F3;">Server Room</a>

        <a href="addServer.jsp" class="add-server-btn">Add Server</a>
        

        <table>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Load / Capacity</th>
                <th>Energy</th>
                <th>Trust</th>
                <th>Status</th>
                <th>Action</th>
            </tr>

            <%
                Connection con = null;
                ResultSet rs = null;

                try {
                    con = DBConnection.getConnection();
                    rs = con.createStatement().executeQuery(
                        "SELECT server_id, server_name, current_load, capacity, energy_usage, trust_score, status FROM servers"
                    );

                    while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getInt("server_id") %></td>
                <td><%= rs.getString("server_name") %></td>

                <!-- ✅ LOAD / CAPACITY -->
                <td>
                    <%= rs.getInt("current_load") %> / <%= rs.getInt("capacity") %>
                </td>

                <td><%= rs.getFloat("energy_usage") %></td>
                <td><%= rs.getFloat("trust_score") %></td>
                <td><%= rs.getString("status") %></td>

                <td>
                    <form action="AdminServlet" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="deleteServer">
                        <input type="hidden" name="server_id" value="<%= rs.getInt("server_id") %>">
                        <input type="submit" class="btn" value="Delete">
                    </form>

                    <% if ("Inactive".equals(rs.getString("status"))) { %>
                    <form action="AdminServlet" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="activateServer">
                        <input type="hidden" name="server_id" value="<%= rs.getInt("server_id") %>">
                        <input type="submit" class="btn" value="Activate">
                    </form>
                    <% } else { %>
                    <form action="AdminServlet" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="deactivateServer">
                        <input type="hidden" name="server_id" value="<%= rs.getInt("server_id") %>">
                        <input type="submit" class="btn" value="Deactivate">
                    </form>
                    <% } %>
                </td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    out.println("<tr><td colspan='7'>Error: " + e.getMessage() + "</td></tr>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (Exception e) {}
                    if (con != null) try { con.close(); } catch (Exception e) {}
                }
            %>
        </table>
    </div>
</div>

<footer>&copy; 2025 Secure Load Balancing Project</footer>

</body>
</html>
