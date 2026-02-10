package com.db;

import java.sql.*;

public class DBConnection {

    // OLD CODE (local system)
    // private static final String URL = "jdbc:mysql://localhost:3306/secureloadbalancing?useSSL=false";
    // private static final String USER = "root";
    // private static final String PASS = "root";

    // NEW CODE (AWS server database)
    private static final String URL = "jdbc:mysql://localhost:3306/secure?useSSL=false";
    private static final String USER = "appuser";
    private static final String PASS = "password123";

    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        // OLD DRIVER
        // Class.forName("com.mysql.jdbc.Driver");

        // NEW DRIVER
        Class.forName("com.mysql.jdbc.Driver");

        return DriverManager.getConnection(URL, USER, PASS);
    }
}
