# Quaderno Torneo - Custom Backend

This document outlines the plan and specifications for building a custom backend to replace the existing Firebase infrastructure for the Quaderno Torneo Flutter application.

## Project Goals

-   Develop a scalable and maintainable backend solution.
-   Replicate all existing functionality provided by Firebase (Auth, Firestore, etc.).
-   Provide a clear, well-documented RESTful API for the Flutter client.

## Technology Stack

-   **Language/Framework**: Node.js with TypeScript and Express.js
-   **Database**: PostgreSQL
-   **ORM**: Prisma
-   **Authentication**: JSON Web Tokens (JWT)
-   **File Storage**: AWS S3 (or a compatible object storage service)
-   **Deployment**: Docker

## Documentation

This directory contains the following project documents:

-   `ARCHITECTURE.md`: A high-level overview of the backend system architecture.
-   `DATABASE_SCHEMA.md`: Detailed schema for the PostgreSQL database.
-   `API_SPECIFICATION.md`: The complete REST API contract.
-   `PROJECT_ROADMAP.md`: A phased development and migration plan.
