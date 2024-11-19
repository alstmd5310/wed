

<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<html>
<head>
    <title>Tomcat, MySQL 연동 테스트</title>
</head>
<body>
    <h2>테이블 내용</h2>
    <table width="100%" border="1">
        <tr>
            <td>TableName</td>
        </tr>
        <%
            // MySQL JDBC Driver 로드
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;
            try {
                // JDBC URL, 사용자명, 비밀번호 설정
                String jdbcDriver = "jdbc:mysql://localhost:3306/TestDB?serverTimezone=UTC";
                String dbUser = "tester"; // MySQL 사용자명
                String dbPass = "1234"; // MySQL 비밀번호
                String query = "SELECT name FROM testTable"; // 실행할 쿼리
                
                // DB 연결 생성
                conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
                stmt = conn.createStatement();
                
                // 쿼리 실행
                rs = stmt.executeQuery(query);
                
                // 결과 출력
                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getString("name") %></td>
        </tr>
        <%
                }
            } catch (SQLException ex) {
                out.println("<p>Error: " + ex.getMessage() + "</p>");
                ex.printStackTrace();
            } finally {
                // 리소스 닫기
                if (rs != null) try { rs.close(); } catch (SQLException ex) {}
                if (stmt != null) try { stmt.close(); } catch (SQLException ex) {}
                if (conn != null) try { conn.close(); } catch (SQLException ex) {}
            }
        %>
    </table>
</body>
</html>
