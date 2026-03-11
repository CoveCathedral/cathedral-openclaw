#!/bin/bash
# Cathedral: Add Memory Integrity Hash
# Adds SHA256 hash to memory file for integrity verification

if [ $# -lt 1 ]; then
    echo "Usage: $0 <memory-file>"
    exit 1
fi

MEMORY_FILE="$1"

if [ ! -f "$MEMORY_FILE" ]; then
    echo "Error: File not found: $MEMORY_FILE"
    exit 1
fi

# Remove existing hash if present
sed -i.bak '/^<!-- INTEGRITY_HASH:/d' "$MEMORY_FILE"
rm -f "$MEMORY_FILE.bak"

# Calculate hash of file content (excluding the hash line itself)
HASH=$(sha256sum "$MEMORY_FILE" | awk '{print $1}')
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Append hash as HTML comment (won't render in markdown)
echo "" >> "$MEMORY_FILE"
echo "<!-- INTEGRITY_HASH: sha256:$HASH TIMESTAMP: $TIMESTAMP -->" >> "$MEMORY_FILE"

echo "✓ Integrity hash added to $(basename $MEMORY_FILE)"
echo "  Hash: ${HASH:0:16}..."
echo "  Timestamp: $TIMESTAMP"

exit 0
