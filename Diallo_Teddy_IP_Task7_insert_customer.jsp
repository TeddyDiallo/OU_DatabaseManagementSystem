<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="handlers.DataHandler"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Insert New Customer</title>
</head>
<body>
    <h2>Add New Customer</h2>
    <form method="post">
        Name: <input type="text" name="name"><br>
        Address: <input type="text" name="address"><br>
        Category: <input type="number" name="category"><br>
        <input type="submit" value="Insert">
    </form>
    <%
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String categoryStr = request.getParameter("category");

        if (name != null && address != null && categoryStr != null) {
            int category = Integer.parseInt(categoryStr);

            try {
                DataHandler handler = new DataHandler();

                if (handler != null) {
                    boolean success = handler.insertCustomer(name, address, category);
                    handler.closeConnection();

                    if (success) {
                        out.println("<p>Customer inserted successfully!</p>");
                    } else {
                        out.println("<p>Insertion failed.</p>");
                    }
                } else {
                    out.println("<p>DataHandler is null. Unable to establish a connection.</p>");
                }
            } catch (Exception e) {
                out.println("<p>Exception occurred: " + e.getMessage() + "</p>");
            }
        }
    %>
</body>
</html>
