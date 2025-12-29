# Manual Start Instructions

## ✅ Backend is Already Running!

Your backend server is **LIVE** at:
- **API**: http://localhost:8000
- **Docs**: http://localhost:8000/docs

You can test it right now in the API docs!

---

## 🚀 Start Frontend Manually

Due to network timeouts, please start the frontend manually:

### Option 1: Quick Command (Copy-Paste)

```bash
cd C:\Users\Dell\Desktop\H2 todo-app\frontend && npm install --legacy-peer-deps && npm run dev
```

### Option 2: Step-by-Step

**Open a NEW terminal/command prompt** and run:

```bash
# Navigate to frontend
cd C:\Users\Dell\Desktop\H2 todo-app\frontend

# Install dependencies (may take 2-5 minutes)
npm install --legacy-peer-deps

# Start development server
npm run dev
```

Then visit: **http://localhost:3000**

---

## 🎯 If npm install keeps timing out:

Try these solutions:

### Solution 1: Use npm cache
```bash
npm cache clean --force
npm install --legacy-peer-deps --prefer-offline
```

### Solution 2: Increase timeout
```bash
npm config set fetch-timeout 600000
npm install --legacy-peer-deps
```

### Solution 3: Use different registry (faster in some regions)
```bash
npm install --legacy-peer-deps --registry=https://registry.npmmirror.com
```

### Solution 4: Install core packages only
```bash
npm install next@14 react@18 react-dom@18 typescript axios tailwindcss
npm run dev
```

---

## 📱 Test Your App

### Test Backend (Works Now!)
1. Visit: http://localhost:8000/docs
2. Try POST `/api/auth/register`:
   ```json
   {
     "email": "test@example.com",
     "password": "password123"
   }
   ```
3. Copy the `access_token` from response
4. Click "Authorize" button, enter: `Bearer YOUR_TOKEN`
5. Try other endpoints!

### Test Frontend (After Installation)
1. Visit: http://localhost:3000
2. Click "Register"
3. Create account with email + password
4. You'll be redirected to dashboard
5. Create, edit, delete tasks!

---

## 🐛 Troubleshooting

### Backend not working?
```bash
cd C:\Users\Dell\Desktop\H2 todo-app\backend
python -m uvicorn src.main:app --reload --port 8000
```

### Need to stop servers?
- Press `Ctrl+C` in the terminal windows
- Or close the terminal windows

### Database issues?
```bash
cd C:\Users\Dell\Desktop\H2 todo-app\backend
python init_db.py
```

---

## ✨ What's Implemented

✅ User registration and login
✅ JWT authentication
✅ Create tasks with title & description
✅ View all your tasks
✅ Edit task details
✅ Toggle task status (Complete/Incomplete)
✅ Delete tasks
✅ Responsive UI with Tailwind CSS
✅ Real-time validation
✅ Protected routes

---

**Your Phase 2 Todo App is READY!** 🎉

Backend: ✅ **RUNNING**
Frontend: ⏳ Follow instructions above
