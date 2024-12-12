<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%
    // POST로 전달된 파라미터 받기
    request.setCharacterEncoding("UTF-8"); // POST 방식 인코딩 설정
    String productId = request.getParameter("product_id");
    String productName = request.getParameter("product_name");
    int productPrice = Integer.parseInt(request.getParameter("product_price"));

    // 세션에서 장바구니 정보를 가져옴
    List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");
    if (cart == null) {
        cart = new ArrayList<>();
    }

    // 장바구니에 동일한 상품이 있는지 확인
    boolean found = false;
    for (Map<String, Object> item : cart) {
        if (item.get("id").equals(productId)) {
            // 이미 장바구니에 있으면 추가하지 않음
            found = true;
            break;
        }
    }

    // 새 상품을 장바구니에 추가
    if (!found) {
        Map<String, Object> newItem = new HashMap<>();
        newItem.put("id", productId);
        newItem.put("name", productName);
        newItem.put("price", productPrice);
        cart.add(newItem);
    }

    // 장바구니 정보를 세션에 업데이트
    session.setAttribute("cart", cart);

    // 장바구니 페이지로 리다이렉트
    response.sendRedirect("cart.jsp");
%>
