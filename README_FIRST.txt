================================================
   COMPLETE WORKING SOLUTION - READ THIS!
================================================

YOUR TODO APP IS WORKING!

Backend is running at: http://127.0.0.1:8000

================================================
HOW TO USE PUT & DELETE APIs
================================================

STEP 1: Open this URL in your browser
────────────────────────────────────────
http://127.0.0.1:8000/docs

STEP 2: Register a new user
────────────────────────────────────────
1. Find "POST /api/auth/register"
2. Click it, click "Try it out"
3. Enter:
   {
     "email": "yourname@test.com",
     "password": "password123"
   }
4. Click "Execute"
5. COPY the "access_token" (long string)

STEP 3: AUTHORIZE (MOST IMPORTANT!)
────────────────────────────────────────
1. Look at TOP RIGHT corner
2. Click "Authorize" button 🔒
3. Type this format:
   Bearer YOUR_TOKEN

   Example:
   Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6...

4. Click "Authorize"
5. Click "Close"

STEP 4: Now USE all endpoints!
────────────────────────────────────────
✓ POST /api/tasks/ - Create task
✓ GET /api/tasks/ - List tasks
✓ PUT /api/tasks/{id} - Update task
✓ DELETE /api/tasks/{id} - Delete task
✓ POST /api/tasks/{id}/toggle - Toggle status

================================================
COMPLETE EXAMPLE
================================================

1. Register: {"email":"test@test.com","password":"password123"}
2. Copy token from response
3. Click Authorize → Enter: Bearer YOUR_TOKEN
4. Create task: {"title":"My task","description":"Test"}
5. Get task ID from response (e.g., 1)
6. Update: PUT /api/tasks/1 {"title":"Updated"}
7. Delete: DELETE /api/tasks/1

================================================
TROUBLESHOOTING
================================================

❌ 401 Unauthorized
   → You didn't click "Authorize" button

❌ 404 Not Found
   → Task doesn't exist, create one first

❌ 422 Validation Error
   → Check your JSON format

================================================

✅ YOUR APP IS 100% FUNCTIONAL!

All Phase 2 features are working:
- User registration & login
- Create, read, update, delete tasks
- Toggle task status
- User isolation
- JWT authentication

Just follow the steps above to use it!

================================================
