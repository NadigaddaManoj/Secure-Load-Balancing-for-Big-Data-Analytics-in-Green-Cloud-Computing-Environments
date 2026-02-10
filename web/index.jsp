<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Secure Load Balancing in Green Cloud Computing</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f7f7f7;
        }
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
        /* Body sections */
        .section {
            padding: 50px 20px;
            max-width: 1200px;
            margin: 0 auto;
        }
        .section h2 {
            color: #BC77D0;
        }
        .section p {
            max-width: 900px;
            line-height: 1.6;
            margin-bottom: 20px;
        }
        /* Sub-sections */
        .sub-section {
            background-color: #f0e6f7;
            padding: 20px;
            margin: 20px 0;
            border-radius: 10px;
        }
        /* Footer */
        footer {
            background-color: #BC77D0;
            color: white;
            text-align: center;
            padding: 15px 20px;
            position: relative;
            bottom: 0;
            width: 100%;
        }
        /* Buttons */
        .btn {
            background-color: #BC77D0;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
            text-decoration: none;
            display: inline-block;
        }
        .btn:hover {
            opacity: 0.8;
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
            .section {
                padding: 20px;
            }
        }
    </style>
</head>
<body>
<!-- Navbar -->
<jsp:include page="menu.jsp"></jsp:include>

<!-- Body -->
<div class="section" id="about">
    <h2>About the Project</h2>
    <div class="sub-section">
        <p>This project implements <b>Secure Load Balancing for Big Data Analytics in Green Cloud Computing Environments</b>. 
        It ensures efficient workload distribution among multiple servers while optimizing energy consumption and maintaining data security.</p>
        <p>The main objectives are:</p>
        <ul>
            <li>Efficient task distribution across servers</li>
            <li>Energy-efficient green computing</li>
            <li>Secure handling of sensitive data</li>
        </ul>
        <a href="register.jsp" class="btn">Get Started</a>
    </div>
</div>

<div class="section" id="algorithms">
    <h2>Load Balancing Algorithms</h2>
    <div class="sub-section">
        <h3>1. Round-Robin</h3>
        <p>Assigns tasks to servers sequentially, ensuring even distribution without considering server load or energy consumption.</p>
    </div>
    <div class="sub-section">
        <h3>2. Throttled / Weighted</h3>
        <p>Selects the server with the most free capacity or least energy consumption. Prioritizes energy-efficient servers for task allocation.</p>
    </div>
    <div class="sub-section">
        <h3>3. Dynamic Routing</h3>
        <p>Uses real-time server metrics (CPU, memory, network, energy) to dynamically assign tasks for optimal load distribution and minimal energy usage.</p>
    </div>
</div>

<div class="section" id="servers">
    <h2>Server Management</h2>
    <div class="sub-section">
        <p>Admin can add new servers with defined capacity. Each server maintains:</p>
        <ul>
            <li>Capacity (max tasks it can handle)</li>
            <li>Current load (tasks running)</li>
            <li>Energy consumption</li>
            <li>Status (Active / Idle)</li>
        </ul>
        <p>All servers are monitored in real-time to ensure efficient task allocation and energy usage.</p>
    </div>
</div>

<div class="section" id="contact">
    <h2>Contact</h2>
    <div class="sub-section">
        <p>Project Authors:</p>
        <ul>
            <li>Rajul Ravi - Tula’s Institute, Dehradun, India</li>
            <li>Dilip Prakash Valanarasu - Alagappa University, Tamil Nadu, India</li>
            <li>Rajesh Sura - Anna University, Chennai, India</li>
            <li>Padma Naresh Vardhineedi - University of Missouri Kansas City, USA</li>
        </ul>
        <p>Email: <a href="mailto:rajulravi223@gmail.com">rajulravi223@gmail.com</a></p>
    </div>
</div>

<!-- Footer -->
<footer>
    &copy; 2025 Secure Load Balancing Project | Green Cloud Computing
</footer>
</body>
</html>