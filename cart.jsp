//장바구니 jsp
//wk
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, org.json.JSONObject, org.json.JSONArray" %>
<%
    response.setContentType("application/json; charset=UTF-8");
    JSONObject responseJson = new JSONObject();
    JSONArray items = new JSONArray();

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        String method = request.getMethod();

        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/cart?useUnicode=true&characterEncoding=utf8",
            "shop_user", "spp2391"
        );

        if (method.equals("GET")) {
            String sql = "SELECT * FROM cart";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                JSONObject item = new JSONObject();
                item.put("id", rs.getInt("cart_id"));
                item.put("name", rs.getString("product_name"));
                item.put("price", rs.getDouble("price"));
                item.put("quantity", rs.getInt("quantity"));
                items.put(item);
            }
            responseJson.put("items", items);
        } else if (method.equals("DELETE")) {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) sb.append(line);
            JSONObject requestJson = new JSONObject(sb.toString());

            int cartId = requestJson.getInt("cartId");
            String sql = "DELETE FROM cart WHERE cart_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, cartId);
            pstmt.executeUpdate();

            responseJson.put("success", true);
        }
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