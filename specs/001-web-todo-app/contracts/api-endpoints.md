# API Contracts: Full-Stack Web Todo Application (Phase II)

**Date**: 2025-12-28
**Feature**: Full-Stack Web Todo App
**Base URL**: `http://localhost:8000/api` (development), `https://api.todo-app.com/api` (production)
**Protocol**: REST over HTTP/HTTPS
**Content-Type**: `application/json`

## Overview

This document specifies all REST API endpoints for the multi-user todo application. All task-related endpoints require JWT authentication. Responses follow standard HTTP status codes with JSON payloads.

---

## Authentication

### JWT Token Format

All authenticated requests must include a JWT token in the Authorization header:

```http
Authorization: Bearer <jwt_token>
```

**Token Payload**:
```json
{
  "sub": "user@example.com",
  "user_id": 123,
  "exp": 1704096000
}
```

**Token Expiry**: 7 days (604800 seconds) from issue time

---

## Endpoints

### 1. User Registration

**Purpose**: Create a new user account.

**Endpoint**: `POST /api/auth/register`

**Authentication**: None (public endpoint)

**Request Body**:
```json
{
  "email": "user@example.com",
  "password": "securepassword123"
}
```

**Request Schema**:
| Field | Type | Required | Constraints |
|-------|------|----------|-------------|
| `email` | string | Yes | Valid email format, 5-255 chars |
| `password` | string | Yes | Min 8 characters |

**Response (201 Created)**:
```json
{
  "id": 1,
  "email": "user@example.com",
  "created_at": "2025-12-28T10:30:00Z",
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer"
}
```

**Response Schema** (success):
| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | User ID |
| `email` | string | User's email address |
| `created_at` | string (ISO 8601) | Account creation timestamp |
| `access_token` | string | JWT token for authentication |
| `token_type` | string | Always "bearer" |

**Error Responses**:

- **400 Bad Request** - Invalid email format or password too short:
  ```json
  {
    "detail": "Password must be at least 8 characters"
  }
  ```

- **409 Conflict** - Email already registered:
  ```json
  {
    "detail": "Email already registered"
  }
  ```

- **422 Unprocessable Entity** - Validation error:
  ```json
  {
    "detail": [
      {
        "loc": ["body", "email"],
        "msg": "field required",
        "type": "value_error.missing"
      }
    ]
  }
  ```

**Test Scenarios**:
1. Valid registration with unique email → 201
2. Registration with existing email → 409
3. Registration with invalid email format → 422
4. Registration with password < 8 chars → 400
5. Registration with missing fields → 422

---

### 2. User Login

**Purpose**: Authenticate existing user and receive JWT token.

**Endpoint**: `POST /api/auth/login`

**Authentication**: None (public endpoint)

**Request Body**:
```json
{
  "email": "user@example.com",
  "password": "securepassword123"
}
```

**Request Schema**:
| Field | Type | Required | Constraints |
|-------|------|----------|-------------|
| `email` | string | Yes | Valid email format |
| `password` | string | Yes | Any non-empty string |

**Response (200 OK)**:
```json
{
  "id": 1,
  "email": "user@example.com",
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer"
}
```

**Response Schema** (success):
| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | User ID |
| `email` | string | User's email address |
| `access_token` | string | JWT token for authentication |
| `token_type` | string | Always "bearer" |

**Error Responses**:

- **401 Unauthorized** - Invalid credentials:
  ```json
  {
    "detail": "Incorrect email or password"
  }
  ```

- **422 Unprocessable Entity** - Missing fields:
  ```json
  {
    "detail": [
      {
        "loc": ["body", "password"],
        "msg": "field required",
        "type": "value_error.missing"
      }
    ]
  }
  ```

**Test Scenarios**:
1. Login with correct credentials → 200
2. Login with wrong password → 401
3. Login with non-existent email → 401
4. Login with missing password → 422
5. Login with missing email → 422

---

### 3. Get All Tasks

**Purpose**: Retrieve all tasks belonging to the authenticated user.

**Endpoint**: `GET /api/tasks`

**Authentication**: Required (JWT token)

**Request Headers**:
```http
Authorization: Bearer <jwt_token>
```

**Request Body**: None (GET request)

