<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
%>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.JSONObject" %>
<%
    response.setContentType("application/json; charset=UTF-8");
    JSONObject responseJson = new JSONObject();
    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        // JSON 요청 데이터 읽기
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = request.getReader().readLine()) != null) {
            sb.append(line);
        }
        JSONObject requestJson = new JSONObject(sb.toString());

        // 요청 데이터 추출
        String email = requestJson.getString("email");
        String password = requestJson.getString("password");
        String name = requestJson.getString("name");
        String address = requestJson.getString("address");

        // 데이터베이스 연결
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/members", "webuser", "webpassword");

        // 데이터 삽입
        String sql = "INSERT INTO members (member_email, member_password, member_name, member_address) VALUES (?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, email);
        pstmt.setString(2, password); // 비밀번호 해싱 가능 (추가 설명 아래)
        pstmt.setString(3, name);
        pstmt.setString(4, address);
        int rows = pstmt.executeUpdate();

        if (rows > 0) {
            responseJson.put("success", true);
            responseJson.put("message", "회원가입 성공!");
        } else {
            responseJson.put("success", false);
            responseJson.put("message", "데이터 저장 실패");
        }
    } catch (Exception e) {
        responseJson.put("success", false);
        responseJson.put("message", "서버 오류 발생: " + e.getMessage());
        e.printStackTrace(); // 디버깅용
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }

    out.print(responseJson);
%>
