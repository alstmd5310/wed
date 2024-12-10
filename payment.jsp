<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>결제 페이지</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f9f9f9; }
        .container { display: flex; flex-direction: column; justify-content: center; align-items: center; min-height: 100vh; padding: 20px; }
        .payment-info { background-color: white; padding: 20px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); width: 400px; text-align: center; }
        .payment-info h2 { margin: 0; color: #333; }
        .price { color: #e74c3c; font-weight: bold; font-size: 1.5rem; margin: 10px 0; }
        .payment-buttons button { padding: 10px 20px; background-color: black; color: white; border: none; cursor: pointer; border-radius: 5px; font-size: 14px; margin-top: 20px; }
        .payment-buttons button:hover { background-color: #444; }
        .payment-info img { max-width: 100%; height: auto; border-radius: 8px; margin-bottom: 20px; }
        .form-input { margin-bottom: 15px; }
        input[type="text"], input[type="number"], input[type="email"], input[type="tel"] { 
            width: 100%; padding: 10px; margin-top: 5px; border-radius: 5px; border: 1px solid #ddd; font-size: 14px;
        }
    </style>
</head>
<body>
    <%
        // 상품 정보 가져오기
        request.setCharacterEncoding("UTF-8"); // POST 방식 인코딩 설정
        String productId = request.getParameter("product_id");
        String productName = request.getParameter("product_name");
        String productImageUrl = request.getParameter("product_image_url");
        int productPrice = Integer.parseInt(request.getParameter("product_price"));

        if (productId == null || productId.isEmpty()) {
            out.println("<p>상품 ID가 유효하지 않습니다.</p>");
            return;
        }
    %>

    <div class="container">
        <div class="payment-info">
            <h2>결제 정보</h2>
            <img src="<%= productImageUrl %>" alt="<%= productName %>">
            <p><strong>상품명:</strong> <%= productName %></p>
            <p class="price">₩<%= String.format("%,d", productPrice) %></p>

            <!-- 결제 정보 입력 폼 -->
            <form action="payment_complete.jsp" method="post">
                <input type="hidden" name="product_id" value="<%= productId %>">
                <input type="hidden" name="product_name" value="<%= productName %>">
                <input type="hidden" name="product_price" value="<%= productPrice %>">
                <input type="hidden" name="product_image_url" value="<%= productImageUrl %>">

                <!-- 성명 입력 -->
                <div class="form-input">
                    <label for="name">성명</label>
                    <input type="text" id="name" name="name" required>
                </div>

                <!-- 카드번호 입력 -->
                <div class="form-input">
                    <label for="card_number">카드번호</label>
                    <input type="number" id="card_number" name="card_number" required>
                </div>

                <!-- 배송지 입력 -->
                <div class="form-input">
                    <label for="address">배송지</label>
                    <input type="text" id="address" name="address" required>
                </div>

                <div class="payment-buttons">
                    <button type="submit">결제 진행</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>