<%@ page contentType="application/json; charset=UTF-8" %>
<%@ page import="java.io.*, javax.servlet.*, java.sql.*, org.json.*" %>
<%
    response.setContentType("application/json; charset=UTF-8");
    PrintWriter out = response.getWriter();
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // DB 연결
        String dbUrl = "jdbc:mysql://localhost:3306/your_database_name";
        String dbUser = "webuser";
        String dbPassword = "webpassword";

        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

        // QnA 조회
        String sql = "SELECT q.qna_id, q.title, q.content, q.created_at, q.answered_at, "
                   + "m.member_name AS asker_name, "
                   + "a.member_name AS answerer_name "
                   + "FROM qna q "
                   + "JOIN members m ON q.member_id = m.member_id "
                   + "LEFT JOIN members a ON q.answer_member_id = a.member_id "
                   + "ORDER BY q.created_at DESC";
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();

        JSONArray qnas = new JSONArray();

        while (rs.next()) {
            JSONObject qna = new JSONObject();
            qna.put("qna_id", rs.getInt("qna_id"));
            qna.put("title", rs.getString("title"));
            qna.put("content", rs.getString("content"));
            qna.put("created_at", rs.getTimestamp("created_at").toString());
            qna.put("asker_name", rs.getString("asker_name"));
            qna.put("answered_at", rs.getTimestamp("answered_at") != null ? rs.getTimestamp("answered_at").toString() : null);
            qna.put("answerer_name", rs.getString("answerer_name") != null ? rs.getString("answerer_name") : "미답변");
            qnas.put(qna);
        }

        JSONObject result = new JSONObject();
        result.put("success", true);
        result.put("qnas", qnas);
        out.print(result.toString());
    } catch (Exception e) {
        e.printStackTrace();
        out.print("{\"success\": false, \"message\": \"서버 오류 발생\"}");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%>
