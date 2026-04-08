import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DbTest {
    public static void main(String[] args) {
        String url = "jdbc:mysql://127.0.0.1:3306/family_bonding_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
        String user = "root";
        String password = "";

        try {
            System.out.println("Attempting to connect to " + url);
            Connection conn = DriverManager.getConnection(url, user, password);
            System.out.println("SUCCESS: Connected to the database!");
            conn.close();
        } catch (SQLException e) {
            System.out.println("FAILURE: Could not connect to the database.");
            System.out.println("Error Code: " + e.getErrorCode());
            System.out.println("SQL State: " + e.getSQLState());
            e.printStackTrace();
        }
    }
}
