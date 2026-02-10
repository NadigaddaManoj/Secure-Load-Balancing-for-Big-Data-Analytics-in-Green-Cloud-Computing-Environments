<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    /* Navbar */
    .navbar {
        background-color: #BC77D0;
        color: white;
        padding: 15px 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .navbar .logo h1 {
        margin: 0;
        font-size: 24px;
    }
    .navbar .nav-links a {
        color: white;
        text-decoration: none;
        margin: 0 15px;
        font-weight: bold;
    }
    .navbar .nav-links a:hover {
        text-decoration: underline;
    }
</style>
<div class="navbar">
    <div class="logo"><h1>Green Cloud LB - Admin</h1></div>
    <div class="nav-links">
        <a href="adminDashboard.jsp">Home</a>
        <a href="addServer.jsp">Add Server</a>
        <a href="viewServers.jsp">Servers</a>
        <a href="viewAllTasks.jsp">All Tasks</a>
        <a href="logout.jsp">Logout</a>
    </div>
</div>
