<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.JSONObject" %>
<%
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    request.setCharacterEncoding("UTF-8"); // UTF-8 설정 추가
    JSONObject jsonResponse = new JSONObject();

    String dbUrl = "jdbc:mysql://localhost:3306/members?useUnicode=true&characterEncoding=utf8";
    String dbUser = "webuser";
    String dbPassword = "webpassword";

    try {
        String id = request.getParameter("id");
        String email = request.getParameter("email");
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String newPassword = request.getParameter("newPassword");

        System.out.println("ID: " + id);
        System.out.println("Email: " + email);
        System.out.println("Name: " + name);
        System.out.println("Address: " + address);
        System.out.println("New Password: " + newPassword);

        if (id == null || id.isEmpty()) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "ID parameter is missing.");
        } else {
            Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
            String sql = "UPDATE members SET member_email = ?, member_name = ?, member_address = ?, member_password = ? WHERE member_id = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            pstmt.setString(2, name);
            pstmt.setString(3, address);
            pstmt.setString(4, newPassword);
            pstmt.setString(5, id);

            int rowsUpdated = pstmt.executeUpdate();
            if (rowsUpdated > 0) {
                jsonResponse.put("success", true);
                jsonResponse.put("message", "Profile updated successfully.");
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "No matching record found for the provided ID.");
            }

            pstmt.close();
            conn.close();
        }
    } catch (Exception e) {
        e.printStackTrace();
        jsonResponse.put("success", false);
        jsonResponse.put("message", "Error updating profile: " + e.getMessage());
    }

    out.print(jsonResponse.toString());
%>
