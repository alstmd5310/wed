<%@ page contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, org.json.JSONArray, org.json.JSONObject" %>
<%
    // JSON 응답 객체 생성
    JSONObject response = new JSONObject();

    // 요청 action 파라미터 확인
    String action = request.getParameter("action");

    try {
        // 데이터베이스 연결
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/shop", "root", "password");

        // 로그인 상태 확인
        if ("checkLogin".equals(action)) {
            String username = (String) session.getAttribute("username");
            boolean loggedIn = (username != null);

            response.put("loggedIn", loggedIn);
            if (loggedIn) {
                response.put("username", username);
            }
        }

        // 문의 등록
        else if ("submitInquiry".equals(action)) {
            String text = request.getParameter("text");
            String userId = (String) session.getAttribute("user_id");

            if (userId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
            } else {
                String sql = "INSERT INTO inquiries (user_id, text, created_at) VALUES (?, ?, NOW())";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, Integer.parseInt(userId));
                pstmt.setString(2, text);
                pstmt.executeUpdate();

                response.put("success", true);
            }
        }

        // 문의 리스트 조회
        else if ("getInquiries".equals(action)) {
            String userId = (String) session.getAttribute("user_id");

            if (userId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
            } else {
                String sql = "SELECT text, created_at, answer, answer_at FROM inquiries WHERE user_id = ?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, Integer.parseInt(userId));
                ResultSet rs = pstmt.executeQuery();

                JSONArray inquiries = new JSONArray();
                while (rs.next()) {
                    JSONObject inquiry = new JSONObject();
                    inquiry.put("text", rs.getString("text"));
                    inquiry.put("created_at", rs.getString("created_at"));
                    inquiry.put("answer", rs.getString("answer"));
                    inquiry.put("answer_at", rs.getString("answer_at"));
                    inquiries.put(inquiry);
                }
                response.put("success", true);
                response.put("inquiries", inquiries);
            }
        }

        // 알 수 없는 action 처리
        else {
            response.put("success", false);
            response.put("message", "유효하지 않은 요청입니다.");
        }

    } catch (Exception e) {
        e.printStackTrace();
        response.put("success", false);
        response.put("message", "오류가 발생했습니다: " + e.getMessage());
    }

    // 응답 출력
    out.print(response.toString());
%>