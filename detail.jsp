<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상품 상세 페이지</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; display: flex; justify-content: center; align-items: center; min-height: 100vh; background-color: #f9f9f9; }
        .container { display: flex; width: 80%; max-width: 1200px; background-color: white; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); border-radius: 10px; overflow: hidden; }
        .left { flex: 2; padding: 20px; display: flex; flex-direction: column; justify-content: center; align-items: center; background-color: #f4f4f4; }
        .left img { max-width: 70%; height: auto; border-radius: 8px; }
        .right { flex: 1; padding: 20px; display: flex; flex-direction: column; justify-content: space-between; }
        .product-info h2 { margin: 0; color: #333; }
        .price { color: #e74c3c; font-weight: bold; font-size: 1.5rem; }
        .buttons button { padding: 10px; font-size: 16px; border: 2px solid #333; background-color: white; cursor: pointer; border-radius: 5px; transition: background-color 0.3s, color 0.3s; margin-right: 10px; }
        .buttons button:hover { background-color: #333; color: white; }
        .navigation-buttons { margin-top: 20px; display: flex; justify-content: space-between; }
    </style>
</head>
<body>
    <%
        // 상품 정보를 담을 변수
        String name = "", imageUrl = "", description = "";
        int price = 0;
        String productId = request.getParameter("id");  // productId를 먼저 가져옵니다.
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // 상품 ID가 유효하지 않은 경우 예외 처리
            if (productId == null || productId.isEmpty()) {
                out.println("<p>상품 ID가 전달되지 않았습니다.</p>");
                return;  // 상품 ID가 없으면 페이지를 진행하지 않음
            }

            // 2. DB 연결
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/database_product", "shop_user", "spp2391");

            // 3. SQL 쿼리 작성 (상품 상세 정보를 가져오는 쿼리)
            String sql = "SELECT name, price, description, image_url FROM products WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(productId)); // productId를 쿼리 파라미터로 설정
            rs = pstmt.executeQuery();

            // 4. 결과 처리
            if (rs.next()) {
                name = rs.getString("name");
                price = rs.getInt("price");
                description = rs.getString("description");
                imageUrl = rs.getString("image_url");
            } else {
                out.println("<p>상품 정보를 찾을 수 없습니다. 상품 ID: " + productId + "</p>");
                return;
            }
        } catch (Exception e) {
            out.println("<p>오류가 발생했습니다: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception e) {}
            if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
    %>

    <div class="container">
        <div class="left">
            <!-- 이미지 경로 수정: uploads/ 경로를 추가 -->
            <img src="uploads/<%= imageUrl %>" alt="<%= name %>">
        </div>
        <div class="right">
            <div class="product-info">
                <h2><%= name %></h2>
                <p class="price">₩<%= String.format("%,d", price) %></p>
                <p><%= description %></p>
            </div>
            <div class="buttons">
                <!-- 결제 페이지로 이동하는 폼 -->
                <form action="payment.jsp" method="post" style="margin-bottom: 10px;">
                    <input type="hidden" name="product_id" value="<%= productId %>">
                    <input type="hidden" name="product_name" value="<%= name %>">
                    <input type="hidden" name="product_price" value="<%= price %>">
                    <input type="hidden" name="product_image_url" value="<%= imageUrl %>">
                    <button type="submit">결제하기</button>
                </form>
            </div>
            <div class="navigation-buttons">
                <button onclick="history.back()">뒤로가기</button>
                <button onclick="location.href='index.html'">메인 페이지로</button>
            </div>
        </div>
    </div>
</body>
</html>