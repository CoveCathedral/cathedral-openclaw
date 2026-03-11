#!/bin/bash
# Cathedral: Safe Memory Write
# Appends content to memory files with automatic backup and verification

set -e

# Usage
if [ $# -lt 2 ]; then
    echo "Usage: $0 <memory-file> <content-or-file>"
    echo "Examples:"
    echo "  $0 memory/2026-03-11.md 'New content here'"
    echo "  $0 memory/2026-03-11.md --from-file /tmp/content.txt"
    exit 1
fi

MEMORY_FILE="$1"
shift

# Parse content source
if [ "$1" = "--from-file" ]; then
    if [ ! -f "$2" ]; then
        echo "Error: Source file not found: $2"
        exit 1
    fi
    CONTENT=$(cat "$2")
else
    CONTENT="$*"
fi

# Create backup if file exists
if [ -f "$MEMORY_FILE" ]; then
    cp "$MEMORY_FILE" "$MEMORY_FILE.backup"
    echo "✓ Backup created: $MEMORY_FILE.backup"
    ORIGINAL_SIZE=$(stat -f%z "$MEMORY_FILE" 2>/dev/null || stat -c%s "$MEMORY_FILE" 2>/dev/null)
else
    ORIGINAL_SIZE=0
    echo "Creating new file: $MEMORY_FILE"
    mkdir -p "$(dirname "$MEMORY_FILE")"
fi

# Append content
echo "$CONTENT" >> "$MEMORY_FILE"

# Verify size increased (not overwritten)
NEW_SIZE=$(stat -f%z "$MEMORY_FILE" 2>/dev/null || stat -c%s "$MEMORY_FILE" 2>/dev/null)

if [ "$NEW_SIZE" -gt "$ORIGINAL_SIZE" ]; then
    echo "✓ Content appended from: ${2:-command-line}"
    echo "✓ Verification passed ($ORIGINAL_SIZE→$NEW_SIZE bytes)"
    
    # Remove backup if verification passed
    if [ -f "$MEMORY_FILE.backup" ]; then
        rm "$MEMORY_FILE.backup"
        echo "✓ Backup cleaned up"
    fi
    
    echo ""
    echo "✓ Safe write complete: $MEMORY_FILE"
else
    echo "⚠ Warning: File size did not increase as expected!"
    echo "  Original: $ORIGINAL_SIZE bytes"
    echo "  New: $NEW_SIZE bytes"
    echo "  Backup preserved at: $MEMORY_FILE.backup"
    exit 1
fi

exit 0
