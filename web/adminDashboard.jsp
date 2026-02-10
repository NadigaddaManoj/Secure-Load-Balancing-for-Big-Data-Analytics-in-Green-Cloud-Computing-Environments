<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
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
        .dashboard-content {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 600px;
            text-align: center;
        }
        .dashboard-content h2 {
            color: #BC77D0;
            margin-bottom: 20px;
        }
        .dashboard-content p {
            margin: 10px 0;
            line-height: 1.6;
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
            .dashboard-content {
                padding: 20px;
                max-width: 90%;
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
    <div class="dashboard-content">
        <h2>Welcome, Admin!</h2>
        <p>This is the admin dashboard. You can manage servers and view all tasks from the navigation menu.</p>
    </div>
</div>
<footer>&copy; 2025 Secure Load Balancing Project</footer>
</body>
</html>