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
    /* Responsive Design */
    @media (max-width: 768px) {
        .navbar {
            flex-direction: column;
            text-align: center;
        }
        .navbar .nav-links a {
            margin: 10px 0;
        }
    }
</style>
<div class="navbar">
    <div class="logo"><h1>Green Cloud LB</h1></div>
    <div class="nav-links">
        <a href="index.jsp">Home</a>
        <a href="register.jsp">Register</a>
        <a href="login.jsp">Login</a>
        <a href="adminLogin.jsp">Admin</a>
    </div>
</div>