**Response (200 OK)**:
```json
{
  "tasks": [
    {
      "id": 1,
      "user_id": 1,
      "title": "Buy groceries",
      "description": "Milk, eggs, bread",
      "status": "Incomplete",
      "created_at": "2025-12-28T10:30:00Z",
      "updated_at": "2025-12-28T10:30:00Z"
    },
    {
      "id": 2,
      "user_id": 1,
      "title": "Finish project",
      "description": null,
      "status": "Complete",
      "created_at": "2025-12-27T15:20:00Z",
      "updated_at": "2025-12-28T09:00:00Z"
    }
  ],
  "total": 2
}
```

**Response Schema** (success):
| Field | Type | Description |
|-------|------|-------------|
| `tasks` | array | List of task objects (sorted by created_at DESC) |
| `tasks[].id` | integer | Task ID |
| `tasks[].user_id` | integer | Owner user ID (always current user) |
| `tasks[].title` | string | Task title (1-200 chars) |
| `tasks[].description` | string or null | Task description (0-1000 chars) |
| `tasks[].status` | string | "Complete" or "Incomplete" |
| `tasks[].created_at` | string (ISO 8601) | Task creation timestamp |
| `tasks[].updated_at` | string (ISO 8601) | Last update timestamp |
| `total` | integer | Total number of tasks |

**Error Responses**:

- **401 Unauthorized** - Missing or invalid JWT token:
  ```json
  {
    "detail": "Not authenticated"
  }
  ```

**Empty State** (no tasks):
```json
{
  "tasks": [],
  "total": 0
}
```

