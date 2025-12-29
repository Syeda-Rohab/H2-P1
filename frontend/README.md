# Todo Frontend - Phase II

Next.js 14 frontend for multi-user todo application.

## Features

- User registration and login
- JWT authentication with token storage
- Create, view, update, delete tasks
- Toggle task completion status
- Real-time UI updates
- Responsive design with Tailwind CSS
- Protected routes with middleware

## Tech Stack

- Next.js 14 (App Router)
- React 18
- TypeScript
- Tailwind CSS
- Axios (API client)

## Setup

### 1. Install Dependencies

```bash
cd frontend
npm install
```

### 2. Configure Environment

Copy `.env.local.example` to `.env.local`:

```bash
cp .env.local.example .env.local
```

Edit `.env.local` to point to your backend URL (default: http://localhost:8000).

### 3. Start Development Server

```bash
npm run dev
```

Frontend will run at http://localhost:3000

## Pages

- `/` - Home (redirects to login or dashboard)
- `/register` - User registration
- `/login` - User login
- `/dashboard` - Main todo management interface (protected)

## Project Structure

```
frontend/
├── app/              # Next.js app router pages
│   ├── dashboard/    # Dashboard page
│   ├── login/        # Login page
│   ├── register/     # Register page
│   └── layout.tsx    # Root layout
├── lib/              # Utilities
│   ├── api.ts        # Axios client
│   ├── auth.ts       # Auth helpers
│   └── validation.ts # Form validation
├── components/       # Reusable components
└── middleware.ts     # Route protection
```

## Development

```bash
# Run dev server
npm run dev

# Build for production
npm run build

# Start production server
npm start

# Lint
npm run lint
```

## Authentication Flow

1. User registers at `/register`
2. Backend returns JWT token
3. Token stored in localStorage
4. Axios interceptor adds token to all requests
5. Protected routes check for token
6. Invalid/expired tokens redirect to login

## Task Management

All CRUD operations are handled through the dashboard:

- **Create**: Fill form at top of dashboard
- **Read**: All tasks displayed in list
- **Update**: Click "Edit" button on task
- **Delete**: Click "Delete" button (with confirmation)
- **Toggle**: Click "Mark Complete/Incomplete" button
