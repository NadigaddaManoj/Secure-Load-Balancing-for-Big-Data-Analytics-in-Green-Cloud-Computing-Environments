<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add Server</title>
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
            align-items: center;
            padding: 20px;
        }
        .add-server-form {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
            text-align: center;
        }
        .add-server-form table {
            width: 100%;
            margin-bottom: 20px;
        }
        .add-server-form td {
            padding: 10px;
            text-align: left;
        }
        .add-server-form input[type="text"],
        .add-server-form input[type="number"] {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .add-server-form input[type="text"]:focus,
        .add-server-form input[type="number"]:focus {
            border-color: #BC77D0;
            outline: none;
        }
        .btn {
            background-color: #BC77D0;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
            text-decoration: none;
            display: inline-block;
            transition: opacity 0.3s;
        }
        .btn:hover {
            opacity: 0.8;
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
            .add-server-form {
                padding: 20px;
                max-width: 300px;
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
    <div class="add-server-form">
        <h2>Add Server</h2>
        <form action="AdminServlet" method="post">
            <input type="hidden" name="action" value="addServer">
            <table>
                <tr><td>Name:</td><td><input type="text" name="server_name" required></td></tr>
                <tr><td>Capacity:</td><td><input type="number" name="capacity" min="1" required></td></tr>
                <tr><td colspan="2"><input type="submit" class="btn" value="Add"></td></tr>
            </table>
        </form>
    </div>
</div>
<footer>&copy; 2025 Secure Load Balancing Project</footer>
</body>
</html>
