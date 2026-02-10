<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<% 
    String email=(String)session.getAttribute("email");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Home</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f7f7f7; }
        .content { padding: 50px 20px; max-width: 1200px; margin: 0 auto; text-align: center; }
    </style>
</head>
<body>
<jsp:include page="userMenu.jsp" />
<div class="content">
    <h2>Welcome to Secure Load Balancing <%= email%></h2>
    <p>This is your home dashboard. Manage your tasks and monitor performance.</p>
</div>
<footer>&copy; 2025 Secure Load Balancing Project</footer>
</body>
</html>