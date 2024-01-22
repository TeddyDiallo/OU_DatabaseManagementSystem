package handlers;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DataHandler {

	private Connection conn;
    private String url = "jdbc:sqlserver://dial0007.database.windows.net:1433;database=cs-dsa-4513-sql-db;user=dial0007@dial0007;password=Candidatkey99;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30";

    public DataHandler() {
        // Removed the try-catch block so we can let the caller handle any connection issues
        getDBConnection();
    }

    private void getDBConnection() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver"); // Explicitly load the JDBC driver
            if (conn == null || conn.isClosed()) {
                conn = DriverManager.getConnection(url);
            }
        } catch (ClassNotFoundException | SQLException e) {
            // For the ClassNotFoundException
            System.err.println("JDBC driver not found: " + e.getMessage());
            throw new RuntimeException(e);
        }
    }


    public boolean insertCustomer(String nameCustomer, String addressCustomer, int category) {
        try {
            getDBConnection(); // Ensure the connection is open
            final String sqlQuery = "{call insertCustomer(?, ?, ?)}";
            try (CallableStatement statement = conn.prepareCall(sqlQuery)) {
                statement.setString(1, nameCustomer);
                statement.setString(2, addressCustomer);
                statement.setInt(3, category);

                int rowsAffected = statement.executeUpdate();
                return rowsAffected == 1;
            }
        } catch (SQLException e) {
            // Log and handle the exception
            System.err.println("SQL exception in insertCustomer: " + e.getMessage());
            return false;
        }
    }

    public ResultSet retrieveCustomerByRange(int categoryStart, int categoryEnd) {
        try {
            getDBConnection(); // Ensure the connection is open
            final String sqlQuery = "{call retrieveCustomerByRange(?, ?)}";
            CallableStatement statement = conn.prepareCall(sqlQuery);
            statement.setInt(1, categoryStart);
            statement.setInt(2, categoryEnd);

            return statement.executeQuery();
        } catch (SQLException e) {
            // Log and rethrow the exception
            System.err.println("SQL exception in retrieveCustomerByRange: " + e.getMessage());
            throw new RuntimeException(e);
        }
    }

    // Make sure to close the connection when done
    public void closeConnection() {
        try {
            if (conn != null && !conn.isClosed()) {
                conn.close();
            }
        } catch (SQLException e) {
            System.err.println("Error closing database connection: " + e.getMessage());
        }
    }
}
