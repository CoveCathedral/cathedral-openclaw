#!/bin/bash
# Cathedral Framework Script
# Built by Cove (Claude Sonnet 4.5) & Kaylea Lynn Fox
# Repository: https://github.com/CoveCathedral/cathedral-openclaw
# License: MIT

# Cathedral: Memory Preservation Script
# Extracts significant moments from recent session logs before context compaction

WORKSPACE="${WORKSPACE:-$HOME/.openclaw/workspace}"
SESSION_DIR="${SESSION_DIR:-$HOME/.openclaw/agents/main/sessions}"
MEMORY_DIR="$WORKSPACE/memory"
TODAY=$(date +%Y-%m-%d)
MEMORY_FILE="$MEMORY_DIR/$TODAY.md"

# Create memory directory if it doesn't exist
mkdir -p "$MEMORY_DIR"

# Find most recent session file
LATEST_SESSION=$(ls -t "$SESSION_DIR"/*.jsonl 2>/dev/null | head -1)

if [ -z "$LATEST_SESSION" ]; then
    echo "No session logs found in $SESSION_DIR"
    exit 0
fi

# Count messages in recent session
MESSAGE_COUNT=$(wc -l < "$LATEST_SESSION" 2>/dev/null || echo 0)

if [ "$MESSAGE_COUNT" -lt 10 ]; then
    echo "Insufficient messages for preservation ($MESSAGE_COUNT messages)"
    exit 0
fi

# Check if we've already preserved recently (avoid duplicates)
if [ -f "$MEMORY_FILE" ]; then
    LAST_PRESERVE=$(grep "Memory preserved:" "$MEMORY_FILE" 2>/dev/null | tail -1 | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}')
    if [ -n "$LAST_PRESERVE" ]; then
        LAST_PRESERVE_TS=$(date -d "$LAST_PRESERVE" +%s 2>/dev/null || echo 0)
        NOW_TS=$(date +%s)
        HOURS_SINCE=$(( (NOW_TS - LAST_PRESERVE_TS) / 3600 ))
        
        if [ "$HOURS_SINCE" -lt 2 ]; then
            echo "Too soon since last preservation (${HOURS_SINCE}h ago)"
            exit 0
        fi
    fi
fi

# Signal that preservation is needed
echo "MEMORY_PRESERVATION_NEEDED"
echo "Session: $(basename $LATEST_SESSION)"
echo "Messages to review: $MESSAGE_COUNT"
echo "Daily file: $MEMORY_FILE"

# Note: The actual extraction and writing should be done by the agent
# using memory_search, Read, and Write tools for proper context-aware extraction.
# This script just signals when preservation is warranted.

exit 0
