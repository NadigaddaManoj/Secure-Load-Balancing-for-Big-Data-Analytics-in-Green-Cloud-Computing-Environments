<%-- 
    Document   : userMenu
    Created on : 17 Oct, 2025, 12:50:28 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>JSP Page</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
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
        }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="title">Secure Load Balancing</div>
        <div class="nav-links">
            <a href="userHome.jsp">Home</a>
            <a href="uploadTask.jsp">Task</a>
        <a href="myTasks.jsp">My Tasks</a>
        <a href="cloudfiles.jsp">Cloud Files</a>
        <a href="requests.jsp">Requests</a>
        <a href="logout.jsp">Logout</a>
        </div>
    </div>
</body>
</html>
