# Family Bonding App 🚀

A full-stack Spring Boot application designed to enhance family engagement through challenges, shared shopping lists, and educational quizzes.

## 📋 Features
- **Family Management:** Create or join a family unit.
- **Challenges:** Participate in family challenges and earn points.
- **Shared Shopping List:** Real-time synchronized shopping lists for the whole family.
- **Educational Quizzes:** Fun quizzes to learn together.
- **Leaderboard:** Track who is the most active family member.
- **Dashboard:** At-a-glance view of family activities and notifications.

## 🛠️ Technology Stack
- **Backend:** Spring Boot 3, Spring Security, JWT, JPA/Hibernate.
- **Frontend:** JSP (JavaServer Pages), Vanilla CSS, JavaScript.
- **Database:** MySQL.
- **Documentation:** Swagger UI (OpenAPI 3).

## 🚀 Getting Started

### 1. Prerequisites
- Java 17 or higher
- MySQL Server
- Maven (included via `./mvnw`)

### 2. Database Setup
1. Create a MySQL database named `family_bonding_db`.
2. The application will automatically create the necessary tables on first run.

### 3. Environment Variables
To run in production or a hosted environment, set the following environment variables:

| Variable | Description | Default (Local) |
| :--- | :--- | :--- |
| `SPRING_DATASOURCE_URL` | JDBC URL for MySQL | `jdbc:mysql://localhost:3306/family_bonding_db` |
| `SPRING_DATASOURCE_USERNAME` | MySQL Username | `root` |
| `SPRING_DATASOURCE_PASSWORD` | MySQL Password | *(empty)* |
| `JWT_SECRET` | Secret key for JWT signing | *(hardcoded fallback)* |
| `PORT` | Application port | `8080` |

### 4. Running Locally
```powershell
./mvnw spring-boot:run
```
Access at: [http://localhost:8080/family-bonding-api/](http://localhost:8080/family-bonding-api/)

### 5. Production Build
To create a deployable `.war` file:
```powershell
./mvnw clean package -DskipTests
```
The artifact will be located at `target/family-bonding-api-1.0.0-SNAPSHOT.war`.

## 📖 API Documentation
Once the app is running, access the Swagger UI at:
`http://localhost:8080/family-bonding-api/swagger-ui/index.html`

## 🛡️ Security
- **Authentication:** JWT-based stateless authentication.
- **Permissions:** Restricted access to family-specific data based on user membership.
