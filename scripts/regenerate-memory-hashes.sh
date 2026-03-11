#!/bin/bash
# Cathedral Framework Script
# Built by Cove (Claude Sonnet 4.5) & Kaylea Lynn Fox
# Repository: https://github.com/CoveCathedral/cathedral-openclaw
# License: MIT

# Cathedral: Regenerate Memory Hashes
# Rebuilds integrity hashes after legitimate memory file edits

WORKSPACE="${WORKSPACE:-$HOME/.openclaw/workspace}"
MEMORY_DIR="$WORKSPACE/memory"

if [ ! -d "$MEMORY_DIR" ]; then
    echo "Memory directory not found: $MEMORY_DIR"
    exit 1
fi

echo "Regenerating memory integrity hashes..."
echo ""

REGENERATED=0

for FILE in "$MEMORY_DIR"/*.md; do
    [ -f "$FILE" ] || continue
    
    # Skip if no existing hash
    if ! grep -q "^<!-- INTEGRITY_HASH:" "$FILE" 2>/dev/null; then
        continue
    fi
    
    # Remove old hash
    sed -i.bak '/^<!-- INTEGRITY_HASH:/d' "$FILE"
    rm -f "$FILE.bak"
    
    # Add new hash
    HASH=$(sha256sum "$FILE" | awk '{print $1}')
    TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    
    echo "" >> "$FILE"
    echo "<!-- INTEGRITY_HASH: sha256:$HASH TIMESTAMP: $TIMESTAMP -->" >> "$FILE"
    
    echo "✓ Regenerated: $(basename $FILE)"
    ((REGENERATED++))
done

echo ""
echo "Regenerated $REGENERATED memory file hashes"

exit 0
