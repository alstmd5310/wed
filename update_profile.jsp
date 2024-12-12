<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.JSONObject" %>
<%
    // 응답과 요청의 인코딩을 UTF-8로 설정
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    request.setCharacterEncoding("UTF-8"); // UTF-8 설정 추가

    JSONObject jsonResponse = new JSONObject(); // JSON 응답 객체 생성

    // 데이터베이스 연결 정보
    String dbUrl = "jdbc:mysql://localhost:3306/members?useUnicode=true&characterEncoding=utf8";
    String dbUser = "webuser";
    String dbPassword = "webpassword";

    try {
        // 클라이언트로부터 전달받은 요청 파라미터를 읽음
        String id = request.getParameter("id"); // 회원 ID
        String email = request.getParameter("email"); // 이메일
        String name = request.getParameter("name"); // 이름
        String address = request.getParameter("address"); // 주소
        String newPassword = request.getParameter("newPassword"); // 새로운 비밀번호

        // 디버깅용 로그 출력
        System.out.println("ID: " + id);
        System.out.println("Email: " + email);
        System.out.println("Name: " + name);
        System.out.println("Address: " + address);
        System.out.println("New Password: " + newPassword);

        // ID 파라미터가 비어 있으면 에러 응답
        if (id == null || id.isEmpty()) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "ID parameter is missing.");
        } else {
            // 데이터베이스 연결 생성
            Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

            // 업데이트 SQL 쿼리 준비
            String sql = "UPDATE members SET member_email = ?, member_name = ?, member_address = ?, member_password = ? WHERE member_id = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email); // 이메일 설정
            pstmt.setString(2, name); // 이름 설정
            pstmt.setString(3, address); // 주소 설정
            pstmt.setString(4, newPassword); // 비밀번호 설정
            pstmt.setString(5, id); // ID 설정

            // SQL 실행
            int rowsUpdated = pstmt.executeUpdate();
            if (rowsUpdated > 0) { // 업데이트 성공 여부 확인
                jsonResponse.put("success", true);
                jsonResponse.put("message", "Profile updated successfully.");
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "No matching record found for the provided ID."); // 일치하는 레코드가 없는 경우
            }

            // 리소스 해제
            pstmt.close();
            conn.close();
        }
    } catch (Exception e) {
        e.printStackTrace(); // 에러 로그 출력
        jsonResponse.put("success", false); // 에러 응답 설정
        jsonResponse.put("message", "Error updating profile: " + e.getMessage()); // 에러 메시지 설정
    }

    // JSON 응답 출력
    out.print(jsonResponse.toString());
%>
