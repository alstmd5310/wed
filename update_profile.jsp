<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.io.*, java.sql.*, org.apache.commons.fileupload.*, org.apache.commons.fileupload.disk.*, org.apache.commons.fileupload.servlet.*" %>

<%
    // 초기 변수 설정
    String id = null, name = null, address = null, newPassword = null;
    boolean isMultipart = ServletFileUpload.isMultipartContent(request);

    try {
        if (isMultipart) {
            // Multipart 요청 처리
            DiskFileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);
            List<FileItem> items = upload.parseRequest(request);

            for (FileItem item : items) {
                if (item.isFormField()) {
                    String fieldName = item.getFieldName();
                    String fieldValue = item.getString("UTF-8"); // UTF-8로 디코딩

                    System.out.println("Received field: " + fieldName + " = " + fieldValue);

                    if ("id".equals(fieldName)) id = fieldValue;
                    if ("name".equals(fieldName)) name = fieldValue;
                    if ("address".equals(fieldName)) address = fieldValue;
                    if ("newPassword".equals(fieldName)) newPassword = fieldValue;
                }
            }
        } else {
            // x-www-form-urlencoded 요청 처리
            id = request.getParameter("id");
            name = request.getParameter("name");
            address = request.getParameter("address");
            newPassword = request.getParameter("newPassword");

            System.out.println("id: " + id + ", name: " + name + ", address: " + address + ", newPassword: " + newPassword);
        }

        // 데이터베이스 연결
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/yourDatabase", "username", "password");
        System.out.println("Database connected.");

        // SQL 쿼리 실행
        String sql = "UPDATE users SET name = ?, address = ?, password = ? WHERE id = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);

        pstmt.setString(1, name);
        pstmt.setString(2, address);
        pstmt.setString(3, newPassword);
        pstmt.setString(4, id);

        int rows = pstmt.executeUpdate();
        System.out.println("Rows updated: " + rows);

        if (rows > 0) {
            out.print("{\"success\":true, \"message\":\"Update successful\"}");
        } else {
            out.print("{\"success\":false, \"message\":\"No rows updated\"}");
        }

        pstmt.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        response.setContentType("application/json");
        out.print("{\"success\":false, \"message\":\"" + e.getMessage() + "\"}");
    }
%>
