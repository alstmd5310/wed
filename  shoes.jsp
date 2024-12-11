<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="common.css"> <!-- 공통 CSS 파일 연결 -->
    <title>신발 상품 목록</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f7f7f7; }
        .header { position: fixed; top: 0; left: 0; width: 100%; background-color: white; border-bottom: 1px solid black; z-index: 1000; padding: 20px; display: flex; justify-content: space-between; align-items: center; }
        .header .logo { font-size: 24px; font-weight: bold; cursor: pointer; }
        .content { margin: 100px auto 0; width: 80%; max-width: 1200px; text-align: center; }
        .grid { display: flex; flex-wrap: wrap; gap: 20px; justify-content: center; margin-top: 40px; }
        .item { border: 1px solid black; border-radius: 5px; width: 250px; padding: 20px; background-color: white; text-align: center; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); }
        .item img { max-width: 100%; height: auto; margin-bottom: 10px; cursor: pointer; }
        .item h3 { font-size: 18px; margin: 10px 0; }
        .item p { color: #555; font-size: 14px; margin: 10px 0; }
        .item button { padding: 10px 20px; background-color: black; color: white; border: none; cursor: pointer; border-radius: 5px; font-size: 14px; }
        .item button:hover { background-color: #444; }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo" onclick="location.href='index.jsp'">WED</div>
        <div> 상품 목록</div>
    </div>

    <div class="content">
        <h1>신발 상품 목록</h1>
        <div class="grid">
            <%
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;

                try {
                    // 1. DB 연결
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/database_product", "shop_user", "spp2391");

                    // 2. SQL 쿼리 작성 (상품과 카테고리 정보를 가져오는 쿼리)
                    String sql = "SELECT id, name, price, image_url FROM products WHERE category = '신발'";  // 카테고리가 '신발'인 상품만 조회

                    pstmt = conn.prepareStatement(sql);
                    rs = pstmt.executeQuery();

                    // 3. 결과 출력
                    while (rs.next()) {
                        String name = rs.getString("name");
                        String imageUrl = rs.getString("image_url");  // image_url 값은 "images/top1.jpg" 와 같은 형식
                        int price = rs.getInt("price");
                        int id = rs.getInt("id");
            %>
                        <div class="item">
                            <!-- 상품 이미지 클릭 시 상세 페이지로 이동 -->
                            <a href="detail.jsp?id=<%= id %>">
                                <!-- DB에 저장된 image_url을 사용하여 이미지 표시 -->
                                <img src="uploads/<%= imageUrl %>" alt="<%= name %>">
                            </a>
                            <h3><%= name %></h3>
                            <p>₩<%= String.format("%,d", price) %></p>
                            <!-- 장바구니 버튼 클릭 시 cart.jsp로 이동 -->
                            <form action="cart.jsp" method="post">
                                <input type="hidden" name="product_id" value="<%= id %>">
                                <button type="submit">장바구니</button>
                            </form>
                        </div>
            <%
                    }
                } catch (SQLException e) {
                    out.println("<p>SQL 오류가 발생했습니다: " + e.getMessage() + "</p>");
                    e.printStackTrace();
                } catch (Exception e) {
                    out.println("<p>알 수 없는 오류가 발생했습니다: " + e.getMessage() + "</p>");
                    e.printStackTrace();
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) {}
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
                    if (conn != null) try { conn.close(); } catch (SQLException e) {}
                }
            %>
        </div>
    </div>
</body>
</html>