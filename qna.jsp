<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.JSONObject" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    response.setContentType("application/json; charset=UTF-8");

    JSONObject responseJson = new JSONObject();
    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        // 파라미터 읽기
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String memberIdStr = request.getParameter("memberId");
        int memberId = Integer.parseInt(memberIdStr); // memberId가 null일 경우 예외 발생 가능

        // 파라미터 유효성 검사
        if (title == null || content == null || title.trim().isEmpty() || content.trim().isEmpty()) {
            responseJson.put("success", false);
            responseJson.put("error", "필수 파라미터가 누락되었습니다.");
            out.print(responseJson.toString());
            return;
        }

        // 데이터베이스 연결
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/members?useUnicode=true&characterEncoding=utf8",
            "webuser",
            "webpassword"
        );

        // SQL 삽입
        String sql = "INSERT INTO qna (title, content, member_id, created_at) VALUES (?, ?, ?, NOW())";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, title);
        pstmt.setString(2, content);
        pstmt.setInt(3, memberId);

        int rows = pstmt.executeUpdate();
        if (rows > 0) {
            responseJson.put("success", true);
        } else {
            responseJson.put("success", false);
            responseJson.put("error", "질문 등록에 실패했습니다.");
        }

    } catch (Exception e) {
        e.printStackTrace();
        responseJson.put("success", false);
        responseJson.put("error", "서버 오류: " + e.getMessage());
    } finally {
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }

    // JSON 응답 반환
    out.print(responseJson.toString());
%>
