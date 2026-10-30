# Recipy

Recipy is a PHP web application for sharing, exploring, saving, and commenting
on recipes. It uses PostgreSQL for persistent data and Docker Compose for a
reproducible local setup.

For the repository layout and project documentation, see
[`docs/documentation.md`](docs/documentation.md) or
[`docs/documentation.pdf`](docs/documentation.pdf).

## Requirements

- Docker Desktop on Windows, or Docker Engine and the Docker Compose plugin on Linux.
- Git.

## First-time setup on Windows

Install and start Docker Desktop, then open PowerShell in the repository root.
Create the local environment file and start the database:

```powershell
Copy-Item .env.example .env
docker compose up -d db
docker compose run --build --rm app php scripts/seed.php
docker compose up --build -d app
```

## First-time setup on Linux

Install Docker Engine and the Docker Compose plugin, then run these commands
from a terminal in the repository root:

```sh
cp .env.example .env
docker compose up -d db
docker compose run --build --rm app php scripts/seed.php
docker compose up --build -d app
```

In either system, review `.env` before starting. Docker Compose creates the
PostgreSQL database automatically from `DB_NAME`, `DB_USER`, and `DB_PASSWORD`;
there is no need to create it manually. The seed command imports
[`database/dumps/recipy_seed.sql`](database/dumps/recipy_seed.sql) into that
database. Open <http://localhost:8080>, or the port configured by `APP_PORT`,
to use the application.

The SQL dump creates tables, sequences, constraints, and records. It must be
loaded into an empty database and is not idempotent. Run the seed command only
once per database; do not repeat it after the database has already been seeded.

## Demo account

Use this account to sign in and try the application:

| Email | Password |
|---|---|
| `hugo@gmail.com` | `123456` |

This is a shared test account included in the public database dump. Do not use
it for personal data or in a production deployment.

## Run the application after the database has been initialized

If PostgreSQL is already running and its database has already been seeded,
start only the application:

```sh
docker compose up -d app
```

Compose will reuse the existing database and persistent volume. It will not
re-import the dump. If you have changed the PHP code or Dockerfile and need to
rebuild the application image, use:

```sh
docker compose up --build -d app
```

If the database and application containers were stopped but still exist, start
the database first and then the application:

```sh
docker compose start db
docker compose start app
```

To watch application logs:

```sh
docker compose logs -f app
```

Press `Ctrl+C` to stop following logs; this does not stop the application.

## Stop the application and database

Stop only the web application while leaving PostgreSQL running:

```sh
docker compose stop app
```

Stop both containers but keep them and the database volume for the next run:

```sh
docker compose stop
```

Start those stopped containers again with `docker compose start db` followed
by `docker compose start app`.

Remove the containers and Compose network while preserving the database volume:

```sh
docker compose down
```

This is the recommended way to shut down the project when you want to keep
your data. To launch again afterward, use `docker compose up -d db` and then
`docker compose up -d app`.

**Warning:** The following command also deletes the PostgreSQL volume and all
data stored in it:

```sh
docker compose down -v
```

Only use `down -v` when you intentionally want to permanently erase the local
database. To set up again after deleting it, repeat the [first-time setup](#first-time-setup),
including the seed step.

## Configuration

Docker Compose reads `.env`; `.env` is ignored by Git. Start with
`.env.example` and configure:

| Variable | Purpose | Example default |
|---|---|---|
| `DB_HOST` | Database host for PHP running on the host | `localhost` |
| `DB_PORT` | PostgreSQL port published on the host | `5434` |
| `DB_NAME` | Database name | `recipy` |
| `DB_USER` | Database user | `recipy` |
| `DB_PASSWORD` | Local database password | `recipy_local_password` |
| `APP_PORT` | HTTP port published by the app | `8080` |

Inside Docker, the application connects to the database service using the
Compose hostname `db`. Change the example credentials before exposing the
services beyond your local machine.

## Profile photos

Profile updates accept JPEG, PNG, GIF, or WebP images up to 2 MB. Uploaded
photos are stored in the `recipy-profile-images` Docker volume and remain
available when the application container is rebuilt or restarted. `docker
compose down` preserves this volume; `docker compose down -v` deletes it.

## Running PHP without Docker

For host-based development, install PHP with the `pgsql` extension, the
PostgreSQL client (`psql`), and a PostgreSQL server. Set `DB_HOST` to
`localhost` in `.env`, ensure the database settings match the server, and
start the development server from the repository root:

```sh
php -S 0.0.0.0:8080
```

If the database is empty, load the dump once with:

```sh
php scripts/seed.php
```
