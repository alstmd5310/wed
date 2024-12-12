<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, org.json.*" %>
<%
    String query = request.getParameter("query");
    JSONArray products = new JSONArray();

    if (query != null && !query.trim().isEmpty()) {
        try {
            // 데이터베이스 연결 정보
            String url = "jdbc:mysql://localhost:3306/members?useSSL=false&serverTimezone=UTC";
            String username = "webuser";
            String password = "webpassword";
            Connection conn = DriverManager.getConnection(url, username, password);

            // SQL 쿼리 실행
            String sql = "SELECT id, name, category, price, image_url FROM products WHERE name LIKE ? OR category LIKE ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, "%" + query + "%");
            stmt.setString(2, "%" + query + "%");

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                JSONObject product = new JSONObject();
                product.put("id", rs.getInt("id"));
                product.put("name", rs.getString("name"));
                product.put("category", rs.getString("category"));
                product.put("price", rs.getDouble("price"));
                // 이미지 경로에 'uploads/' 추가
                product.put("image_url", "uploads/" + rs.getString("image_url"));
                products.put(product);
            }

            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    out.print(products.toString());
%>
