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
    ResultSet rs = null;

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

        // 데이터베이스 연결
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/members?useUnicode=true&characterEncoding=utf8",
            "webuser",
            "webpassword"
        );

        // 이메일과 비밀번호로 사용자 조회
        String sql = "SELECT member_id, member_name FROM members WHERE member_email = ? AND member_password = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, email);
        pstmt.setString(2, password);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            // 로그인 성공
            int userId = rs.getInt("member_id");
            String name = rs.getString("member_name");
            responseJson.put("success", true);
            responseJson.put("message", "로그인 성공!");
            responseJson.put("userId", userId);
            responseJson.put("name", name);
        } else {
            // 로그인 실패
            responseJson.put("success", false);
            responseJson.put("message", "이메일 또는 비밀번호가 올바르지 않습니다.");
        }
    } catch (Exception e) {
        responseJson.put("success", false);
        responseJson.put("message", "서버 오류 발생: " + e.getMessage());
        e.printStackTrace(); // 디버깅용 로그 출력
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }

    out.print(responseJson);
%>
