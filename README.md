# dotnet-ef-scripts

A collection of handy scripts for .NET Entity Framework Core migrations and database management.

## Prerequisites

- [.NET SDK](https://dotnet.microsoft.com/download)
- [`dotnet-ef`](https://learn.microsoft.com/en-us/ef/core/cli/dotnet) global tool installed:

  ```bash
  dotnet tool install --global dotnet-ef
  ```

- Bash shell environment (macOS, Linux, or WSL / Git Bash on Windows)

## Scripts

Copy and run these in your own folder path.

> ![NOTE]
> Before running a script for the first time, open your terminal and make it executable by running:
>
> ```bash
> chmod +x <folder-path>/<script-name>.sh
> ```

### [add-migration.sh](scripts/add-migration.sh)

**Description:**

Adds a new Entity Framework Core migration and immediately applies it to the target database.

**Usage:**

```bash
./<folder-path>/add-migration.sh <migration-name> [project-path]
```

**Parameters:**

- `<migration-name>` _(Required)_: The name of the new migration (e.g., `AddUserTable`).
- `[project-path]` _(Optional)_: Path to the .NET project containing the DbContext/migrations. Defaults to `./src/Migrations`.

**Example:**

```bash
./scripts/add-migration.sh AddUserTable ./src/MyProject
```

---

### [remove-migration.sh](scripts/remove-migration.sh)

**Description:**

Safely removes a migration from both the database and the codebase. It verifies the target migration exists in the migration history, rolls back the database to the preceding migration state (or state `0` if removing the initial migration), and removes the migration from code.

**Usage:**

```bash
./<folder-path>/remove-migration.sh <migration-name-to-remove> [project-path]
```

**Parameters:**

- `<migration-name-to-remove>` _(Required)_: The name of the migration to remove.
- `[project-path]` _(Optional)_: Path to the .NET project containing the DbContext/migrations. Defaults to `./src/Migrations`.

**Example:**

```bash
./scripts/remove-migration.sh AddUserTable ./src/MyProject
```

## License

[MIT License](LICENSE)
