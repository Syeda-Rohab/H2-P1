# Tasks: Full-Stack Web Todo Application (Phase II)

**Input**: Design documents from `/specs/001-web-todo-app/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/api-endpoints.md, quickstart.md

**Tests**: Tests are NOT explicitly requested in the specification, so test tasks are omitted.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

This is a web application with monorepo structure:
- **Backend**: `backend/src/`, `backend/tests/`
- **Frontend**: `frontend/src/`, `frontend/tests/`
- **Shared**: `shared/types/`
- **Docker**: `docker/`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and monorepo structure

- [ ] T001 Create monorepo root directory structure (backend/, frontend/, shared/, docker/)
- [ ] T002 [P] Initialize backend project with UV and create pyproject.toml
- [ ] T003 [P] Initialize frontend project with Next.js 14 and create package.json
- [ ] T004 [P] Create root .gitignore with node_modules/, .env, __pycache__, .next/, dist/
- [ ] T005 [P] Create root README.md with monorepo setup instructions and quickstart
- [ ] T006 Create backend/.env.example with DATABASE_URL, JWT_SECRET_KEY, ALLOWED_ORIGINS
- [ ] T007 Create frontend/.env.local.example with NEXT_PUBLIC_API_URL
- [ ] T008 Create docker/docker-compose.yml for local PostgreSQL development environment
- [ ] T009 Create shared/types/index.ts with barrel export structure

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

### Backend Foundation

- [ ] T010 Create backend/src/core/config.py for environment variable management using Pydantic BaseSettings
- [ ] T011 Create backend/src/core/security.py with password hashing (bcrypt) and JWT utilities (python-jose)
- [ ] T012 Create backend/src/db/base.py with SQLModel base class and common timestamp fields
- [ ] T013 Create backend/src/db/session.py with async database engine and session factory
- [ ] T014 Initialize Alembic in backend/alembic/ with env.py configured for SQLModel
- [ ] T015 Create backend/src/main.py with FastAPI app initialization, CORS middleware, and health endpoint
- [ ] T016 Create backend/src/api/deps.py with get_db dependency injection function
- [ ] T017 [P] Install backend dependencies via UV: fastapi, sqlmodel, alembic, python-jose, passlib, asyncpg, uvicorn

### Frontend Foundation

- [ ] T018 [P] Create frontend/src/lib/api.ts with Axios instance and JWT token interceptor
- [ ] T019 [P] Create frontend/src/lib/auth.ts with token storage helpers (localStorage)
- [ ] T020 [P] Create frontend/src/lib/validation.ts with title/description validation functions
- [ ] T021 [P] Configure frontend/tailwind.config.ts with custom colors and responsive breakpoints
- [ ] T022 [P] Create frontend/src/app/layout.tsx with root layout and TailwindCSS imports
- [ ] T023 [P] Create frontend/src/middleware.ts for Next.js route protection (auth check)
- [ ] T024 [P] Install frontend dependencies: next, react, tailwindcss, axios, typescript

### Shared Types Foundation

- [ ] T025 [P] Create shared/types/user.ts with User interface matching backend model
- [ ] T026 [P] Create shared/types/task.ts with Task interface matching backend model
- [ ] T027 [P] Create shared/types/api.ts with API request/response type definitions

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - User Registration and Login (Priority: P1) 🎯 MVP

**Goal**: Enable new users to register accounts and existing users to log in with JWT authentication

**Independent Test**: Create account, logout, login with same credentials, verify session persistence

### Backend - Models for US1

- [ ] T028 [US1] Create backend/src/models/user.py with User SQLModel (id, email, hashed_password, created_at, updated_at)
- [ ] T029 [US1] Add unique constraint and index on User.email in user.py model

### Backend - Services for US1

- [ ] T030 [US1] Create backend/src/services/auth.py with create_access_token() and verify_token() functions
- [ ] T031 [US1] Create backend/src/services/user_service.py with register_user() function (email validation, password hashing)
- [ ] T032 [US1] Add authenticate_user() function to backend/src/services/user_service.py (password verification)

### Backend - API Endpoints for US1

- [ ] T033 [US1] Create backend/src/api/auth.py with POST /api/auth/register endpoint (Pydantic schemas)
- [ ] T034 [US1] Add POST /api/auth/login endpoint to backend/src/api/auth.py with JWT token response
- [ ] T035 [US1] Add get_current_user() dependency to backend/src/api/deps.py (JWT validation from header)
- [ ] T036 [US1] Register auth router in backend/src/main.py

### Database Migration for US1

- [ ] T037 [US1] Create Alembic migration for users table in backend/alembic/versions/
- [ ] T038 [US1] Verify migration creates users table with all constraints and indexes

### Frontend - Pages for US1

- [ ] T039 [P] [US1] Create frontend/src/app/register/page.tsx with registration form (email, password fields)
- [ ] T040 [P] [US1] Create frontend/src/app/login/page.tsx with login form and error handling
- [ ] T041 [US1] Create frontend/src/app/page.tsx as landing page with redirect logic (if authenticated → dashboard, else → login)

### Frontend - Components for US1

- [ ] T042 [P] [US1] Create frontend/src/components/AuthForm.tsx with reusable form component for login/register
- [ ] T043 [US1] Add client-side validation to AuthForm.tsx (email format, password min length)

### Frontend - Auth Integration for US1

- [ ] T044 [US1] Implement register API call in frontend/src/lib/auth.ts with token storage
- [ ] T045 [US1] Implement login API call in frontend/src/lib/auth.ts with automatic redirect
- [ ] T046 [US1] Implement logout function in frontend/src/lib/auth.ts (clear token, redirect to login)

**Checkpoint**: User Story 1 complete - users can register, login, and logout with session persistence

---

## Phase 4: User Story 2 - Create New Tasks (Priority: P2)

**Goal**: Authenticated users can create new tasks with title and optional description

**Independent Test**: Login, create task with title+description, logout, login again, verify task persists

### Backend - Models for US2

- [ ] T047 [US2] Create backend/src/models/task.py with Task SQLModel (id, user_id FK, title, description, status, timestamps)
- [ ] T048 [US2] Add foreign key constraint tasks.user_id → users.id with CASCADE DELETE in task.py
- [ ] T049 [US2] Add relationship fields in both User and Task models (user.tasks, task.user)

### Backend - Services for US2

- [ ] T050 [US2] Create backend/src/services/task_service.py with create_task() function (user_id from JWT, validation)
- [ ] T051 [US2] Add input validation in create_task() (title 1-200 chars, description 0-1000 chars)

### Backend - API Endpoints for US2

- [ ] T052 [US2] Create backend/src/api/tasks.py with POST /api/tasks endpoint (requires authentication)
- [ ] T053 [US2] Add Pydantic schemas (TaskCreate, TaskResponse) to backend/src/api/tasks.py
- [ ] T054 [US2] Register tasks router in backend/src/main.py

### Database Migration for US2

- [ ] T055 [US2] Create Alembic migration for tasks table in backend/alembic/versions/
- [ ] T056 [US2] Verify migration creates foreign key constraint and indexes on user_id

### Frontend - Components for US2

- [ ] T057 [P] [US2] Create frontend/src/components/TaskForm.tsx with controlled inputs for title and description
- [ ] T058 [US2] Add client-side validation to TaskForm.tsx (title required, max lengths)
- [ ] T059 [US2] Add submit handler to TaskForm.tsx calling POST /api/tasks with JWT token

### Frontend - Dashboard Integration for US2

- [ ] T060 [US2] Create frontend/src/app/dashboard/page.tsx with protected route (requires auth)
- [ ] T061 [US2] Add TaskForm component to dashboard page with create task functionality

**Checkpoint**: User Story 2 complete - users can create tasks that persist to database

---

## Phase 5: User Story 3 - View All Personal Tasks (Priority: P3)

**Goal**: Authenticated users can view all their tasks sorted by creation time with status indicators

**Independent Test**: Create multiple tasks as User A and User B, verify each user sees only their own tasks

### Backend - Services for US3

- [ ] T062 [US3] Add get_user_tasks() function to backend/src/services/task_service.py (filter by user_id, order by created_at DESC)
- [ ] T063 [US3] Verify user isolation in get_user_tasks() (query WHERE user_id = current_user.id)

### Backend - API Endpoints for US3

- [ ] T064 [US3] Add GET /api/tasks endpoint to backend/src/api/tasks.py (returns user's tasks only)
- [ ] T065 [US3] Add pagination support (optional) to GET /api/tasks for handling 1000+ tasks

### Frontend - Components for US3

- [ ] T066 [P] [US3] Create frontend/src/components/TaskList.tsx to display array of tasks
- [ ] T067 [P] [US3] Create frontend/src/components/TaskItem.tsx for single task display with status badge
- [ ] T068 [US3] Add empty state UI to TaskList.tsx when user has no tasks

### Frontend - Dashboard Integration for US3

- [ ] T069 [US3] Fetch tasks on dashboard mount using GET /api/tasks in frontend/src/app/dashboard/page.tsx
- [ ] T070 [US3] Display TaskList component in dashboard with fetched tasks
- [ ] T071 [US3] Add loading state and error handling for task fetch

**Checkpoint**: User Story 3 complete - users can view all their tasks with proper isolation

---

## Phase 6: User Story 4 - Toggle Task Completion Status (Priority: P4)

**Goal**: Authenticated users can mark tasks complete/incomplete with immediate visual feedback

**Independent Test**: Create task, toggle to complete, refresh page, verify status persists

### Backend - Services for US4

- [ ] T072 [US4] Add toggle_task_status() function to backend/src/services/task_service.py
- [ ] T073 [US4] Verify user owns task before toggling in toggle_task_status() (403 if not)
- [ ] T074 [US4] Update task.updated_at timestamp when status changes

### Backend - API Endpoints for US4

- [ ] T075 [US4] Add PATCH /api/tasks/{task_id}/toggle endpoint to backend/src/api/tasks.py
- [ ] T076 [US4] Return updated task with new status in toggle endpoint response

### Frontend - Components for US4

- [ ] T077 [US4] Add onClick handler to TaskItem.tsx for status toggle
- [ ] T078 [US4] Call PATCH /api/tasks/{id}/toggle in TaskItem.tsx and update local state
- [ ] T079 [US4] Add visual feedback to TaskItem.tsx (status color change, animation on toggle)

### Frontend - Dashboard Integration for US4

- [ ] T080 [US4] Update task list state in dashboard when individual task status changes
- [ ] T081 [US4] Add optimistic UI update (instant feedback before API response)

**Checkpoint**: User Story 4 complete - users can toggle task status with immediate feedback

---

## Phase 7: User Story 5 - Update Task Details (Priority: P5)

**Goal**: Authenticated users can edit task title and description with partial updates

**Independent Test**: Create task, update title only, verify description unchanged

### Backend - Services for US5

- [ ] T082 [US5] Add update_task() function to backend/src/services/task_service.py with partial update support
- [ ] T083 [US5] Verify user owns task before updating in update_task() (403 if not)
- [ ] T084 [US5] Validate new title/description in update_task() (same rules as create)
- [ ] T085 [US5] Update task.updated_at timestamp on update

### Backend - API Endpoints for US5

- [ ] T086 [US5] Add PUT /api/tasks/{task_id} endpoint to backend/src/api/tasks.py
- [ ] T087 [US5] Create TaskUpdate Pydantic schema with optional title and description fields
- [ ] T088 [US5] Return 404 if task not found, 403 if not authorized in update endpoint

### Frontend - Components for US5

- [ ] T089 [US5] Add edit mode state to TaskItem.tsx (toggle between view/edit)
- [ ] T090 [US5] Add inline editing form to TaskItem.tsx with pre-filled current values
- [ ] T091 [US5] Add save/cancel buttons to TaskItem.tsx edit mode
- [ ] T092 [US5] Call PUT /api/tasks/{id} on save with updated values
- [ ] T093 [US5] Handle validation errors in TaskItem.tsx (empty title, exceeded length)

### Frontend - Dashboard Integration for US5

- [ ] T094 [US5] Update task list state in dashboard when task is updated
- [ ] T095 [US5] Cancel edit mode and revert to original values on cancel button

**Checkpoint**: User Story 5 complete - users can edit tasks with validation and error handling

---

## Phase 8: User Story 6 - Delete Tasks Permanently (Priority: P6)

**Goal**: Authenticated users can permanently delete tasks with confirmation

**Independent Test**: Create task, delete it, refresh page, verify task no longer appears

### Backend - Services for US6

- [ ] T096 [US6] Add delete_task() function to backend/src/services/task_service.py
- [ ] T097 [US6] Verify user owns task before deleting in delete_task() (403 if not)
- [ ] T098 [US6] Return deleted task details in delete_task() for confirmation

### Backend - API Endpoints for US6

- [ ] T099 [US6] Add DELETE /api/tasks/{task_id} endpoint to backend/src/api/tasks.py
- [ ] T100 [US6] Return 204 No Content on successful deletion

### Frontend - Components for US6

- [ ] T101 [US6] Add delete button to TaskItem.tsx
- [ ] T102 [US6] Call DELETE /api/tasks/{id} on delete button click
- [ ] T103 [US6] Add confirmation feedback on successful deletion (toast/message)

### Frontend - Dashboard Integration for US6

- [ ] T104 [US6] Remove deleted task from dashboard task list state
- [ ] T105 [US6] Handle deletion errors (task not found, not authorized)

**Checkpoint**: User Story 6 complete - users can permanently delete tasks

---

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: Final touches, error handling, and production readiness

### Backend Polish

- [ ] T106 [P] Add comprehensive error handling middleware to backend/src/main.py
- [ ] T107 [P] Add request logging middleware to backend/src/main.py
- [ ] T108 [P] Create backend/README.md with setup instructions, API documentation link
- [ ] T109 [P] Verify all API endpoints return consistent error format (detail field)
- [ ] T110 [P] Add CORS configuration validation in backend/src/main.py (ALLOWED_ORIGINS from env)

### Frontend Polish

- [ ] T111 [P] Add global error boundary in frontend/src/app/layout.tsx
- [ ] T112 [P] Add loading spinners for all async operations (login, register, task operations)
- [ ] T113 [P] Create frontend/README.md with setup instructions and available scripts
- [ ] T114 [P] Add responsive design testing (mobile 320px to desktop 1920px)
- [ ] T115 [P] Add proper TypeScript types for all components and API calls

### Documentation & Deployment Preparation

- [ ] T116 [P] Update root README.md with complete setup guide for both backend and frontend
- [ ] T117 [P] Verify backend/.env.example and frontend/.env.local.example have all required variables
- [ ] T118 [P] Create backend/CLAUDE.md with backend-specific development context
- [ ] T119 [P] Create frontend/CLAUDE.md with frontend-specific development context
- [ ] T120 [P] Test complete user flow: register → login → create task → view → toggle → update → delete → logout

### Optional Enhancements (Nice-to-Have)

- [ ] T121 [P] Add API rate limiting to prevent abuse
- [ ] T122 [P] Add frontend form debouncing for better UX
- [ ] T123 [P] Add backend request ID tracking for debugging
- [ ] T124 [P] Add frontend toast notifications for success/error feedback
- [ ] T125 [P] Add task count badge to dashboard header

**Final Checkpoint**: Phase II complete - production-ready full-stack todo application

---

## Dependencies

### Story Dependency Graph

```
US1 (Auth) → [BLOCKS ALL OTHER STORIES]
    ├─→ US2 (Create Tasks)
    ├─→ US3 (View Tasks)
    ├─→ US4 (Toggle Status)
    ├─→ US5 (Update Tasks)
    └─→ US6 (Delete Tasks)

