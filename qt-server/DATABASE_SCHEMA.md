# Database Schema (PostgreSQL)

This document defines the table structure for the backend database, managed via Prisma.

---

### Table: `User`

Stores user account and authentication information.

| Column          | Type      | Constraints                 | Description                                  |
| --------------- | --------- | --------------------------- | -------------------------------------------- |
| `id`            | `UUID`    | **Primary Key**             | Unique identifier for the user.              |
| `email`         | `String`  | **Unique**, Not Null        | User's email address.                        |
| `passwordHash`  | `String`  | Nullable                    | Hashed password for email/password auth.     |
| `googleId`      | `String`  | Nullable, Unique            | User's unique ID from Google Sign-In.        |
| `appleId`       | `String`  | Nullable, Unique            | User's unique ID from Sign in with Apple.    |
| `displayName`   | `String`  | Not Null                    | Public display name for the user.            |
| `avatarUrl`     | `String`  | Nullable                    | URL to the user's profile picture.           |
| `createdAt`     | `DateTime`| Default `now()`             | Timestamp of user creation.                  |
| `updatedAt`     | `DateTime`| Auto-updated on modification| Timestamp of last update.                    |

---

### Table: `Tournament`

Represents a single tournament created by a user.

| Column      | Type      | Constraints                 | Description                                  |
| ----------- | --------- | --------------------------- | -------------------------------------------- |
| `id`        | `UUID`    | **Primary Key**             | Unique identifier for the tournament.        |
| `name`      | `String`  | Not Null                    | Name of the tournament.                      |
| `ownerId`   | `UUID`    | **Foreign Key** to `User.id`| The user who owns and manages the tournament.|
| `createdAt` | `DateTime`| Default `now()`             | Timestamp of creation.                       |
| `updatedAt` | `DateTime`| Auto-updated on modification| Timestamp of last update.                    |

**Relations**:
-   A `User` can have many `Tournaments`.
-   A `Tournament` has many `Groups`.
-   A `Tournament` has many `Matches`.

---

### Table: `Group`

Represents a group or team within a tournament.

| Column        | Type      | Constraints                       | Description                                  |
| ------------- | --------- | --------------------------------- | -------------------------------------------- |
| `id`          | `UUID`    | **Primary Key**                   | Unique identifier for the group.             |
| `name`        | `String`  | Not Null                          | Name of the group/team.                      |
| `tournamentId`| `UUID`    | **Foreign Key** to `Tournament.id`| The tournament this group belongs to.        |
| `logoUrl`     | `String`  | Nullable                          | URL to the team's logo.                      |

**Relations**:
-   A `Tournament` can have many `Groups`.
-   A `Group` has many `Players`.

---

### Table: `Player`

Represents a player, assigned to a group.

| Column    | Type      | Constraints                   | Description                                  |
| --------- | --------- | ----------------------------- | -------------------------------------------- |
| `id`      | `UUID`    | **Primary Key**               | Unique identifier for the player.            |
| `name`    | `String`  | Not Null                      | Name of the player.                          |
| `role`    | `String`  | Nullable                      | Player's role (e.g., 'striker', 'defender'). |
| `groupId` | `UUID`    | **Foreign Key** to `Group.id` | The group this player belongs to.            |

**Relations**:
-   A `Group` can have many `Players`.
-   A `Player` can have many `Events`.

---

### Table: `Match`

Represents a single match between two groups in a tournament.

| Column        | Type      | Constraints                       | Description                                  |
| ------------- | --------- | --------------------------------- | -------------------------------------------- |
| `id`          | `UUID`    | **Primary Key**                   | Unique identifier for the match.             |
| `tournamentId`| `UUID`    | **Foreign Key** to `Tournament.id`| The tournament this match is part of.        |
| `group1Id`    | `UUID`    | **Foreign Key** to `Group.id`     | The first group in the match.                |
| `group2Id`    | `UUID`    | **Foreign Key** to `Group.id`     | The second group in the match.               |
| `group1Score` | `Int`     | Default `0`                       | Final score for group 1.                     |
| `group2Score` | `Int`     | Default `0`                       | Final score for group 2.                     |
| `matchDate`   | `DateTime`| Not Null                          | The scheduled date and time of the match.    |
| `status`      | `String`  | Default `'scheduled'`             | e.g., 'scheduled', 'in_progress', 'finished' |

**Relations**:
-   A `Tournament` has many `Matches`.
-   A `Match` has many `Events`.

---

### Table: `Event`

Represents an event that occurs during a match (e.g., goal, card).

| Column    | Type      | Constraints                  | Description                                  |
| --------- | --------- | ---------------------------- | -------------------------------------------- |
| `id`      | `UUID`    | **Primary Key**              | Unique identifier for the event.             |
| `matchId` | `UUID`    | **Foreign Key** to `Match.id`| The match where the event occurred.          |
| `playerId`| `UUID`    | **Foreign Key** to `Player.id`| The player involved in the event.            |
| `type`    | `String`  | Not Null                     | Type of event: `goal`, `assist`, `yellow_card`, `red_card`, `penalty_scored`, `own_goal`. |
| `minute`  | `Int`     | Not Null                     | The minute of the match when the event happened. |

**Relations**:
-   A `Match` can have many `Events`.
-   A `Player` can be associated with many `Events`.
