<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Upload Task</title>
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
        .upload-form {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
            text-align: center;
        }
        .upload-form table {
            width: 100%;
            margin-bottom: 20px;
        }
        .upload-form td {
            padding: 10px;
            text-align: left;
        }
        .upload-form select, .upload-form input[type="file"] {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .upload-form .error-message {
            color: #d32f2f;
            margin-bottom: 15px;
            padding: 10px;
            background-color: #ffebee;
            border-radius: 4px;
            display: <%= request.getParameter("error") != null ? "block" : "none" %>;
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
            .upload-form {
                padding: 20px;
                max-width: 300px;
            }
        }
    </style>
</head>
<body>
<jsp:include page="userMenu.jsp" />
<div class="section">
    <div class="upload-form">
        <h2>Upload .txt Task</h2>
        <% String error = request.getParameter("error");
           if (error != null) { %>
            <div class="error-message"><%= error %></div>
        <% } %>
        <form action="UploadTaskServlet" method="post" enctype="multipart/form-data">
            <table>
                <tr><td>File:</td><td><input type="file" name="file" accept=".txt" required></td></tr>
                <tr><td>Algorithm:</td><td>
                    <select name="algorithm">
                        <option value="RoundRobin">Round-Robin</option>
                        <option value="Throttled">Throttled</option>
                        <option value="Dynamic">Dynamic Routing</option>
                    </select>
                </td></tr>
                <tr><td colspan="2"><input type="submit" class="btn" value="Upload"></td></tr>
            </table>
        </form>
    </div>
</div>
<footer>&copy; 2025 Secure Load Balancing Project</footer>
</body>
</html>