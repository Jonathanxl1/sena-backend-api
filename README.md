## 🚀 NestJS + Postgres (Docker)

This repository contains a **NestJS** backend and a **Postgres** database. The database can be initialized with a default backup using Docker.

---

## 📋 Requirements

- **Git**: https://git-scm.com/downloads
- **Docker + Docker Compose**: https://www.docker.com/get-started
- **Node.js** (for NestJS development): https://nodejs.org/

---

## ⚙️ Environment Variables

Create a `.env` file in the project root with your database credentials. Example:

```bash
POSTGRES_DB=mydb
POSTGRES_USER=myuser
POSTGRES_PASSWORD=secret
# optional if you want to restore a backup automatically
BACKUP_FILE=/backups/backup.dump
```

---

## 🐘 Start Postgres with Docker

From the project root:

```bash
docker compose up -d
```

This starts a Postgres 17 container on port `5432` and mounts:

- `./postgres_data` for persistent data
- `./init` for init scripts (restores `BACKUP_FILE` if present)
- `./backups` for your dump files (read-only)

Stop containers:

```bash
docker compose down
```

---

## ▶️ Run the API

Install dependencies and start the Nest server (default port `3000`).

```bash
npm install
npm run start:dev
```

The API will be available at: http://localhost:3000

If you need CORS, it is already enabled in `src/main.ts`.

---

## 👤 Users API

Base URL: `http://localhost:3000/users`

### Create User

- Method: POST
- URL: `/users`
- Body (JSON):

```json
{
  "name": "John",
  "lastname": "Doe",
  "address": "123 Street",
  "email": "john@example.com",
  "work_role": "Engineer"
}
```

- cURL:

```bash
curl -X POST http://localhost:3000/users \
  -H "Content-Type: application/json" \
  -d '{
    "name":"John",
    "lastname":"Doe",
    "address":"123 Street",
    "email":"john@example.com",
    "work_role":"Engineer"
  }'
```

### List Users

- Method: GET
- URL: `/users`
- cURL:

```bash
curl http://localhost:3000/users
```

### Get One User

- Method: GET
- URL: `/users/:id`
- cURL:

```bash
curl http://localhost:3000/users/1
```

### Update User

- Method: PUT
- URL: `/users/:id`
- Body (JSON): partial allowed

```json
{
  "address": "456 Avenue"
}
```

- cURL:

```bash
curl -X PUT http://localhost:3000/users/1 \
  -H "Content-Type: application/json" \
  -d '{"address":"456 Avenue"}'
```

### Delete User

- Method: DELETE
- URL: `/users/:id`
- Returns 204 No Content on success
- cURL:

```bash
curl -X DELETE http://localhost:3000/users/1 -i
```

---

## 🧪 Health Check

Once the API is running, you can quickly verify connectivity:

```bash
curl http://localhost:3000/users
```

If you see a JSON array (possibly empty), the service is up and connected to Postgres.

---

## 🧰 Troubleshooting

- "column \"name\" of relation \"user\" contains null values":

  - Ensure your request body includes all required fields.
  - The `name` column is NOT NULL by default; sending empty or missing values will fail.

- Cannot connect to database:

  - Check that Docker container `pg17` is running: `docker ps`
  - Verify `.env` values (`POSTGRES_*`) and that port `5432` is free

- Unique violation on email:
  - The `email` field is unique. Use a different email or update the existing user.

---

## 📦 NPM Scripts

```bash
npm run start        # start server
npm run start:dev    # start in watch mode
npm run build        # build to dist
npm run lint         # lint and fix
npm test             # run unit tests
```

---

## 📁 Project Structure

- `src/users` – Users module (controller, service, DTOs, entity)
- `docker-compose.yml` – Postgres configuration
- `init/` – Initialization scripts for Postgres (restore backup)
- `backups/` – Place your `.dump` files here
- `postgres_data/` – Persistent volume for DB data

---

## 🌐 Base URLs

- API: `http://localhost:3000`
- Postgres: `localhost:5432` (from host)
