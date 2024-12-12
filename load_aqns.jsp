<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, org.json.JSONArray, org.json.JSONObject" %>
<%
    // JSON 응답 타입 설정
    response.setContentType("application/json; charset=UTF-8");
    JSONArray resultArray = new JSONArray(); // 결과 데이터를 저장할 JSON 배열 생성

    try (Connection conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/members?useUnicode=true&characterEncoding=utf8", // 데이터베이스 연결 URL
            "webuser", "webpassword"); // DB 사용자명과 비밀번호
         PreparedStatement pstmt = conn.prepareStatement(
            "SELECT q.qna_id, q.title, q.content, q.created_at, q.answered_at, q.answer_content, " + 
            "m1.member_name AS asker_name, m2.member_name AS answerer_name " +
            "FROM qna q " + 
            "LEFT JOIN members m1 ON q.member_id = m1.member_id " + // 질문 작성자 이름 조회
            "LEFT JOIN members m2 ON q.answer_member_id = m2.member_id")) { // 답변 작성자 이름 조회

        ResultSet rs = pstmt.executeQuery(); // SQL 쿼리 실행
        while (rs.next()) {
            JSONObject qna = new JSONObject(); // 각 Q&A 데이터를 저장할 JSON 객체 생성
            qna.put("qna_id", rs.getInt("qna_id")); // Q&A ID
            qna.put("title", rs.getString("title")); // 질문 제목
            qna.put("content", rs.getString("content")); // 질문 내용
            qna.put("created_at", rs.getString("created_at")); // 질문 생성 날짜
            qna.put("asker_name", rs.getString("asker_name")); // 질문 작성자 이름
            qna.put("answered_at", rs.getString("answered_at")); // 답변 작성 날짜
            qna.put("answer_content", rs.getString("answer_content")); // 답변 내용
            qna.put("answerer_name", rs.getString("answerer_name")); // 답변 작성자 이름

            resultArray.put(qna); // JSON 객체를 결과 배열에 추가
        }
    } catch (Exception e) {
        e.printStackTrace(); // 예외 발생 시 스택 추적 출력
    }

    out.print(resultArray); // JSON 배열을 클라이언트로 출력
%>
