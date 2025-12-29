# Testing Guide - Phase II Todo App

## Prerequisites

Before testing, ensure:
1. PostgreSQL is running (Docker or Neon)
2. Backend server is running at http://localhost:8000
3. Frontend dev server is running at http://localhost:3000

## Quick Setup for Testing

```bash
# Terminal 1: Start PostgreSQL
cd docker
docker-compose up -d postgres

# Terminal 2: Start Backend
cd backend
uv sync
uv run alembic upgrade head
uv run uvicorn src.main:app --reload --port 8000

# Terminal 3: Start Frontend
cd frontend
npm install
npm run dev
```

## Manual Testing Checklist

### 1. User Registration (US1)

**Test Case**: New user can register

1. Navigate to http://localhost:3000
2. Should redirect to `/login`
3. Click "Don't have an account? Register"
4. Fill in:
   - Email: `test@example.com`
   - Password: `password123` (min 8 chars)
5. Click "Register"
6. Should redirect to `/dashboard`
7. Should see empty task list

**Expected Results**:
- ✅ Registration successful
- ✅ JWT token stored in localStorage
- ✅ Redirected to dashboard
- ✅ Navigation bar shows "Logout" button

**Error Cases to Test**:
- Email already exists → Shows error "Email already registered"
- Invalid email format → Shows error "Invalid email format"
- Password < 8 chars → Shows error "Password must be at least 8 characters"
- Empty fields → Browser validation error

---

### 2. User Login (US1)

**Test Case**: Existing user can login

1. Navigate to http://localhost:3000/login
2. Fill in registered credentials:
   - Email: `test@example.com`
   - Password: `password123`
3. Click "Sign in"
4. Should redirect to `/dashboard`

**Expected Results**:
- ✅ Login successful
- ✅ JWT token stored
- ✅ Dashboard loads with tasks

**Error Cases to Test**:
- Wrong password → "Incorrect email or password"
- Non-existent email → "Incorrect email or password"
- Invalid email format → Validation error

---

### 3. Create Task (US2)

**Test Case**: User can create new task

1. On dashboard, fill "Create New Task" form:
   - Title: "Buy groceries"
   - Description: "Milk, eggs, bread"
2. Click "Add Task"
3. Task should appear in list below

**Expected Results**:
- ✅ Task created instantly
- ✅ Form clears after submission
- ✅ Task shows in list with status "Incomplete"
- ✅ Created timestamp displayed

**Edge Cases to Test**:
- Empty title → Error "Title cannot be empty"
- Title > 200 chars → Error "Title exceeds 200 characters"
- Description > 1000 chars → Error "Description exceeds 1000 characters"
- No description (optional) → Task created successfully

---

### 4. View Tasks (US3)

**Test Case**: User sees only their tasks

1. Create 3-5 tasks with different titles
2. All tasks should display in list
3. Each task shows:
   - Title
   - Description (if provided)
   - Status badge (Complete/Incomplete)
   - Created timestamp
   - Action buttons (Toggle, Edit, Delete)

**Expected Results**:
- ✅ All user's tasks visible
- ✅ Sorted by creation time (newest first)
- ✅ Task count shown: "Your Tasks (5)"
- ✅ If no tasks: "No tasks yet. Create your first task above!"

---

### 5. Toggle Task Status (US4)

**Test Case**: User can mark task complete/incomplete

1. Find task with status "Incomplete"
2. Click "Mark Complete" button
3. Status should change to "Complete"
4. Title should have strikethrough
5. Badge color should change (yellow → green)
6. Click "Mark Incomplete"
7. Status should revert

**Expected Results**:
- ✅ Status toggles instantly
- ✅ Visual feedback (strikethrough, badge color)
- ✅ Button text changes accordingly
- ✅ Change persists on page refresh

---

### 6. Update Task (US5)

**Test Case**: User can edit task details

1. Find any task
2. Click "Edit" button
3. Form appears with current values
4. Modify title: "Updated task title"
5. Modify description: "Updated description"
6. Click "Save"
7. Task updates in list
8. Click "Cancel" on another task → No changes saved

**Expected Results**:
- ✅ Edit mode shows current values
- ✅ Save updates task
- ✅ Cancel discards changes
- ✅ Same validation as create (title length, etc.)

---

### 7. Delete Task (US6)

**Test Case**: User can delete task

