/**
 * User Type Definition
 * Matches backend User model from src/models/user.py
 */

export interface User {
  id: number;
  email: string;
  created_at: string; // ISO 8601 datetime string
  updated_at: string; // ISO 8601 datetime string
  // Note: hashed_password is never exposed to frontend
}

export interface UserCreate {
  email: string;
  password: string;
}

export interface UserLogin {
  email: string;
  password: string;
}

export interface UserResponse {
  id: number;
  email: string;
  created_at: string;
  access_token: string;
  token_type: string; // "bearer"
}
