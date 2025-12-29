/**
 * API Request/Response Type Definitions
 */

export interface APIError {
  detail: string | Record<string, any>[];
}

export interface ValidationError {
  loc: (string | number)[];
  msg: string;
  type: string;
}

export interface APIResponse<T> {
  data?: T;
  error?: APIError;
}

// Auth API responses
export interface LoginResponse {
  id: number;
  email: string;
  access_token: string;
  token_type: string;
}

export interface RegisterResponse {
  id: number;
  email: string;
  created_at: string;
  access_token: string;
  token_type: string;
}

// Generic paginated response
export interface PaginatedResponse<T> {
  items: T[];
  total: number;
  page?: number;
  per_page?: number;
}