US2, US3, US4, US5, US6 can be implemented in parallel after US1 is complete
```

### Phase Dependencies

- **Phase 1 (Setup)** → MUST complete before Phase 2
- **Phase 2 (Foundational)** → MUST complete before any user story phases
- **Phase 3 (US1)** → MUST complete before Phases 4-8 (auth is prerequisite)
- **Phases 4-8 (US2-US6)** → Can be implemented in parallel after Phase 3
- **Phase 9 (Polish)** → Should be done last after all user stories

### Task Dependencies Within Phases

- Model tasks can run in parallel with other model tasks
- Service tasks depend on their model tasks
- API endpoint tasks depend on their service tasks
- Frontend component tasks can run in parallel
- Integration tasks depend on both frontend and backend components

---

## Parallel Execution Examples

### Phase 2 Foundational (14 tasks can run in parallel):

**Backend Group** (5 parallel):
- T010 (config.py), T011 (security.py), T012 (base.py), T013 (session.py), T017 (dependencies)

**Frontend Group** (6 parallel):
- T018 (api.ts), T019 (auth.ts), T020 (validation.ts), T021 (tailwind), T022 (layout), T024 (dependencies)

**Shared Group** (3 parallel):
- T025 (user types), T026 (task types), T027 (api types)

**Sequential**: T014-T016 (Alembic setup → main.py → deps.py)

### Phase 3 US1 (18 tasks):

**Parallel opportunities**:
- T028-T029 (models) while T030-T032 (services) are being designed
- T039-T040 (register/login pages) in parallel
- T042-T043 (AuthForm component) in parallel
- T044-T046 (auth integration functions) in parallel

**Total parallel savings**: ~40% reduction in sequential time

### Phases 4-8 (US2-US6 after US1 complete):

All 5 user stories can be implemented in parallel by different developers:
- Developer A: US2 (Create Tasks) - 15 tasks
- Developer B: US3 (View Tasks) - 11 tasks
- Developer C: US4 (Toggle Status) - 10 tasks
- Developer D: US5 (Update Tasks) - 14 tasks
- Developer E: US6 (Delete Tasks) - 10 tasks

**Total parallel savings**: ~80% reduction in sequential time with 5 developers

---

## Implementation Strategy

### MVP Scope (Minimum Viable Product)

**Phase 1 + Phase 2 + Phase 3 + Phase 4 + Phase 5** = Basic working todo app
- Users can register and login (US1)
- Users can create tasks (US2)
- Users can view their tasks (US3)
- **Estimated**: 75 tasks (T001-T071, excluding Polish)

### Full Feature Set

**Add Phase 6 + Phase 7 + Phase 8** = Complete 5-feature todo app
- Users can toggle task status (US4)
- Users can edit tasks (US5)
- Users can delete tasks (US6)
- **Estimated**: 105 tasks (T001-T105)

### Production Ready

**Add Phase 9** = Polished production application
- Error handling, logging, documentation
- **Total**: 125 tasks (T001-T125)

---

## Task Summary

**Total Tasks**: 125 (120 required + 5 optional enhancements)

**Tasks Per Phase**:
- Phase 1 (Setup): 9 tasks
- Phase 2 (Foundational): 18 tasks
- Phase 3 (US1 - Auth): 19 tasks
- Phase 4 (US2 - Create): 15 tasks
- Phase 5 (US3 - View): 11 tasks
- Phase 6 (US4 - Toggle): 10 tasks
- Phase 7 (US5 - Update): 14 tasks
- Phase 8 (US6 - Delete): 9 tasks
- Phase 9 (Polish): 15 tasks + 5 optional

**Tasks Per User Story**:
- US1 (Registration/Login): 19 tasks
- US2 (Create Tasks): 15 tasks
- US3 (View Tasks): 11 tasks
- US4 (Toggle Status): 10 tasks
- US5 (Update Tasks): 14 tasks
- US6 (Delete Tasks): 9 tasks
- Infrastructure (Phase 1+2): 27 tasks
- Polish (Phase 9): 20 tasks

**Parallel Opportunities**: 65+ tasks can run in parallel (52% of total)

**Format Validation**: ✅ All 125 tasks follow checklist format (checkbox, ID, [P] if parallel, [Story] label for US phases, description with file paths)

**Ready for**: `/sp.implement` to begin implementation
