<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, org.json.JSONObject" %>
<%
    response.setContentType("application/json; charset=UTF-8");
    JSONObject responseJson = new JSONObject();

    if (session.getAttribute("userId") == null) {
        responseJson.put("success", false);
        responseJson.put("message", "로그인 후 이용해주세요.");
        out.print(responseJson);
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = request.getReader().readLine()) != null) {
            sb.append(line);
        }
        JSONObject requestJson = new JSONObject(sb.toString());

        String title = requestJson.getString("title");
        String content = requestJson.getString("content");

        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/inquiries?useUnicode=true&characterEncoding=utf8",
            "webuser", "webpassword"
        );

        String sql = "INSERT INTO inquiries (title, content, created_at) VALUES (?, ?, NOW())";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, title);
        pstmt.setString(2, content);
        pstmt.executeUpdate();

        responseJson.put("success", true);
        responseJson.put("message", "문의가 성공적으로 등록되었습니다.");
    } catch (Exception e) {
        responseJson.put("success", false);
        responseJson.put("message", e.getMessage());
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }

    out.print(responseJson);
%>

<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, org.json.JSONObject, org.json.JSONArray" %>
<%
    response.setContentType("application/json; charset=UTF-8");
    JSONObject responseJson = new JSONObject();
    JSONArray inquiriesArray = new JSONArray();

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/inquiries?useUnicode=true&characterEncoding=utf8",
            "webuser", "webpassword"
        );

        String sql = "SELECT title, content, created_at, answered_at FROM inquiries ORDER BY created_at DESC";
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            JSONObject inquiry = new JSONObject();
            inquiry.put("title", rs.getString("title"));
            inquiry.put("content", rs.getString("content"));
            inquiry.put("created_at", rs.getString("created_at"));
            inquiry.put("answered_at", rs.getString("answered_at"));
            inquiriesArray.put(inquiry);
        }

        responseJson.put("success", true);
        responseJson.put("inquiries", inquiriesArray);
    } catch (Exception e) {
        responseJson.put("success", false);
        responseJson.put("message", e.getMessage());
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }

    out.print(responseJson);
%>