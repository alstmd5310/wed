import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class ProductSearch {
    public static void main(String[] args) {
        // MySQL 연결 정보
        String url = "jdbc:mysql://localhost:3306/members?useSSL=false&serverTimezone=UTC";
        String username = "webuser";
        String password = "webpassword";

        // 검색어 설정
        String searchQuery = "상의"; // 검색어를 여기서 설정

        // MySQL 연결 및 검색
        try (Connection conn = DriverManager.getConnection(url, username, password)) {
            System.out.println("데이터베이스에 연결되었습니다.");

            // SQL 쿼리 준비
            String sql = "SELECT id, name, category, price, image_url, description " +
                         "FROM products " +
                         "WHERE name LIKE ? OR category LIKE ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, "%" + searchQuery + "%");
                stmt.setString(2, "%" + searchQuery + "%");

                // 쿼리 실행
                ResultSet rs = stmt.executeQuery();

                // 결과 출력
                while (rs.next()) {
                    int id = rs.getInt("id");
                    String name = rs.getString("name");
                    String category = rs.getString("category");
                    double price = rs.getDouble("price");
                    String imageUrl = rs.getString("image_url");
                    String description = rs.getString("description");

                    System.out.println("ID: " + id);
                    System.out.println("Name: " + name);
                    System.out.println("Category: " + category);
                    System.out.println("Price: " + price);
                    System.out.println("Image URL: " + imageUrl);
                    System.out.println("Description: " + description);
                    System.out.println("---------------------------");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
