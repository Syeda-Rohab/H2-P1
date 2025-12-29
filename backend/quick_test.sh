#!/bin/bash
echo "Testing Todo API endpoints..."

# Register
echo -e "\n1. Registering user..."
RESPONSE=$(curl -s -X POST http://127.0.0.1:8000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"testapi@test.com","password":"test1234"}')

TOKEN=$(echo $RESPONSE | grep -o '"access_token":"[^"]*"' | cut -d'"' -f4)

if [ -z "$TOKEN" ]; then
  # Try login if already registered
  echo "User exists, logging in..."
  RESPONSE=$(curl -s -X POST http://127.0.0.1:8000/api/auth/login \
    -H "Content-Type: application/json" \
    -d '{"email":"testapi@test.com","password":"test1234"}')
  TOKEN=$(echo $RESPONSE | grep -o '"access_token":"[^"]*"' | cut -d'"' -f4)
fi

echo "Token: ${TOKEN:0:50}..."

# Create task
echo -e "\n2. Creating task..."
TASK_RESPONSE=$(curl -s -X POST http://127.0.0.1:8000/api/tasks/ \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"title":"Test Task","description":"Testing"}')

TASK_ID=$(echo $TASK_RESPONSE | grep -o '"id":[0-9]*' | cut -d':' -f2)
echo "Created task ID: $TASK_ID"

# Test PUT
echo -e "\n3. Testing PUT /api/tasks/$TASK_ID..."
PUT_RESPONSE=$(curl -s -X PUT http://127.0.0.1:8000/api/tasks/$TASK_ID \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"title":"Updated Title"}')
echo "PUT Response: $PUT_RESPONSE"

# Test DELETE
echo -e "\n4. Testing DELETE /api/tasks/$TASK_ID..."
DELETE_RESPONSE=$(curl -s -w "\nHTTP Status: %{http_code}" -X DELETE http://127.0.0.1:8000/api/tasks/$TASK_ID \
  -H "Authorization: Bearer $TOKEN")
echo "$DELETE_RESPONSE"

echo -e "\n✓ All tests completed!"
