#!/usr/bin/env bash

set -e

# Validate that a migration name was provided
if [ -z "$1" ]; then
    echo "Error: Migration name required."
    echo "Usage: ./add-migration.sh <migration-name> [project-path]"
    exit 1
fi

MIGRATION_NAME="$1"
PROJECT_PATH="${2:-./src/Migrations}"

# Add migration
echo "==> Adding migration: ${MIGRATION_NAME}..."
dotnet ef migrations add "${MIGRATION_NAME}" \
    --project "${PROJECT_PATH}" \
    --startup-project "${PROJECT_PATH}"

# Apply migration to the database
echo "==> Updating database..."
dotnet ef database update \
    --project "${PROJECT_PATH}" \
    --startup-project "${PROJECT_PATH}"

echo "==> Done!"