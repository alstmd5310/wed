<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, org.json.JSONArray, org.json.JSONObject" %>
<%
    response.setContentType("application/json; charset=UTF-8");
    JSONArray resultArray = new JSONArray();

    try (Connection conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/members?useUnicode=true&characterEncoding=utf8",
            "webuser", "webpassword");
         PreparedStatement pstmt = conn.prepareStatement(
            "SELECT q.qna_id, q.title, q.content, q.created_at, q.answered_at, q.answer_content, " +
            "m1.member_name AS asker_name, m2.member_name AS answerer_name " +
            "FROM qna q " +
            "LEFT JOIN members m1 ON q.member_id = m1.member_id " +
            "LEFT JOIN members m2 ON q.answer_member_id = m2.member_id")) {

        ResultSet rs = pstmt.executeQuery();
        while (rs.next()) {
            JSONObject qna = new JSONObject();
            qna.put("qna_id", rs.getInt("qna_id"));
            qna.put("title", rs.getString("title"));
            qna.put("content", rs.getString("content"));
            qna.put("created_at", rs.getString("created_at"));
            qna.put("asker_name", rs.getString("asker_name"));
            qna.put("answered_at", rs.getString("answered_at"));
            qna.put("answer_content", rs.getString("answer_content")); // 답변 내용 추가
            qna.put("answerer_name", rs.getString("answerer_name"));

            resultArray.put(qna);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    out.print(resultArray);
%>
