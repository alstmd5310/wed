<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>장바구니</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f7f7f7; }
        .container { max-width: 800px; margin: auto; padding: 20px; background: white; border: 1px solid #ddd; border-radius: 8px; }
        .cart-item { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; padding-bottom: 15px; border-bottom: 1px solid #ddd; }
        .cart-item h3 { margin: 0; font-size: 18px; }
        .cart-item p { margin: 5px 0; color: #555; }
        .actions { display: flex; justify-content: space-between; margin-top: 20px; }
        .actions button { padding: 10px 20px; font-size: 16px; border: none; border-radius: 5px; cursor: pointer; }
        .btn-back { background-color: #f5f5f5; color: #333; }
        .btn-back:hover { background-color: #e0e0e0; }
        .btn-pay { background-color: #28a745; color: white; }
        .btn-pay:hover { background-color: #218838; }
    </style>
</head>
<body>
    <div class="container">
        <h1>장바구니</h1>
        <%
            HttpSession session = request.getSession();
            List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");
            if (cart == null || cart.isEmpty()) {
        %>
            <p>장바구니가 비어 있습니다.</p>
        <%
            } else {
                for (Map<String, Object> item : cart) {
                    String name = (String) item.get("name");
                    int price = (int) item.get("price");
                    int quantity = (int) item.get("quantity");
        %>
                <div class="cart-item">
                    <div>
                        <h3><%= name %></h3>
                        <p>₩<%= String.format("%,d", price) %> × <%= quantity %>개</p>
                    </div>
                    <div>
                        <p>총: ₩<%= String.format("%,d", price * quantity) %></p>
                    </div>
                </div>
        <%
                }
            }
        %>
        
        <div class="actions">
            <!-- index.html로 돌아가는 버튼 -->
            <button class="btn-back" onclick="location.href='index.html'">계속 쇼핑하기</button>
            
            <!-- payment.jsp로 이동하는 버튼 -->
            <form action="payment.jsp" method="post" style="margin: 0;">
                <button type="submit" class="btn-pay">결제하기</button>
            </form>
        </div>
    </div>
</body>
</html>
