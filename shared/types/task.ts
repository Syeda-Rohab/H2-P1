/**
 * Task Type Definition
 * Matches backend Task model from src/models/task.py
 */

export type TaskStatus = "Complete" | "Incomplete";

export interface Task {
  id: number;
  user_id: number;
  title: string; // 1-200 characters
  description: string | null; // 0-1000 characters, optional
  status: TaskStatus;
  created_at: string; // ISO 8601 datetime string
  updated_at: string; // ISO 8601 datetime string
}

export interface TaskCreate {
  title: string;
  description?: string;
}

export interface TaskUpdate {
  title?: string;
  description?: string;
}

export interface TaskListResponse {
  tasks: Task[];
  total: number;
}
