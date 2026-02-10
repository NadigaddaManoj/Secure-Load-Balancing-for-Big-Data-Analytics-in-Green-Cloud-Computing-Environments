<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.logging.Logger, java.util.logging.Level" %>
<%
    Logger logger = Logger.getLogger("logout.jsp");
    try {
        session.invalidate(); // Invalidate the session
        logger.info("User logged out successfully");
        response.sendRedirect("login.jsp");
    } catch (Exception e) {
        logger.log(Level.SEVERE, "Error during logout", e);
        response.sendRedirect("login.jsp?error=Logout failed");
    }
%>