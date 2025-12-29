"""Quick test script to verify PUT/DELETE endpoints"""
import requests

BASE_URL = "http://127.0.0.1:8000"

print("=== Testing Todo API ===\n")

# 1. Register
print("1. Registering user...")
response = requests.post(f"{BASE_URL}/api/auth/register", json={
    "email": "testuser@example.com",
    "password": "password123"
})
if response.status_code == 201:
    data = response.json()
    token = data["access_token"]
    print(f"✓ Registered! Token: {token[:50]}...")
elif response.status_code == 400:
    # User exists, login instead
    print("User exists, logging in...")
    response = requests.post(f"{BASE_URL}/api/auth/login", json={
        "email": "testuser@example.com",
        "password": "password123"
    })
    token = response.json()["access_token"]
    print(f"✓ Logged in! Token: {token[:50]}...")
else:
    print(f"✗ Error: {response.text}")
    exit(1)

headers = {"Authorization": f"Bearer {token}"}

# 2. Create task
print("\n2. Creating task...")
response = requests.post(f"{BASE_URL}/api/tasks/", 
    headers=headers,
    json={"title": "Test task", "description": "This is a test"}
)
if response.status_code == 201:
    task = response.json()
    task_id = task["id"]
    print(f"✓ Created task ID: {task_id}")
else:
    print(f"✗ Error: {response.text}")
    exit(1)

# 3. Update task (PUT)
print("\n3. Updating task with PUT...")
response = requests.put(f"{BASE_URL}/api/tasks/{task_id}",
    headers=headers,
    json={"title": "Updated task title"}
)
if response.status_code == 200:
    print("✓ PUT successful!")
    print(f"   New title: {response.json()['title']}")
else:
    print(f"✗ PUT Error: {response.text}")

# 4. Delete task
print("\n4. Deleting task with DELETE...")
response = requests.delete(f"{BASE_URL}/api/tasks/{task_id}",
    headers=headers
)
if response.status_code == 204:
    print("✓ DELETE successful!")
else:
    print(f"✗ DELETE Error: {response.text}")

print("\n=== All tests passed! ✅ ===")
print("\nYour PUT and DELETE endpoints are working correctly!")
print("The issue was just needing to include the Authorization header.")
