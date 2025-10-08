# Backend System Architecture

This document describes the high-level architecture for the Quaderno Torneo backend.

## Components

1.  **Flutter Application**: The existing mobile client. It will communicate with the new backend via the REST API.

2.  **API Server**: A Node.js application built with Express.js and TypeScript. This is the core of the backend.
    -   Handles all incoming HTTP requests from the client.
    -   Implements business logic (calculating standings, top scorers, etc.).
    -   Manages authentication and authorization using JWTs.
    -   Interfaces with the database via the Prisma ORM.
    -   Handles file uploads/downloads by interacting with the Object Storage service.

3.  **PostgreSQL Database**: A relational database that stores all core application data.
    -   Stores users, tournaments, teams, players, matches, and events.
    -   Managed by the API server through Prisma.

4.  **Object Storage (AWS S3)**: A service for storing static files.
    -   Used for user profile pictures, team logos, or any other user-uploaded content.
    -   The API server will provide signed URLs to the client for secure uploads and downloads.

## Data Flow Diagram

```
[Flutter App] <-- HTTPS --> [API Server (Node.js/Express)]
                      |
                      +-----> [PostgreSQL Database (Prisma)]
                      |
                      +-----> [Object Storage (AWS S3)]
```

## Authentication Flow

1.  User registers or logs in via the Flutter app (email/password, Google, or Apple).
2.  The API Server verifies credentials or social provider tokens.
3.  Upon success, the server generates a JWT and returns it to the client.
4.  The Flutter app stores the JWT securely and includes it in the `Authorization` header for all subsequent authenticated requests.
