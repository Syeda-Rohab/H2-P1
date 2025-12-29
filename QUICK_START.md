# Quick Start Guide - Network Timeout Fix

## 🔧 Problem
You're experiencing network timeouts when installing packages due to slow internet connection.

## ✅ Solutions (Choose One)

### Solution 1: Use the Automated Script
```bash
# Double-click this file:
install_minimal.bat
```

### Solution 2: Manual Installation with Timeout Fix

**Backend Setup:**
```bash
cd backend

# Install packages with 5-minute timeout
python -m pip install --timeout=300 --retries 5 fastapi uvicorn sqlmodel aiosqlite python-dotenv pydantic-settings python-jose[cryptography] passlib[bcrypt]

# Create database
python init_db.py

# Start server
python -m uvicorn src.main:app --reload --port 8000
```

**Frontend Setup (separate terminal):**
```bash
cd frontend

# Install with legacy peer deps to avoid conflicts
npm install --legacy-peer-deps

# Start server
npm run dev
```

### Solution 3: Use Faster Mirror (China/Asia Region)
```bash
cd backend
python -m pip install --timeout=300 --index-url https://mirrors.aliyun.com/pypi/simple/ fastapi uvicorn sqlmodel aiosqlite python-dotenv pydantic-settings python-jose[cryptography] passlib[bcrypt]
```

### Solution 4: Install One-by-One
```bash
cd backend
python -m pip install --timeout=300 fastapi
python -m pip install --timeout=300 uvicorn
python -m pip install --timeout=300 sqlmodel
python -m pip install --timeout=300 aiosqlite
python -m pip install --timeout=300 python-dotenv
python -m pip install --timeout=300 pydantic-settings
python -m pip install --timeout=300 python-jose[cryptography]
python -m pip install --timeout=300 passlib[bcrypt]
```

## 🎯 After Installation

1. **Backend**: http://localhost:8000/docs
2. **Frontend**: http://localhost:3000

## 🐛 If Issues Persist

1. **Check internet connection**: Make sure you have stable internet
2. **Use mobile hotspot**: Sometimes helps bypass network restrictions
3. **Try different time**: Network might be congested
4. **Disable VPN/Proxy**: Can cause timeout issues
5. **Use PyPI mirror**: Try different mirror closer to your location

## 🌍 Alternative PyPI Mirrors

```bash
# Alibaba (China)
--index-url https://mirrors.aliyun.com/pypi/simple/

# Tsinghua (China)
--index-url https://pypi.tuna.tsinghua.edu.cn/simple

# Official PyPI (default)
--index-url https://pypi.org/simple/
```

## ⚡ Quick Test

After installation, test if it works:

```bash
# Test backend
cd backend
python -c "import fastapi; print('✅ FastAPI installed')"

# Test frontend
cd frontend
npm list next react
```