1. Find any task
2. Click "Delete" button
3. Confirmation dialog appears: "Are you sure?"
4. Click "OK"
5. Task removed from list
6. Task count decrements

**Test Cancel**:
1. Click "Delete"
2. Click "Cancel" in dialog
3. Task remains in list

**Expected Results**:
- ✅ Confirmation required
- ✅ Task deleted on confirm
- ✅ No deletion on cancel
- ✅ Change persists (cannot be undone)

---

### 8. User Logout

**Test Case**: User can logout

1. Click "Logout" button in navbar
2. Should redirect to `/login`
3. JWT token removed from localStorage
4. Trying to access `/dashboard` directly → Redirects to `/login`

**Expected Results**:
- ✅ Logged out successfully
- ✅ Token cleared
- ✅ Cannot access protected routes

---

### 9. Authentication Flow

**Test Case**: Protected routes work correctly

1. Open new incognito window
2. Navigate to http://localhost:3000/dashboard
3. Should redirect to `/login` (middleware protection)
4. Login successfully
5. Navigate to http://localhost:3000/login
6. Should redirect to `/dashboard` (already authenticated)

**Expected Results**:
- ✅ Unauthenticated users → `/login`
- ✅ Authenticated users → `/dashboard`
- ✅ Root `/` → Auto-redirects based on auth status

---

### 10. Multi-User Isolation

**Test Case**: Users see only their own tasks

1. Register user1: `user1@test.com`
2. Create 3 tasks as user1
3. Logout
4. Register user2: `user2@test.com`
5. Dashboard should be empty (no tasks)
6. Create 2 tasks as user2
7. Logout and login as user1
8. Should see only user1's 3 tasks

**Expected Results**:
- ✅ Complete data isolation
- ✅ No access to other users' tasks
- ✅ Task counts are user-specific

---

## API Testing (Backend)

### Using FastAPI Docs

1. Navigate to http://localhost:8000/docs
2. Test endpoints:
   - POST `/api/auth/register` - Create account
   - POST `/api/auth/login` - Get JWT token
   - Click "Authorize" and paste token: `Bearer <your_token>`
   - GET `/api/tasks/` - List tasks
   - POST `/api/tasks/` - Create task
   - PUT `/api/tasks/{id}` - Update task
   - DELETE `/api/tasks/{id}` - Delete task
   - POST `/api/tasks/{id}/toggle` - Toggle status

### Using curl

```bash
# Register
curl -X POST http://localhost:8000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'

# Login (save token from response)
curl -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'

# Create task (replace TOKEN)
curl -X POST http://localhost:8000/api/tasks/ \
  -H "Authorization: Bearer TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"title":"Test task","description":"Test description"}'

# List tasks
curl http://localhost:8000/api/tasks/ \
  -H "Authorization: Bearer TOKEN"
```

---

## Browser Testing

Test on multiple browsers:
- ✅ Chrome/Edge (Chromium)
- ✅ Firefox
- ✅ Safari (macOS)

Test responsive design:
- ✅ Mobile (320px - 640px)
- ✅ Tablet (768px - 1024px)
- ✅ Desktop (1280px+)

---

## Performance Testing

1. Create 50+ tasks
2. Check page load time
3. Check API response times in Network tab
4. Verify smooth scrolling
5. Test rapid task creation/deletion

---

## Error Handling

Test error scenarios:
1. Stop backend server → Frontend shows connection error
2. Invalid JWT token → Redirects to login
3. Expired JWT token → Redirects to login
4. Network timeout → Shows error message
5. Database connection lost → Backend returns 500 error

---

## Test Results Template

```
[ ] User Registration works
[ ] User Login works
[ ] Create Task works
[ ] View Tasks works
[ ] Toggle Status works
[ ] Update Task works
[ ] Delete Task works
[ ] Logout works
[ ] Route Protection works
[ ] Multi-user Isolation works
[ ] API endpoints work
[ ] Error handling works
[ ] Responsive design works
```

---

## Known Issues

Document any bugs found during testing:

1. Issue: [Description]
   - Steps to reproduce: [...]
   - Expected: [...]
   - Actual: [...]
   - Priority: High/Medium/Low

---

## Next Steps

After manual testing passes:
1. Write automated tests (pytest for backend, Jest for frontend)
2. Set up CI/CD pipeline
3. Deploy to staging environment
4. Perform user acceptance testing (UAT)
5. Deploy to production
