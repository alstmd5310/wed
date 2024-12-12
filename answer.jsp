<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, org.json.JSONObject" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    response.setContentType("application/json; charset=UTF-8");

    JSONObject responseJson = new JSONObject();
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // 요청 데이터 가져오기
        String qnaId = request.getParameter("qna_id");
        String answerContent = request.getParameter("answer_content");
        int answerMemberId = Integer.parseInt(request.getParameter("answer_member_id"));

        // 입력값 검증
        if (qnaId == null || answerContent == null || qnaId.trim().isEmpty() || answerContent.trim().isEmpty()) {
            responseJson.put("success", false);
            responseJson.put("error", "필수 파라미터가 누락되었습니다.");
            out.print(responseJson);
            return;
        }

        // 데이터베이스 연결
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/members?useUnicode=true&characterEncoding=utf8",
            "webuser",
            "webpassword"
        );

        // QnA 답변 업데이트
        String sql = "UPDATE qna SET answer_content = ?, answered_at = NOW(), answer_member_id = ? WHERE qna_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, answerContent);
        pstmt.setInt(2, answerMemberId);
        pstmt.setString(3, qnaId);
        int rows = pstmt.executeUpdate();

        if (rows > 0) {
            // 답변자 이름 가져오기
            String memberSql = "SELECT member_name FROM members WHERE member_id = ?";
            pstmt = conn.prepareStatement(memberSql);
            pstmt.setInt(1, answerMemberId);
            rs = pstmt.executeQuery();

            String answererName = "";
            if (rs.next()) {
                answererName = rs.getString("member_name");
            }

            responseJson.put("success", true);
            responseJson.put("answer_content", answerContent);
            responseJson.put("answerer_name", answererName);
        } else {
            responseJson.put("success", false);
            responseJson.put("error", "QnA 답변 등록에 실패했습니다.");
        }
    } catch (Exception e) {
        responseJson.put("success", false);
        responseJson.put("error", "서버 오류: " + e.getMessage());
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }

    out.print(responseJson);
%>
