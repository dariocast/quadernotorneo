# Project Development Roadmap

This roadmap outlines the phased development plan for the custom backend.

---

### Phase 1: Foundation & Authentication (Sprint 1)

-   **Goal**: Set up the project structure and implement a complete authentication system.
-   **Tasks**:
    -   [ ] Initialize Node.js/TypeScript project.
    -   [ ] Set up Express server and basic middleware.
    -   [ ] Integrate Docker for development and production environments.
    -   [ ] Set up PostgreSQL database and integrate Prisma ORM.
    -   [ ] Define `User` schema.
    -   [ ] Implement JWT generation and validation middleware.
    -   [ ] Implement all `/auth` endpoints (register, login, google, apple).
    -   [ ] Write unit and integration tests for authentication.

---

### Phase 2: Core Models CRUD (Sprint 2)

-   **Goal**: Implement CRUD functionality for Tournaments, Groups, and Players.
-   **Tasks**:
    -   [ ] Define `Tournament`, `Group`, and `Player` schemas in Prisma.
    -   [ ] Create API endpoints for full CRUD operations on Tournaments.
    -   [ ] Create API endpoints for full CRUD operations on Groups (nested under tournaments).
    -   [ ] Create API endpoints for full CRUD operations on Players (nested under groups).
    -   [ ] Implement authorization rules (e.g., only the tournament owner can add groups).
    -   [ ] Write integration tests for all new endpoints.

---

### Phase 3: Match & Event Logic (Sprint 3)

-   **Goal**: Implement the core logic for managing matches and game events.
-   **Tasks**:
    -   [ ] Define `Match` and `Event` schemas in Prisma.
    -   [ ] Create API endpoints for CRUD operations on Matches.
    -   [ ] Create API endpoints for adding Events to a match.
    -   [ ] When an event is added (e.g., a 'goal'), create a database trigger or service logic to automatically update the corresponding `Match` score.
    -   [ ] Write tests for event and score-updating logic.

---

### Phase 4: Business Logic & Advanced Features (Sprint 4)

-   **Goal**: Implement calculated endpoints and file uploads.
-   **Tasks**:
    -   [ ] Implement the `/tournaments/:id/standings` endpoint with correct calculation logic.
    -   [ ] Implement the `/tournaments/:id/scorers` endpoint.
    -   [ ] Set up AWS S3 (or alternative) and configure credentials.
    -   [ ] Create an endpoint to provide a pre-signed URL for client-side file uploads (e.g., `/users/me/avatar-upload-url`).
    -   [ ] Create endpoints to update user/group profiles with the URL of the uploaded file.
    -   [ ] Add caching for expensive calculations like standings if needed.

---

### Phase 5: Deployment & Migration (Sprint 5)

-   **Goal**: Deploy the backend and prepare the Flutter app for migration.
-   **Tasks**:
    -   [ ] Finalize production Dockerfile.
    -   [ ] Deploy the backend to a cloud provider (e.g., AWS ECS, DigitalOcean, Heroku).
    -   [ ] Set up production database and run migrations.
    -   [ ] Set up logging and monitoring.
    -   [ ] Begin refactoring the Flutter application's `repository` layer to use the new REST API endpoints instead of Firebase.
    -   [ ] Plan data migration strategy for existing Firebase data (if any).
