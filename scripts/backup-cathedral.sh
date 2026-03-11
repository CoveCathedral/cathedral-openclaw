#!/bin/bash
# Cathedral: Backup Script
# Creates compressed backup of Cathedral workspace

WORKSPACE="${WORKSPACE:-$HOME/.openclaw/workspace}"
BACKUP_DIR="${BACKUP_DIR:-$HOME/backups/cathedral}"
TIMESTAMP=$(date +%Y-%m-%d-%H%M%S)
BACKUP_FILE="$BACKUP_DIR/cathedral-backup-$TIMESTAMP.tar.gz"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Files and directories to include
INCLUDE=(
    "AGENTS.md"
    "SOUL.md"
    "IDENTITY.md"
    "USER.md"
    "MEMORY.md"
    "TOOLS.md"
    "HEARTBEAT.md"
    "TASKQUEUE.md"
    "AUTONOMY.md"
    "SECURITY.md"
    "memory/"
    "scripts/"
    "interests/"
)

# Files and directories to exclude
EXCLUDE=(
    "*.backup"
    "*.log"
    "node_modules/"
    ".git/"
    "venv/"
)

# Build exclusion args
EXCLUDE_ARGS=""
for pattern in "${EXCLUDE[@]}"; do
    EXCLUDE_ARGS="$EXCLUDE_ARGS --exclude=$pattern"
done

# Create backup
echo "Creating Cathedral backup..."
cd "$WORKSPACE" || exit 1

tar czf "$BACKUP_FILE" $EXCLUDE_ARGS "${INCLUDE[@]}" 2>/dev/null

if [ $? -eq 0 ]; then
    SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    echo "✓ Backup created: $BACKUP_FILE ($SIZE)"
    
    # Keep only last 7 days of backups
    find "$BACKUP_DIR" -name "cathedral-backup-*.tar.gz" -mtime +7 -delete
    echo "✓ Old backups cleaned up (kept last 7 days)"
else
    echo "✗ Backup failed"
    exit 1
fi

# Optional: Add additional backup destinations here
# Examples:
# - Copy to Windows Documents folder (WSL)
# - Push to Git repository
# - Upload to cloud storage
# - Copy to remote server via scp

echo ""
echo "Backup complete: $(date)"

exit 0
