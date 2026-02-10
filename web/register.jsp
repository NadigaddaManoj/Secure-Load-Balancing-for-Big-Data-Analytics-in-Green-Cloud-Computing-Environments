<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register</title>
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
        .navbar .logo h1 {
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
        .register-form {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px;
            text-align: center;
        }
        .register-form table {
            width: 100%;
            margin-bottom: 20px;
        }
        .register-form td {
            padding: 10px;
            text-align: left;
        }
        .register-form input[type="text"],
        .register-form input[type="password"],
        .register-form input[type="email"],
        .register-form input[type="date"],
        .register-form select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .register-form input[type="text"]:focus,
        .register-form input[type="password"]:focus,
        .register-form input[type="email"]:focus,
        .register-form input[type="date"]:focus,
        .register-form select:focus {
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
            .navbar .logo h1 {
                margin-bottom: 10px;
            }
            .section {
                padding: 10px;
            }
            .register-form {
                padding: 20px;
                max-width: 300px;
            }
        }
    </style>
</head>
<body>
<jsp:include page="menu.jsp" />
<div class="section">
    <div class="register-form">
        <h2>Register</h2>
        <form action="RegisterServlet" method="post">
            <table>
                <tr><td>Name:</td><td><input type="text" name="name" required></td></tr>
                <tr><td>Password:</td><td><input type="password" name="password" required></td></tr>
                <tr><td>Email:</td><td><input type="email" name="email" required></td></tr>
                <tr><td>Mobile:</td><td><input type="text" name="mobile" pattern="[6789][0-9]{9}" title="Mobile number must start with 6, 7, 8, or 9 and be 10 digits" required></td></tr>
                <tr><td>Address:</td><td><input type="text" name="address" required></td></tr>
                <tr><td>DOB:</td><td><input type="date" name="dob" required></td></tr>
                <tr><td>Gender:</td><td><select name="gender"><option value="Male">Male</option><option value="Female">Female</option></select></td></tr>
                <tr><td>Pincode:</td><td><input type="text" name="pincode" pattern="[0-9]{6}" title="Pincode must be 6 digits" required></td></tr>
                <tr><td colspan="2"><input type="submit" class="btn" value="Register"></td></tr>
            </table>
        </form>
    </div>
</div>
<footer>&copy; 2025 Secure Load Balancing Project</footer>
</body>
</html>