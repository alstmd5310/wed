<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%
    // 응답 인코딩 설정
    response.setCharacterEncoding("UTF-8"); // 응답 인코딩을 UTF-8로 설정
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>장바구니</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f7f7f7;
        }
        .header {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            background-color: white;
            border-bottom: 1px solid black;
            z-index: 1000;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .content {
            margin: 100px auto 0;
            width: 80%;
            max-width: 1200px;
            text-align: center;
        }
        .cart-item {
            display: flex;
            align-items: center;
            border-bottom: 1px solid #ddd;
            padding: 20px;
            background-color: white;
        }
        .cart-item img {
            width: 80px;
            height: 80px;
            object-fit: cover;
            margin-right: 20px;
        }
        .cart-item .info {
            flex-grow: 1;
            text-align: left;
        }
        .cart-item .info h3 {
            margin: 5px 0;
            font-size: 16px;
        }
        .cart-item .info p {
            color: #555;
            font-size: 14px;
        }
        .cart-item .actions {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
        }
        .cart-item button {
            margin-top: 10px;
            padding: 10px 20px;
            background-color: #000;
            color: white;
            border: none;
            cursor: pointer;
            font-size: 14px;
            border-radius: 5px;
        }
        .cart-item button:hover {
            background-color: #444;
        }
        .go-back-button {
            margin-top: 30px;
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
            font-size: 16px;
            border-radius: 5px;
        }
        .go-back-button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo" onclick="location.href='index.html'">WED</div>
        <div class="menu" id="menu">
            <a href="clothes.jsp">상의</a>
            <a href="pants.jsp">하의</a>
            <a href="shoes.jsp">신발</a>
            <a href="accecarry.jsp">악세서리</a>
        </div>
    </div>

    <div class="content">
        <h1>장바구니</h1>

        <%
            // POST 요청 시 인코딩 설정 (폼 데이터 처리 전)
            request.setCharacterEncoding("UTF-8");

            // 세션에서 장바구니 정보를 가져옴
            List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");
            if (cart == null || cart.isEmpty()) {
        %>
            <p>장바구니가 비어 있습니다.</p>
        <%
            } else {
        %>
            <%-- 장바구니 내용 출력 --%>
            <div>
                <%
                    int total = 0;
                    for (Map<String, Object> item : cart) {
                        String name = (String) item.get("name");
                        int price = (int) item.get("price");
                        String imageUrl = (String) item.get("image_url");  // 이미지 URL 추가
                        total += price;
                %>
                    <div class="cart-item">
                        <img src="uploads/<%= imageUrl %>" alt="<%= name %>">
                        <div class="info">
                            <h3><%= name %></h3>
                            <p>₩<%= String.format("%,d", price) %></p>
                        </div>
                        <div class="actions">
                            <form action="payment.jsp" method="post">
                                <input type="hidden" name="product_id" value="<%= item.get("id") %>">
                                <input type="hidden" name="product_name" value="<%= name %>">
                                <input type="hidden" name="product_price" value="<%= price %>">
                                <button type="submit">구매하기</button>
                            </form>
                        </div>
                    </div>
                <%
                    }
                %>
            </div>
            <p>총 합계: ₩<%= String.format("%,d", total) %></p>
        <%
            }
        %>
        <!-- 돌아가기 버튼 -->
        <form action="index.html">
            <button class="go-back-button" type="submit">홈으로 돌아가기</button>
        </form>
    </div>
</body>
</html>

