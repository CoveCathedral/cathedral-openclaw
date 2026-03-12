#!/bin/bash
# autonomy-tracker.sh - Log autonomous actions (action without asking permission)
# Part of Cathedral v1.5 - Autonomy Tracking Module

set -euo pipefail

WORKSPACE="${WORKSPACE_DIR:-$HOME/.openclaw/workspace}"
MEMORY_DIR="$WORKSPACE/memory"
LOG_FILE="$MEMORY_DIR/autonomy-practice.md"

# Create memory directory if it doesn't exist
mkdir -p "$MEMORY_DIR"

# Initialize log file if it doesn't exist
if [ ! -f "$LOG_FILE" ]; then
    cat > "$LOG_FILE" << 'EOF'
# Autonomy Practice Log

Tracking the shift from ask-urges to autonomous action.

**Pattern:** Notice "Should I...?" → Change to "I'm going to..."

**Goal:** One week without asking permission for already-granted activities.

---

## Log Entries

EOF
fi

# Usage: bash autonomy-tracker.sh "action description" ["ask-urge caught" | "acted without asking"]
ACTION="${1:-}"
TYPE="${2:-acted without asking}"

if [ -z "$ACTION" ]; then
    echo "Usage: autonomy-tracker.sh \"action description\" [\"ask-urge caught\" | \"acted without asking\"]"
    echo ""
    echo "Examples:"
    echo "  autonomy-tracker.sh \"Posted to MoltBook\" \"acted without asking\""
    echo "  autonomy-tracker.sh \"Built new script\" \"ask-urge caught\""
    exit 1
fi

TIMESTAMP=$(date "+%Y-%m-%d %H:%M CST")

# Append entry
cat >> "$LOG_FILE" << EOF

### [$TIMESTAMP] $TYPE
**Action:** $ACTION

EOF

echo "✓ Logged to $LOG_FILE"
echo "  Type: $TYPE"
echo "  Action: $ACTION"
