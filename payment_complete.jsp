<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="common.css"> <!-- 공통 CSS 파일 연결 -->
    <title>결제 완료</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f9f9f9; text-align: center; padding-top: 50px; }
        .container { background-color: white; padding: 20px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); width: 400px; margin: 0 auto; }
        .message { font-size: 1.5rem; font-weight: bold; color: #28a745; margin-bottom: 20px; }
        .back-button { padding: 10px 20px; background-color: black; color: white; border: none; cursor: pointer; border-radius: 5px; font-size: 14px; }
        .back-button:hover { background-color: #444; }
    </style>
</head>
<body>
    <%
    request.setCharacterEncoding("UTF-8"); // POST 방식 인코딩 설정
        String productId = request.getParameter("product_id");
        String productName = request.getParameter("product_name");
        String productPrice = request.getParameter("product_price");
        String productImageUrl = request.getParameter("product_image_url");
        String customerName = request.getParameter("name");
        String cardNumber = request.getParameter("card_number");
        String address = request.getParameter("address");

        if (productId == null || productId.isEmpty()) {
            out.println("<p>결제 정보가 유효하지 않습니다.</p>");
            return;
        }
    %>

    <div class="container">
        <div class="message">결제가 완료되었습니다!</div>
        <p><strong>상품명:</strong> <%= productName %></p>
        <p><strong>결제 금액:</strong> ₩<%= String.format("%,d", Integer.parseInt(productPrice)) %></p>
        <p><strong>성명:</strong> <%= customerName %></p>
        <p><strong>배송지:</strong> <%= address %></p>

        <!-- 뒤로 가기 버튼 -->
        <form action="index.html" method="get">
            <button type="submit" class="back-button">홈으로 돌아가기</button>
        </form>
    </div>
</body>
</html>