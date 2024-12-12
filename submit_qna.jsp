<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, org.json.JSONObject" %>
<%
    JSONObject responseJson = new JSONObject(); // JSON 응답 객체 생성
    try {
        // 요청 데이터 읽기
        StringBuilder sb = new StringBuilder(); 
        String line;
        while ((line = request.getReader().readLine()) != null) { // POST 요청의 데이터를 한 줄씩 읽음
            sb.append(line);
        }
        JSONObject requestJson = new JSONObject(sb.toString()); // 읽은 데이터를 JSON 객체로 변환

        // 요청 데이터 추출
        String title = requestJson.getString("title"); // 질문 제목
        String content = requestJson.getString("content"); // 질문 내용
        int userId = requestJson.getInt("userId"); // 작성자 ID

        // 데이터베이스 연결 설정
        Connection conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/members?useUnicode=true&characterEncoding=utf8", // DB URL
            "webuser", "webpassword" // 사용자명과 비밀번호
        );

        // Q&A 테이블에 데이터를 삽입하는 SQL 쿼리
        String sql = "INSERT INTO qna (title, content, asker_member_id, created_at) VALUES (?, ?, ?, NOW())";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, title); // 제목 바인딩
            stmt.setString(2, content); // 내용 바인딩
            stmt.setInt(3, userId); // 작성자 ID 바인딩

            int rows = stmt.executeUpdate(); // SQL 실행
            if (rows > 0) {
                responseJson.put("success", true); // 성공 여부를 JSON 응답에 추가
            } else {
                responseJson.put("success", false).put("message", "질문 등록 실패"); // 실패 메시지 추가
            }
        }
        conn.close(); // 데이터베이스 연결 종료
    } catch (Exception e) {
        e.printStackTrace(); // 예외 발생 시 서버 콘솔에 출력
        responseJson.put("success", false).put("message", "서버 오류 발생: " + e.getMessage()); // 오류 메시지를 JSON 응답에 추가
    }
    out.print(responseJson.toString()); // 클라이언트에 JSON 응답 전송
%>
