# Frontend Installation Fix

Your network is experiencing severe timeouts. Here are **multiple solutions**:

---

## ✅ Solution 1: Use Yarn (Faster & More Reliable)

```bash
# Install Yarn globally (if not installed)
npm install -g yarn

# Navigate to frontend
cd C:\Users\Dell\Desktop\H2 todo-app\frontend

# Install with Yarn (often faster than npm)
yarn install

# Start the dev server
yarn dev
```

---

## ✅ Solution 2: Use Different Registry (Much Faster)

```bash
cd C:\Users\Dell\Desktop\H2 todo-app\frontend

# Use Taobao mirror (China) - very fast
npm install --registry=https://registry.npmmirror.com

# Start the dev server
npm run dev
```

---

## ✅ Solution 3: Install Core Packages Only

```bash
cd C:\Users\Dell\Desktop\H2 todo-app\frontend

# Install minimal packages needed to run
npm install --save next@14 react@18 react-dom@18 --registry=https://registry.npmmirror.com

# Install dev dependencies
npm install --save-dev typescript @types/react @types/node --registry=https://registry.npmmirror.com

# Install remaining
npm install axios tailwindcss postcss autoprefixer --registry=https://registry.npmmirror.com

# Start the dev server
npm run dev
```

---

## ✅ Solution 4: Use Mobile Hotspot

If you have mobile data:
1. Enable mobile hotspot on your phone
2. Connect your PC to the hotspot
3. Run: `npm install --legacy-peer-deps`

Often mobile networks have better connectivity than some ISPs.

---

## ✅ Solution 5: Download Offline

If nothing works, I can provide a pre-configured frontend. But try solutions 1-3 first!

---

## 🚀 After Installation Completes

```bash
npm run dev
```

Then visit: **http://localhost:3000**

---

## 🎯 Quick Test - Use Backend Only

While fixing frontend, you can test everything via backend API:

**Visit**: http://localhost:8000/docs

### Test Flow:
1. **Register**: POST /api/auth/register
   ```json
   {
     "email": "test@example.com",
     "password": "password123"
   }
   ```

2. **Login**: POST /api/auth/login (get token)

3. **Authorize**: Click "Authorize" → Enter `Bearer YOUR_TOKEN`

4. **Create Task**: POST /api/tasks/
   ```json
   {
     "title": "My first task",
     "description": "Test description"
   }
   ```

5. **List Tasks**: GET /api/tasks/

6. **Toggle Status**: POST /api/tasks/1/toggle

**All your backend is working perfectly!** ✅

---

## 📞 Which Solution to Try?

**Fastest**: Solution 2 (Different Registry)
**Most Reliable**: Solution 1 (Yarn)
**Most Control**: Solution 3 (Manual Install)
**Works Offline**: Solution 4 (Mobile Hotspot)

Try them in order until one works!
