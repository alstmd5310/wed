<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.JSONObject" %>
<%
    response.setContentType("application/json; charset=UTF-8");
    JSONObject responseJson = new JSONObject();
    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        String userId = request.getParameter("id");
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String newPassword = request.getParameter("newPassword");

        // 디버깅 로그
        System.out.println("userId: " + userId);
        System.out.println("name: " + name);
        System.out.println("address: " + address);
        System.out.println("newPassword: " + newPassword);

        // 데이터베이스 연결
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/members?useUnicode=true&characterEncoding=utf8",
            "webuser",
            "webpassword"
        );

        if (conn == null) {
            System.out.println("Database connection failed!");
            responseJson.put("success", false);
            responseJson.put("message", "Database connection failed!");
        } else {
            System.out.println("Database connection successful.");
        }

        // 사용자 정보 업데이트
        String updateSql = "UPDATE members SET member_name = ?, member_address = ?, member_password = ? WHERE member_id = ?";
        pstmt = conn.prepareStatement(updateSql);
        pstmt.setString(1, name);
        pstmt.setString(2, address);
        pstmt.setString(3, newPassword);
        pstmt.setInt(4, Integer.parseInt(userId));

        System.out.println("Executing SQL: " + updateSql);

        int rows = pstmt.executeUpdate();

        if (rows > 0) {
            responseJson.put("success", true);
            responseJson.put("message", "정보가 성공적으로 수정되었습니다.");
        } else {
            responseJson.put("success", false);
            responseJson.put("message", "정보 수정에 실패했습니다.");
        }
    } catch (Exception e) {
        responseJson.put("success", false);
        responseJson.put("message", "서버 오류 발생: " + e.getMessage());
        e.printStackTrace(); // 디버깅 로그
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }

    out.print(responseJson);
%>