**Test Scenarios**:
1. Get tasks with valid token → 200 with user's tasks only
2. Get tasks without token → 401
3. Get tasks with expired token → 401
4. Get tasks for user with no tasks → 200 with empty array
5. Verify user isolation (User A cannot see User B's tasks)

---

### 4. Create Task

**Purpose**: Create a new task for the authenticated user.

**Endpoint**: `POST /api/tasks`

**Authentication**: Required (JWT token)

**Request Headers**:
```http
Authorization: Bearer <jwt_token>
Content-Type: application/json
```

**Request Body**:
```json
{
  "title": "Buy groceries",
  "description": "Milk, eggs, bread"
}
```

**Request Schema**:
| Field | Type | Required | Constraints |
|-------|------|----------|-------------|
| `title` | string | Yes | 1-200 characters, non-empty after trim |
| `description` | string | No | 0-1000 characters if provided, null if omitted |

**Response (201 Created)**:
```json
{
  "id": 3,
  "user_id": 1,
  "title": "Buy groceries",
  "description": "Milk, eggs, bread",
  "status": "Incomplete",
  "created_at": "2025-12-28T11:00:00Z",
  "updated_at": "2025-12-28T11:00:00Z"
}
```

**Response Schema** (success):
| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | New task ID |
| `user_id` | integer | Owner user ID |
| `title` | string | Task title |
| `description` | string or null | Task description |
| `status` | string | Always "Incomplete" for new tasks |
| `created_at` | string (ISO 8601) | Creation timestamp |
| `updated_at` | string (ISO 8601) | Update timestamp (same as created_at initially) |

**Error Responses**:

- **400 Bad Request** - Title is empty after trimming:
  ```json
  {
    "detail": "Title cannot be empty"
  }
  ```

- **400 Bad Request** - Title exceeds 200 characters:
  ```json
  {
    "detail": "Title exceeds 200 characters"
  }
  ```

- **400 Bad Request** - Description exceeds 1000 characters:
  ```json
  {
    "detail": "Description exceeds 1000 characters"
  }
  ```

- **401 Unauthorized** - Missing or invalid token:
  ```json
  {
    "detail": "Not authenticated"
  }
  ```

- **422 Unprocessable Entity** - Missing required field:
  ```json
  {
    "detail": [
      {
        "loc": ["body", "title"],
        "msg": "field required",
        "type": "value_error.missing"
      }
    ]
  }
  ```

**Test Scenarios**:
1. Create task with title only → 201
2. Create task with title and description → 201
3. Create task with empty title → 400
4. Create task with title = 200 chars → 201 (boundary)
5. Create task with title = 201 chars → 400 (boundary)
6. Create task with description = 1000 chars → 201 (boundary)
7. Create task with description = 1001 chars → 400 (boundary)
8. Create task without authentication → 401

---

### 5. Update Task

**Purpose**: Update the title and/or description of an existing task.

**Endpoint**: `PUT /api/tasks/{task_id}`

**Authentication**: Required (JWT token)

**Path Parameters**:
| Parameter | Type | Description |
|-----------|------|-------------|
| `task_id` | integer | ID of the task to update |

**Request Headers**:
```http
Authorization: Bearer <jwt_token>
Content-Type: application/json
```

**Request Body**:
```json
{
  "title": "Updated task title",
  "description": "Updated description"
}
```

**Request Schema**:
| Field | Type | Required | Constraints |
|-------|------|----------|-------------|
| `title` | string | No | 1-200 characters if provided, keeps current value if omitted |
| `description` | string or null | No | 0-1000 characters if provided, keeps current value if omitted |

**Note**: At least one field (title or description) should be provided. If both omitted, request succeeds but no changes made.

**Response (200 OK)**:
```json
{
  "id": 1,
  "user_id": 1,
  "title": "Updated task title",
  "description": "Updated description",
  "status": "Incomplete",
  "created_at": "2025-12-28T10:30:00Z",
  "updated_at": "2025-12-28T12:00:00Z"
}
```

**Response Schema** (success):
| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Task ID |
| `user_id` | integer | Owner user ID |
| `title` | string | Updated (or unchanged) title |
| `description` | string or null | Updated (or unchanged) description |
| `status` | string | Status remains unchanged by this endpoint |
| `created_at` | string (ISO 8601) | Original creation timestamp (unchanged) |
| `updated_at` | string (ISO 8601) | New update timestamp |

**Error Responses**:

- **400 Bad Request** - New title is empty:
  ```json
  {
    "detail": "Title cannot be empty"
  }
  ```

- **400 Bad Request** - Title/description exceeds max length:
  ```json
  {
    "detail": "Title exceeds 200 characters"
  }
  ```

- **401 Unauthorized** - Missing or invalid token:
  ```json
  {
    "detail": "Not authenticated"
  }
  ```

- **403 Forbidden** - Task belongs to different user:
  ```json
  {
    "detail": "Not authorized to modify this task"
  }
  ```

- **404 Not Found** - Task ID doesn't exist:
  ```json
  {
    "detail": "Task not found"
  }
  ```

**Test Scenarios**:
1. Update title only → 200 with new title, old description
2. Update description only → 200 with old title, new description
3. Update both title and description → 200 with both updated
4. Update with empty title → 400
5. Update non-existent task → 404
6. Update another user's task → 403
7. Update without authentication → 401

---

### 6. Toggle Task Status

**Purpose**: Toggle a task between "Complete" and "Incomplete" status.

**Endpoint**: `PATCH /api/tasks/{task_id}/toggle`

**Authentication**: Required (JWT token)

**Path Parameters**:
| Parameter | Type | Description |
|-----------|------|-------------|
| `task_id` | integer | ID of the task to toggle |

**Request Headers**:
```http
Authorization: Bearer <jwt_token>
```

**Request Body**: None (PATCH with no body)

**Response (200 OK)**:
```json
{
  "id": 1,
  "user_id": 1,
  "title": "Buy groceries",
  "description": "Milk, eggs, bread",
  "status": "Complete",
  "created_at": "2025-12-28T10:30:00Z",
  "updated_at": "2025-12-28T12:30:00Z"
}
```

**Response Schema** (success):
| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Task ID |
| `user_id` | integer | Owner user ID |
| `title` | string | Title (unchanged) |
| `description` | string or null | Description (unchanged) |
| `status` | string | New status ("Complete" if was "Incomplete", vice versa) |
| `created_at` | string (ISO 8601) | Original creation timestamp (unchanged) |
| `updated_at` | string (ISO 8601) | New update timestamp |

**Status Transitions**:
- `"Incomplete"` → `"Complete"`
- `"Complete"` → `"Incomplete"`

**Error Responses**:

- **401 Unauthorized** - Missing or invalid token:
  ```json
  {
    "detail": "Not authenticated"
  }
  ```

- **403 Forbidden** - Task belongs to different user:
  ```json
  {
    "detail": "Not authorized to modify this task"
  }
  ```

- **404 Not Found** - Task ID doesn't exist:
  ```json
  {
    "detail": "Task not found"
  }
  ```

**Test Scenarios**:
1. Toggle incomplete task → 200 with status="Complete"
2. Toggle complete task → 200 with status="Incomplete"
3. Toggle twice → returns to original status
4. Toggle non-existent task → 404
5. Toggle another user's task → 403
6. Toggle without authentication → 401

---

### 7. Delete Task

**Purpose**: Permanently delete a task.

**Endpoint**: `DELETE /api/tasks/{task_id}`

**Authentication**: Required (JWT token)

**Path Parameters**:
| Parameter | Type | Description |
|-----------|------|-------------|
| `task_id` | integer | ID of the task to delete |

**Request Headers**:
```http
Authorization: Bearer <jwt_token>
```

**Request Body**: None (DELETE request)

**Response (204 No Content)**:
- No response body
- HTTP status code 204 indicates successful deletion

**Alternative Response (200 OK)** with confirmation:
```json
{
  "detail": "Task deleted successfully",
  "deleted_task_id": 1
}
```

**Error Responses**:

- **401 Unauthorized** - Missing or invalid token:
  ```json
  {
    "detail": "Not authenticated"
  }
  ```

- **403 Forbidden** - Task belongs to different user:
  ```json
  {
    "detail": "Not authorized to delete this task"
  }
  ```

- **404 Not Found** - Task ID doesn't exist:
  ```json
  {
    "detail": "Task not found"
  }
  ```

**Test Scenarios**:
1. Delete existing task → 204 or 200
2. Verify task no longer appears in GET /tasks → empty or reduced list
3. Delete non-existent task → 404
4. Delete another user's task → 403
5. Delete without authentication → 401
6. Delete same task twice → 404 on second attempt

---

## Error Response Format

All error responses follow a consistent format:

```json
{
  "detail": "Human-readable error message"
}
```

For validation errors (422), the format includes field-level details:

```json
{
  "detail": [
    {
      "loc": ["body", "field_name"],
      "msg": "error description",
      "type": "error_type"
    }
  ]
}
```

---

## HTTP Status Codes

| Status Code | Meaning | When Used |
|-------------|---------|-----------|
| 200 OK | Success | GET, PUT, PATCH requests succeeded |
| 201 Created | Resource created | POST /register, POST /tasks succeeded |
| 204 No Content | Success with no body | DELETE /tasks succeeded |
| 400 Bad Request | Client error | Validation failed (e.g., empty title) |
| 401 Unauthorized | Not authenticated | Missing or invalid JWT token |
| 403 Forbidden | Not authorized | Valid token but trying to access another user's resource |
| 404 Not Found | Resource not found | Task ID doesn't exist |
| 409 Conflict | Resource conflict | Email already registered |
| 422 Unprocessable Entity | Validation error | Pydantic schema validation failed |
| 500 Internal Server Error | Server error | Database error, unexpected exception |

---

## CORS Configuration

**Allowed Origins** (development):
- `http://localhost:3000` (Next.js frontend)

**Allowed Origins** (production):
- `https://todo-app.com` (actual frontend domain)

**Allowed Methods**: `GET`, `POST`, `PUT`, `PATCH`, `DELETE`, `OPTIONS`

**Allowed Headers**: `Authorization`, `Content-Type`

**Allow Credentials**: `true` (for cookies/auth headers)

---

## Rate Limiting (Future Enhancement)

Not implemented in Phase II, but recommended for production:

- **Registration**: 5 requests per IP per hour
- **Login**: 10 requests per IP per 15 minutes (prevent brute force)
- **API Endpoints**: 100 requests per user per minute

---

## Testing with curl

### Register
```bash
curl -X POST http://localhost:8000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email": "user@example.com", "password": "password123"}'
```

### Login
```bash
curl -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "user@example.com", "password": "password123"}'
```

### Create Task
```bash
curl -X POST http://localhost:8000/api/tasks \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <token>" \
  -d '{"title": "Buy milk", "description": "From the store"}'
```

### Get All Tasks
```bash
curl -X GET http://localhost:8000/api/tasks \
  -H "Authorization: Bearer <token>"
```

### Toggle Task Status
```bash
curl -X PATCH http://localhost:8000/api/tasks/1/toggle \
  -H "Authorization: Bearer <token>"
```

### Update Task
```bash
curl -X PUT http://localhost:8000/api/tasks/1 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <token>" \
  -d '{"title": "Updated title"}'
```

### Delete Task
```bash
curl -X DELETE http://localhost:8000/api/tasks/1 \
  -H "Authorization: Bearer <token>"
```

---

## Summary

**Total Endpoints**: 7
- **Auth**: 2 (register, login)
- **Tasks**: 5 (list, create, update, toggle, delete)

**Authentication**: JWT token (Bearer scheme)
**Authorization**: User isolation enforced on all task endpoints
**Validation**: Request/response validated with Pydantic models
**Error Handling**: Consistent JSON error responses with HTTP status codes
