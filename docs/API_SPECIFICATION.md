# REST API Specification

This document defines the API contract between the Flutter client and the backend server.

**Base URL**: `/api/v1`

**Authentication**: All endpoints (unless specified) require a `Bearer <token>` in the `Authorization` header.

---

## 1. Authentication

### `POST /auth/register`
-   **Description**: Register a new user with email and password.
-   **Body**: `{ "email": "user@example.com", "password": "...", "displayName": "..." }`
-   **Response (201 Created)**: `{ "user": { ... }, "token": "..." }`

### `POST /auth/login`
-   **Description**: Log in a user with email and password.
-   **Body**: `{ "email": "user@example.com", "password": "..." }`
-   **Response (200 OK)**: `{ "user": { ... }, "token": "..." }`

### `POST /auth/google`
-   **Description**: Log in or register a user via Google.
-   **Body**: `{ "idToken": "..." }` (Token from Google Sign-In on the client)
-   **Response (200 OK)**: `{ "user": { ... }, "token": "..." }`

### `POST /auth/apple`
-   **Description**: Log in or register a user via Apple.
-   **Body**: `{ "idToken": "..." }` (Token from Sign in with Apple on the client)
-   **Response (200 OK)**: `{ "user": { ... }, "token": "..." }`

---

## 2. Tournaments

### `POST /tournaments`
-   **Description**: Create a new tournament.
-   **Body**: `{ "name": "My Tournament" }`
-   **Response (201 Created)**: `{ "id": "...", "name": "...", "ownerId": "..." }`

### `GET /tournaments`
-   **Description**: Get all tournaments for the authenticated user.
-   **Response (200 OK)**: `[{ "id": "...", "name": "..." }, ...]`

### `GET /tournaments/:id`
-   **Description**: Get details for a single tournament.
-   **Response (200 OK)**: `{ "id": "...", "name": "...", "groups": [...], "matches": [...] }`

### `PUT /tournaments/:id`
-   **Description**: Update a tournament's details.
-   **Body**: `{ "name": "New Name" }`
-   **Response (200 OK)**: `{ "id": "...", "name": "New Name", ... }`

### `DELETE /tournaments/:id`
-   **Description**: Delete a tournament.
-   **Response (204 No Content)**

---

## 3. Groups (Teams)

*Endpoints are nested under tournaments.*

### `POST /tournaments/:tournamentId/groups`
-   **Description**: Add a new group to a tournament.
-   **Body**: `{ "name": "Team A" }`
-   **Response (201 Created)**: `{ "id": "...", "name": "Team A", ... }`

### `GET /tournaments/:tournamentId/groups`
-   **Description**: Get all groups in a tournament.
-   **Response (200 OK)**: `[{ "id": "...", "name": "..." }, ...]`

... (PUT, DELETE for groups)

---

## 4. Players

*Endpoints are nested under groups.*

### `POST /groups/:groupId/players`
-   **Description**: Add a new player to a group.
-   **Body**: `{ "name": "John Doe", "role": "Striker" }`
-   **Response (201 Created)**: `{ "id": "...", "name": "John Doe", ... }`

### `GET /groups/:groupId/players`
-   **Description**: Get all players in a group.
-   **Response (200 OK)**: `[{ "id": "...", "name": "..." }, ...]`

... (PUT, DELETE for players)

---

## 5. Matches

*Endpoints are nested under tournaments.*

### `POST /tournaments/:tournamentId/matches`
-   **Description**: Create a new match.
-   **Body**: `{ "group1Id": "...", "group2Id": "...", "matchDate": "..." }`
-   **Response (201 Created)**: `{ "id": "...", ... }`

### `GET /tournaments/:tournamentId/matches`
-   **Description**: Get all matches for a tournament.
-   **Response (200 OK)**: `[{ "id": "...", ... }, ...]`

### `PUT /matches/:id`
-   **Description**: Update a match (e.g., scores, status).
-   **Body**: `{ "group1Score": 1, "group2Score": 0, "status": "finished" }`
-   **Response (200 OK)**: `{ "id": "...", ... }`

---

## 6. Events

*Endpoints are nested under matches.*

### `POST /matches/:matchId/events`
-   **Description**: Add an event to a match.
-   **Body**: `{ "playerId": "...", "type": "goal", "minute": 42 }`
-   **Response (201 Created)**: `{ "id": "...", ... }`

---

## 7. Business Logic

### `GET /tournaments/:id/standings`
-   **Description**: Get the calculated standings (classifica) for a tournament.
-   **Response (200 OK)**: `[{ "groupId": "...", "teamName": "...", "played": 3, "wins": 2, "draws": 1, "losses": 0, "points": 7 }, ...]`

### `GET /tournaments/:id/scorers`
-   **Description**: Get the top scorers (marcatori) for a tournament.
-   **Response (200 OK)**: `[{ "playerId": "...", "playerName": "...", "goals": 5 }, ...]`
