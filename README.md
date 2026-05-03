# DISCTS - Drug Inventory & Supply Chain Tracking System

A full-stack pharmaceutical supply chain management system featuring a premium Glassmorphism UI (Flutter) and a secure Spring Boot backend.

## 🚀 Key Features
- **Real-time Telemetry Dashboard**: Visual data representing supply chain health.
- **Inventory Management**: Full CRUD operations for drugs with low-stock alerts.
- **Secure Authentication**: JWT-based security with Role-Based Access Control (RBAC).
- **Glassmorphism UI**: High-end, modern design with animated backgrounds and blurred surfaces.

## 🛠️ Technology Stack
- **Frontend**: Flutter (Web)
- **Backend**: Spring Boot (Java 21)
- **Database**: H2 (In-memory for Dev) / PostgreSQL (Prod ready)
- **Security**: Spring Security + JWT
- **Containerization**: Docker & Docker Compose

---

## 🏃 Getting Started

### 🐳 Run with Docker (Recommended)
The easiest way to run the entire system is using Docker Compose.

1. Ensure you have [Docker](https://www.docker.com/) installed.
2. Run the following command in the root directory:
   ```bash
   docker-compose up --build
   ```
3. Access the app:
   - **Frontend**: `http://localhost`
   - **Backend API**: `http://localhost:8080`

---

### 💻 Local Development

#### 1. Backend (Spring Boot)
1. Navigate to the `backend` folder.
2. Run using Maven:
   ```bash
   ./mvnw spring-boot:run
   ```
   *Note: If `mvnw` is not available, use your local Maven installation.*

#### 2. Frontend (Flutter Web)
1. Navigate to the `frontend` folder.
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run -d chrome
   ```

---

## 📂 Project Structure
- `/backend`: Spring Boot source code and Dockerfile.
- `/frontend`: Flutter source code and Dockerfile.
- `docker-compose.yml`: Orchestration for both services.
- `run_discts.bat`: Windows helper script for simultaneous local launch.

## 🔗 Repository
[https://github.com/Krishnaaka/flutter-Drug.git](https://github.com/Krishnaaka/flutter-Drug.git)

## 👤 Author
**Krishnaaka**
