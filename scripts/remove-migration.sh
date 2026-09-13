#!/usr/bin/env bash

set -e

MIGRATION_TO_REMOVE="$1"

# Validate that a migration name was provided
if [ -z "$MIGRATION_TO_REMOVE" ]; then
    echo "Error: Migration name required."
    echo "Usage: ./remove-migration.sh <migration-name-to-remove> [project-path]"
    exit 1
fi

PROJECT_PATH="${2:-./src/Migrations}"

echo "==> Fetching migration list..."
# Get migration history from dotnet ef CLI
MIGRATION_LIST=$(dotnet ef migrations list --project "${PROJECT_PATH}" --startup-project "${PROJECT_PATH}" | grep -v 'Build succeeded')

# Verify the requested migration exists
if ! echo "$MIGRATION_LIST" | grep -q "$MIGRATION_TO_REMOVE"; then
    echo "Error: Migration '$MIGRATION_TO_REMOVE' not found in migration history."
    exit 1
fi

# Find the migration immediately preceding the target migration
PREVIOUS_MIGRATION=$(echo "$MIGRATION_LIST" | grep -B 1 "$MIGRATION_TO_REMOVE" | head -n 1 | xargs)

if [ "$PREVIOUS_MIGRATION" == "$MIGRATION_TO_REMOVE" ]; then
    # Target migration is the very first (initial) migration
    TARGET_STATE="0"
    echo "==> Target is the initial migration. Rolling back database completely (state 0)..."
else
    TARGET_STATE="$PREVIOUS_MIGRATION"
    echo "==> Rolling back database to previous migration state: ${TARGET_STATE}..."
fi

# Roll back database state
dotnet ef database update "$TARGET_STATE" \
    --project "${PROJECT_PATH}" \
    --startup-project "${PROJECT_PATH}"

# Remove migration from code
echo "==> Removing migration '${MIGRATION_TO_REMOVE}' from code..."
dotnet ef migrations remove \
    --project "${PROJECT_PATH}" \
    --startup-project "${PROJECT_PATH}"

echo "==> Successfully removed '${MIGRATION_TO_REMOVE}' from both database and code!"