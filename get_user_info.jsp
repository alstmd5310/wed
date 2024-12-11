<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.JSONObject" %>
<%
    response.setContentType("application/json; charset=UTF-8");
    JSONObject responseJson = new JSONObject();
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        String userId = request.getParameter("id"); // 사용자 ID 받기

        // 데이터베이스 연결
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/members?useUnicode=true&characterEncoding=utf8",
            "webuser",
            "webpassword"
        );

        String sql = "SELECT member_email, member_name, member_address FROM members WHERE member_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(userId)); // 사용자 ID 바인딩
        rs = pstmt.executeQuery();

        if (rs.next()) {
            // 사용자 정보 반환
            responseJson.put("success", true);
            responseJson.put("email", rs.getString("member_email"));
            responseJson.put("name", rs.getString("member_name"));
            responseJson.put("address", rs.getString("member_address"));
        } else {
            responseJson.put("success", false);
            responseJson.put("message", "사용자를 찾을 수 없습니다.");
        }
    } catch (Exception e) {
        responseJson.put("success", false);
        responseJson.put("message", "서버 오류: " + e.getMessage());
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }

    out.print(responseJson);
%>
