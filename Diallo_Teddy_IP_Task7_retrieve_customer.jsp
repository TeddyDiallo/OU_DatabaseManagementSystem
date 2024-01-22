<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="handlers.DataHandler"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customers by Category Range</title>
</head>
<body>
    <h2>Retrieve Customers by Category Range</h2>
    <form method="get">
        Start Category: <input type="number" name="startCategory"><br>
        End Category: <input type="number" name="endCategory"><br>
        <input type="submit" value="Retrieve">
    </form>
    <%
        String startCategoryStr = request.getParameter("startCategory");
        String endCategoryStr = request.getParameter("endCategory");

        if(startCategoryStr != null && endCategoryStr != null) {
            int startCategory = Integer.parseInt(startCategoryStr);
            int endCategory = Integer.parseInt(endCategoryStr);
            DataHandler handler = new DataHandler();
            ResultSet rs = handler.retrieveCustomerByRange(startCategory, endCategory);

            out.println("<table border='1'>");
            out.println("<tr><th>Name</th><th>Address</th><th>Category</th></tr>");
            while(rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rs.getString("name_customer") + "</td>");
                out.println("<td>" + rs.getString("address_customer") + "</td>");
                out.println("<td>" + rs.getInt("category") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");

            rs.close();
            handler.closeConnection();
        }
    %>
</body>
</html>
