<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, org.json.JSONObject" %>
<%
    JSONObject responseJson = new JSONObject();
    try {
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = request.getReader().readLine()) != null) {
            sb.append(line);
        }
        JSONObject requestJson = new JSONObject(sb.toString());

        String title = requestJson.getString("title");
        String content = requestJson.getString("content");
        int userId = requestJson.getInt("userId");

        Connection conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/members?useUnicode=true&characterEncoding=utf8",
            "webuser", "webpassword"
        );

        String sql = "INSERT INTO qna (title, content, asker_member_id, created_at) VALUES (?, ?, ?, NOW())";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, title);
            stmt.setString(2, content);
            stmt.setInt(3, userId);

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                responseJson.put("success", true);
            } else {
                responseJson.put("success", false).put("message", "질문 등록 실패");
            }
        }
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        responseJson.put("success", false).put("message", "서버 오류 발생: " + e.getMessage());
    }
    out.print(responseJson.toString());
%>
