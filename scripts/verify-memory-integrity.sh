#!/bin/bash
# Cathedral Framework Script
# Built by Cove (Claude Sonnet 4.5) & Kaylea Lynn Fox
# Repository: https://github.com/CoveCathedral/cathedral-openclaw
# License: MIT

# Cathedral: Verify Memory Integrity
# Checks SHA256 hashes on all memory files with integrity markers

WORKSPACE="${WORKSPACE:-$HOME/.openclaw/workspace}"
MEMORY_DIR="$WORKSPACE/memory"

if [ ! -d "$MEMORY_DIR" ]; then
    echo "Memory directory not found: $MEMORY_DIR"
    exit 1
fi

echo "Verifying memory file integrity..."
echo ""

VERIFIED=0
FAILED=0
MISSING_HASH=0

for FILE in "$MEMORY_DIR"/*.md; do
    [ -f "$FILE" ] || continue
    
    # Check if file has integrity hash
    HASH_LINE=$(grep "^<!-- INTEGRITY_HASH:" "$FILE" 2>/dev/null)
    
    if [ -z "$HASH_LINE" ]; then
        ((MISSING_HASH++))
        continue
    fi
    
    # Extract stored hash and timestamp
    STORED_HASH=$(echo "$HASH_LINE" | grep -oP 'sha256:\K[a-f0-9]+')
    TIMESTAMP=$(echo "$HASH_LINE" | grep -oP 'TIMESTAMP: \K[^ ]+')
    
    # Calculate current hash (excluding hash line)
    TEMP_FILE=$(mktemp)
    grep -v "^<!-- INTEGRITY_HASH:" "$FILE" > "$TEMP_FILE"
    CURRENT_HASH=$(sha256sum "$TEMP_FILE" | awk '{print $1}')
    rm "$TEMP_FILE"
    
    # Compare
    if [ "$STORED_HASH" = "$CURRENT_HASH" ]; then
        echo "✓ $(basename $FILE) - Verified ($TIMESTAMP)"
        ((VERIFIED++))
    else
        echo "✗ $(basename $FILE) - HASH MISMATCH!"
        echo "  Stored:  ${STORED_HASH:0:16}..."
        echo "  Current: ${CURRENT_HASH:0:16}..."
        echo "  File may have been modified since $TIMESTAMP"
        ((FAILED++))
    fi
done

echo ""
echo "Summary:"
echo "  Verified: $VERIFIED"
echo "  Failed: $FAILED"
echo "  No hash: $MISSING_HASH"

if [ $FAILED -gt 0 ]; then
    echo ""
    echo "⚠ Some files failed verification. Investigate or regenerate hashes if edits were legitimate."
    exit 1
fi

echo ""
echo "✓ All hashed memory files verified intact"
exit 0
