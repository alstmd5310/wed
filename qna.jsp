<%@ page contentType="application/json; charset=UTF-8" %>
<%@ page import="java.io.*, javax.servlet.*, java.sql.*, org.json.*" %>
<%
    response.setContentType("application/json; charset=UTF-8");
    PrintWriter out = response.getWriter();
    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        // JSON 데이터 읽기
        BufferedReader reader = request.getReader();
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }

        JSONObject json = new JSONObject(sb.toString());
        String title = json.getString("title");
        String content = json.getString("content");
        int memberId = json.getInt("member_id"); // 작성자 ID

        // DB 연결
        String dbUrl = "jdbc:mysql://localhost:3306/members";
        String dbUser = "webuser";
        String dbPassword = "webpassword";

        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

        // QnA 데이터 저장
        String sql = "INSERT INTO qna (title, content, created_at, member_id) VALUES (?, ?, NOW(), ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, title);
        pstmt.setString(2, content);
        pstmt.setInt(3, memberId);

        int result = pstmt.executeUpdate();

        if (result > 0) {
            out.print("{\"success\": true}");
        } else {
            out.print("{\"success\": false, \"message\": \"DB 삽입 실패\"}");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.print("{\"success\": false, \"message\": \"서버 오류 발생\"}");
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%>
