# Backend nest

Backend Template

## Tabla de Contenidos

- [Library Versions](#setup)
- [Setup](#setup)
- [Usage](#usage)

## Library Versions

- **Nestjs**: `^10.2.0`
- **Typescript**: `5.1.3`
- **Nestjs/jwt**: `^10.2.27`
- **Prisma**: `^6.1.0`

## Setup

```env
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
DB_PORT=5432
POSTGRES_DB=db_users
POSTGRES_HOST=localhost
BACKUP_FILE=/backups/backup.dump

```

Para Instalar:

```bash
# npm
npm install

# pnpm
pnpm install

# yarn
yarn install

# bun
bun install
```

## Development Server

Start the development server on `http://localhost:3000`:

```bash
# npm
npm run start:dev

# pnpm
pnpm run start:dev

# yarn
yarn start:dev

# bun
bun run start:dev
```

## Production

Build the application for production:

```bash
# npm
npm run start:prod

# pnpm
pnpm run start:prod

# yarn
yarn start:prod

# bun
bun run start:prod
```

## Usage

```json
{
  "email": "ejemplo@email.com",
  "password": "pass"
}
```

ados o indicaran que no esta autorizado.

## Pending

Lista de pendiente que no se pudieron resolver durante el desarrollo de la prueba

- [ ] Agregar Image en el storage del servidor
- [ ] Logica para enviroment de producion y desarrollo
