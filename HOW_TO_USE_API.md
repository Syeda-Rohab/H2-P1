# 🔑 How to Use PUT & DELETE APIs - Complete Guide

## Problem
PUT and DELETE endpoints require authentication but you're getting errors.

---

## ✅ SOLUTION - Step by Step

### Step 1: Open API Docs
Visit: **http://127.0.0.1:8000/docs**

---

### Step 2: Register & Get Your Token

1. Scroll to **POST /api/auth/register**
2. Click the endpoint to expand it
3. Click **"Try it out"** button
4. In the Request body, enter:
   ```json
   {
     "email": "myemail@test.com",
     "password": "password123"
   }
   ```
5. Click **"Execute"** button
6. Look at the Response - you'll see something like:
   ```json
   {
     "id": 1,
     "email": "myemail@test.com",
     "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsImV4cCI6MTczNTk5OTk5OX0.abc123...",
     "token_type": "bearer"
   }
   ```
7. **COPY the entire `access_token` value** (the long string)

---

### Step 3: Authorize (THIS IS THE KEY STEP!)

1. At the **TOP RIGHT** of the page, find the **"Authorize" button** 🔒
2. Click it - a popup will appear
3. You'll see a field labeled **"Value"**
4. Type exactly this format:
   ```
   Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsImV4cCI6MTczNTk5OTk5OX0.abc123...
   ```
   ⚠️ **IMPORTANT**:
   - Start with the word `Bearer` (capital B)
   - Then a SPACE
   - Then paste your token

5. Click **"Authorize"**
6. Click **"Close"**

You should now see a **LOCK ICON 🔒** next to all protected endpoints!

---

### Step 4: Now Create a Task (to test with)

1. Scroll to **POST /api/tasks/**
2. Click to expand
3. Click **"Try it out"**
4. Enter:
   ```json
   {
     "title": "My first task",
     "description": "This is a test task"
   }
   ```
5. Click **"Execute"**
6. You'll get a response with an `id` - **remember this number** (probably 1)

---

### Step 5: Use PUT to Update Task

1. Scroll to **PUT /api/tasks/{task_id}**
2. Click to expand
3. Click **"Try it out"**
4. In the `task_id` field, enter: **1** (or the ID from step 4)
5. In the Request body, enter what you want to change:
   ```json
   {
     "title": "Updated task title",
     "description": "Updated description"
   }
   ```
6. Click **"Execute"**
7. ✅ It should work now!

---

### Step 6: Use DELETE to Remove Task

1. Scroll to **DELETE /api/tasks/{task_id}**
2. Click to expand
3. Click **"Try it out"**
4. In the `task_id` field, enter: **1**
5. Click **"Execute"**
6. ✅ Task deleted!

---

## 🐛 Common Errors & Fixes

### Error: "401 Unauthorized"
**Problem**: You didn't authorize or token is wrong
**Fix**:
1. Click "Authorize" button
2. Make sure you typed `Bearer ` (with space) before the token
3. Make sure you copied the ENTIRE token

### Error: "404 Not Found"
**Problem**: Task ID doesn't exist
**Fix**:
1. First use GET /api/tasks/ to see all tasks
2. Use an ID that exists from that list

### Error: "422 Validation Error"
**Problem**: Request body is wrong format
**Fix**: Make sure JSON is valid:
```json
{
  "title": "Some title"
}
```

---

## 📋 Complete Example Flow

```
1. Visit: http://127.0.0.1:8000/docs

2. POST /api/auth/register
   Body: {"email": "test@test.com", "password": "pass123"}
   Response: Get access_token

3. Click "Authorize" button at top
   Enter: Bearer YOUR_ACCESS_TOKEN

4. POST /api/tasks/
   Body: {"title": "Task 1", "description": "Test"}
   Response: Get task id (e.g., 1)

5. PUT /api/tasks/1
   Body: {"title": "Updated Task 1"}
   Response: Task updated!

6. DELETE /api/tasks/1
   Response: Task deleted!
```

---

## 🎯 Visual Guide

```
Top of page → [Authorize] button
                    ↓
              Click here first!
                    ↓
         Enter: Bearer YOUR_TOKEN
                    ↓
              [Authorize] [Close]
                    ↓
         Now ALL endpoints work!
```

---

## ✅ Quick Test Right Now

Copy this EXACT sequence:

1. Go to: http://127.0.0.1:8000/docs
2. Find POST /api/auth/register
3. Try it out
4. Body: `{"email": "quicktest@test.com", "password": "test1234"}`
5. Execute
6. Copy the long access_token
7. Click Authorize button (top right)
8. Type: `Bearer ` then paste your token
9. Click Authorize
10. Now try PUT or DELETE - they will work!

---

**The key is Step 7 - you MUST click Authorize and enter "Bearer TOKEN"!**
