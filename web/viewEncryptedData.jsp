<%@ page import="java.sql.*, com.db.DBConnection, com.corelogic.LoadBalancer" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.logging.Logger, java.util.logging.Level" %>
<!DOCTYPE html>
<html>
<head>
    <title>Encrypted Data</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f7f7f7; }
        .navbar { background-color: #BC77D0; color: white; padding: 15px 20px; display: flex; justify-content: space-between; align-items: center; }
        .navbar .logo h1 { margin: 0; font-size: 24px; }
        .navbar .nav-links a { color: white; text-decoration: none; margin: 0 15px; font-weight: bold; }
        .navbar .nav-links a:hover { text-decoration: underline; }
        .section { padding: 50px 20px; max-width: 1200px; margin: 0 auto; }
        .section h2 { color: #BC77D0; }
        pre { background-color: #f0e6f7; padding: 10px; border-radius: 5px; white-space: pre-wrap; word-wrap: break-word; }
        .btn { background-color: #BC77D0; color: white; padding: 5px 10px; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; text-decoration: none; display: inline-block; }
        .btn:hover { opacity: 0.8; }
        .debug-info { color: #d32f2f; margin-top: 10px; }
        @media (max-width: 768px) { .navbar { flex-direction: column; text-align: center; } .navbar .nav-links a { margin: 10px 0; } .section { padding: 20px; } }
    </style>
</head>
<body>
<jsp:include page="userMenu.jsp" />
<div class="section">
    <h2>Encrypted Data</h2>
    <%
        int taskId = Integer.parseInt(request.getParameter("task_id"));
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Logger logger = Logger.getLogger("viewEncryptedData.jsp");
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("SELECT file_data, file_name, status FROM tasks WHERE task_id = ?");
            ps.setInt(1, taskId);
            rs = ps.executeQuery();
            if (rs.next()) {
                String encryptedData = rs.getString("file_data");
                String fileName = rs.getString("file_name");
                    String status = rs.getString("status");
                    LoadBalancer lb = new LoadBalancer(request); // Instantiate LoadBalancer
                    String debugInfo = "";
                    if (lb.getVms().isEmpty()) {
                    debugInfo += "Warning: No VMs available for decryption. ";
                }
                String decryptedData = null;
                try {
                    if (encryptedData != null && !encryptedData.isEmpty()) {
                        decryptedData = lb.decrypt(encryptedData); // Use instance method
                    } else {
                        debugInfo += "Encrypted data is null or empty. ";
                    }
                } catch (Exception e) {
                    logger.log(Level.WARNING, "Decryption failed for task_id " + taskId + ": " + e.getMessage(), e);
                    debugInfo += "Decryption failed: " + e.getMessage() + ". ";
                }
    %>
    <p><strong>File:</strong> <%= fileName %></p>
    <p><strong>Status:</strong> <%= status %></p>
    <h3>Encrypted Content:</h3>
    <pre><%= encryptedData != null ? encryptedData : "N/A" %></pre>
<!--    <h3>Decrypted Content (for Verification):</h3>
    <pre><%= decryptedData != null ? decryptedData : "Decryption failed" %></pre>
    <% if (!debugInfo.isEmpty()) { %>
        <div class="debug-info"><%= debugInfo %></div>-->
    <% } %>
    <div>
        <a href="myTasks.jsp" class="btn">Back to My Tasks</a>
        <%
            String downloadContent = decryptedData != null ? decryptedData : (encryptedData != null ? encryptedData : "");
            String downloadFileName = fileName != null ? fileName.replaceAll("[^a-zA-Z0-9.-]", "_") + ".txt" : "file_" + taskId + ".txt";
            if (!downloadContent.isEmpty()) {
        %>
            <a href="javascript:void(0)" class="btn" onclick="downloadFile('<%= downloadFileName %>', '<%= downloadContent %>')">Download</a>
        <% } %>
    </div>
    <script>
        function downloadFile(filename, content) {
            var blob = new Blob([content], { type: 'text/plain' });
            var url = window.URL.createObjectURL(blob);
            var a = document.createElement('a');
            a.href = url;
            a.download = filename;
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            window.URL.revokeObjectURL(url);
        }
    </script>
    <% } else { %>
    <p>No data found for task ID <%= taskId %>.</p>
    <a href="myTasks.jsp" class="btn">Back to My Tasks</a>
    <% }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "General error for task_id " + taskId, e);
            out.println("<p>Error: " + e.getMessage() + "</p>");
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { }
            if (ps != null) try { ps.close(); } catch (SQLException e) { }
            if (con != null) try { con.close(); } catch (SQLException e) { }
        }
    %>
</div>
<footer>&copy; 2025 Secure Load Balancing Project</footer>
</body>
</html>
