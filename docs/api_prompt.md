# API Integration Prompt Guide

Use this document to provide details for new or existing API endpoints. Based on your input, the integration code will be generated or updated in the appropriate files.

## How to Use

1. Copy the template below for each API you want to add or update.
2. Fill in the details for endpoint, request, response, and error.
3. Save the file. The automation will use this information to update your codebase.

---

## API Integration Template

### Endpoint Name

`<A short, descriptive name for the endpoint>`

### Endpoint URL

`<The full URL or path for the endpoint>`

### HTTP Method

`GET | POST | PUT | DELETE | PATCH`

### Request Payload (JSON)

```json
{
  // Example request body
}
```

### Response Example (JSON)

```json
{
  // Example response body
}
```

### Error Example (JSON)

```json
{
  // Example error response
}
```

### Notes

- Any special notes or requirements for this endpoint.

---

## Example

### Endpoint Name

Get User Profile

### Endpoint URL

https://api.example.com/user/profile

### HTTP Method

GET

### Request Payload (JSON)

```json
{}
```

### Response Example (JSON)

```json
{
  "id": "123",
  "name": "John Doe",
  "status": "active"
}
```

### Error Example (JSON)

```json
{
  "error": "User not found"
}
```

### Notes

- Requires authentication token in headers.
