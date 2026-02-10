<%@ page import="java.sql.*, com.db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Normal Cloud vs Green Cloud - Advanced View</title>

    <style>
        body {
            margin: 0;
            padding: 0;
            background: #eef2f3;
            font-family: Arial, sans-serif;
        }

        h2 {
            text-align: center;
            margin: 15px 0;
        }

        .toggle-buttons {
            text-align: center;
            margin-bottom: 15px;
        }

        .toggle-buttons button {
            padding: 10px 25px;
            margin: 0 10px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
        }

        .btn-normal { background: #c62828; color: white; }
        .btn-green { background: #2e7d32; color: white; }

        .main-container {
            display: flex;
            justify-content: space-around;
            align-items: center;
            padding: 20px;
            position: relative;
        }

        /* USER */
        .user-box {
            width: 120px;
            height: 80px;
            background: #ffcc80;
            border-radius: 10px;
            text-align: center;
            padding-top: 25px;
            font-weight: bold;
        }

        /* LOAD BALANCER */
        .load-balancer {
            width: 150px;
            height: 80px;
            background: #90caf9;
            border-radius: 10px;
            text-align: center;
            padding-top: 20px;
            font-weight: bold;
            box-shadow: 0 0 10px #2196f3;
        }

        /* ARROWS */
        .arrow {
            width: 80px;
            height: 3px;
            background: black;
            position: relative;
        }

        .arrow:after {
            content: '';
            position: absolute;
            right: -8px;
            top: -5px;
            border-top: 6px solid transparent;
            border-bottom: 6px solid transparent;
            border-left: 10px solid black;
        }

        /* SERVER ROOM */
        .server-room {
            width: 420px;
            padding: 15px;
            border-radius: 12px;
            box-shadow: 0 0 10px rgba(0,0,0,0.2);
        }

        .room-normal { background: #ffebee; }
        .room-green { background: #e8f5e9; }

        .servers {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
        }

        .server-box {
            width: 80px;
            height: 80px;
            margin: 8px;
            border-radius: 8px;
            color: white;
            text-align: center;
            padding-top: 25px;
            font-size: 12px;
            animation: blink 1.5s infinite;
        }

        .server-on {
            background: #2e7d32;
            box-shadow: 0 0 10px green;
        }

        .server-off {
            background: #9e9e9e;
            opacity: 0.4;
            animation: none;
        }

        @keyframes blink {
            0% { opacity: 1; }
            50% { opacity: 0.6; }
            100% { opacity: 1; }
        }

        /* COOLING WATER PIPE */
        .pipe {
            width: 100%;
            height: 12px;
            background: #0288d1;
            border-radius: 6px;
            margin: 10px 0;
            overflow: hidden;
            position: relative;
        }

        .water {
            width: 40px;
            height: 12px;
            background: #b3e5fc;
            position: absolute;
            animation: flow 2s linear infinite;
        }

        @keyframes flow {
            0% { left: -40px; }
            100% { left: 100%; }
        }

        /* FAN */
        .fan {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            margin: 10px auto;
        }

        .fan-fast {
            border: 5px solid #0d47a1;
            animation: spinFast 0.5s linear infinite;
        }

        .fan-slow {
            border: 5px solid #1b5e20;
            animation: spinSlow 2s linear infinite;
        }

        @keyframes spinFast { 100% { transform: rotate(360deg); } }
        @keyframes spinSlow { 100% { transform: rotate(360deg); } }

        /* TEMPERATURE METER */
        .temp-box {
            width: 30px;
            height: 120px;
            background: #ddd;
            border-radius: 10px;
            margin: 10px auto;
            position: relative;
            overflow: hidden;
        }

        .temp-fill {
            position: absolute;
            bottom: 0;
            width: 100%;
            transition: height 1s;
        }

        .temp-high { background: #d32f2f; }
        .temp-low { background: #43a047; }

        /* ENERGY BAR */
        .energy-bar-bg {
            width: 100%;
            height: 15px;
            background: #ccc;
            border-radius: 10px;
            overflow: hidden;
            margin-top: 8px;
        }

        .energy-bar-fill {
            height: 100%;
            transition: width 1s;
        }

        .energy-high { background: #d32f2f; }
        .energy-low { background: #43a047; }

        /* POWER PLANT */
        .power-plant {
            width: 200px;
            height: 200px;
            border-radius: 10px;
            color: white;
            text-align: center;
            padding-top: 60px;
            position: relative;
        }

        .plant-normal { background: #424242; }
        .plant-green { background: #2e7d32; }

        .chimney {
            width: 30px;
            height: 80px;
            background: #212121;
            position: absolute;
            top: -80px;
            left: 85px;
        }

        .smoke {
            width: 20px;
            height: 20px;
            background: rgba(200,200,200,0.8);
            border-radius: 50%;
            position: absolute;
            animation: smokeMove 3s infinite;
        }

        @keyframes smokeMove {
            0% { transform: translateY(0); opacity: 1; }
            100% { transform: translateY(-50px); opacity: 0; }
        }

        .info-box {
            margin-top: 10px;
            padding: 10px;
            border-radius: 8px;
            font-size: 13px;
            text-align: center;
            color: white;
        }

        .info-normal { background: #b71c1c; }
        .info-green { background: #2e7d32; }

    </style>
</head>

<body>
<jsp:include page="adminMenu.jsp" />

<h2>☁️ Normal Cloud vs 🌱 Green Cloud (Cooling, Temp, Traffic, Energy)</h2>

<div class="toggle-buttons">
    <button class="btn-normal" onclick="showNormal()">Without Green Cloud</button>
    <button class="btn-green" onclick="showGreen()">With Green Cloud</button>
</div>

<%
    String mode = request.getParameter("mode");
    if (mode == null) mode = "green";

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        con = DBConnection.getConnection();
        ps = con.prepareStatement("SELECT server_name, status FROM servers");
        rs = ps.executeQuery();
%>

<div class="main-container">

    <!-- USER -->
    <div class="user-box">👤 User</div>

    <div class="arrow"></div>

    <!-- LOAD BALANCER -->
    <div class="load-balancer">🔁 Load<br>Balancer</div>

    <div class="arrow"></div>

    <!-- SERVER ROOM -->
    <div class="server-room <%= "normal".equals(mode) ? "room-normal" : "room-green" %>">

        <div style="text-align:center;font-weight:bold;">
            <%= "normal".equals(mode) ? "Normal Data Center" : "Green Data Center" %>
        </div>

        <!-- COOLING WATER PIPE -->
        <div class="pipe"><div class="water"></div></div>
        <div class="pipe"><div class="water" style="animation-delay:1s;"></div></div>

        <!-- SERVERS -->
        <div class="servers">
            <%
                while (rs.next()) {
                    String name = rs.getString("server_name");
                    String status = rs.getString("status");

                    boolean isOn;
                    if ("normal".equals(mode)) {
                        isOn = true;
                    } else {
                        isOn = "Active".equalsIgnoreCase(status);
                    }
            %>
                <div class="server-box <%= isOn ? "server-on" : "server-off" %>">
                    <%= name %><br>
                    <small><%= isOn ? "ON" : "OFF" %></small>
                </div>
            <% } %>
        </div>

        <!-- FAN -->
        <div class="fan <%= "normal".equals(mode) ? "fan-fast" : "fan-slow" %>"></div>

        <!-- TEMPERATURE -->
        <div class="temp-box">
            <div class="temp-fill <%= "normal".equals(mode) ? "temp-high" : "temp-low" %>"
                 style="height:<%= "normal".equals(mode) ? "90%" : "40%" %>;"></div>
        </div>

        <!-- ENERGY -->
        <div class="energy-bar-bg">
            <div class="energy-bar-fill <%= "normal".equals(mode) ? "energy-high" : "energy-low" %>"
                 style="width:<%= "normal".equals(mode) ? "90%" : "35%" %>;"></div>
        </div>

        <div class="info-box <%= "normal".equals(mode) ? "info-normal" : "info-green" %>">
            <%= "normal".equals(mode)
                ? "All servers ON → More heat → More cooling → More fossil fuel burning → More pollution ❌"
                : "Only needed servers ON → Less heat → Less cooling → Less fossil fuel burning → Less pollution ✅" %>
        </div>

    </div>

    <!-- POWER PLANT -->
    <div class="power-plant <%= "normal".equals(mode) ? "plant-normal" : "plant-green" %>">
        <div class="chimney"></div>

        <% 
            int smokeCount = "normal".equals(mode) ? 6 : 2;
            for(int i=0;i<smokeCount;i++){
        %>
            <div class="smoke" style="left:<%= 80 + i*10 %>px;"></div>
        <% } %>

        <b>Power Plant</b><br>
        <%= "normal".equals(mode) ? "🔥 High Fossil Fuel" : "🌱 Low Fossil Fuel" %>
    </div>

</div>

<script>
    function showNormal() {
        window.location = "serverRoom.jsp?mode=normal";
    }
    function showGreen() {
        window.location = "serverRoom.jsp?mode=green";
    }
</script>

<%
    } catch(Exception e){
        out.println("Error: " + e.getMessage());
    } finally {
        if(rs!=null) rs.close();
        if(ps!=null) ps.close();
        if(con!=null) con.close();
    }
%>

</body>
</html>
