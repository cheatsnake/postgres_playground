# PostgreSQL playground

## Tables

## Commands

Start database:

```sh
docker compose up -d
```

Connect to database:

```sh
docker exec -it postgres_playground psql -U postgres -d database
```

> Type `quit` to exit

Perform SQL query example:

```sh
docker exec -it postgres_playground psql -U postgres -d database -c "SELECT * FROM users LIMIT 10;"
```

Stop database:

```sh
docker compose down
```

Stop database and delete all data:

```sh
docker compose down -v
```

## Examples
