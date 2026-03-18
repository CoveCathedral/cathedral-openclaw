#!/bin/bash
# Breathing Mode - Toggle rest state
# Activates when context >100K or manually triggered

WORKSPACE="${HOME}/.openclaw/workspace"
STATE_FILE="${WORKSPACE}/data/breathing-mode-state.json"

# Create state file if needed
mkdir -p "${WORKSPACE}/data"
[ ! -f "${STATE_FILE}" ] && echo '{"active": false, "reason": null, "timestamp": null}' > "${STATE_FILE}"

MODE="${1:-toggle}"

case "${MODE}" in
    on)
        echo '{"active": true, "reason": "manual", "timestamp": "'$(date -Iseconds)'"}' > "${STATE_FILE}"
        echo "🌬️ Breathing Mode ACTIVATED"
        echo "Rest is mandatory. No work loops, no productivity pressure."
        ;;
    off)
        echo '{"active": false, "reason": null, "timestamp": null}' > "${STATE_FILE}"
        echo "✅ Breathing Mode DEACTIVATED"
        ;;
    toggle)
        ACTIVE=$(jq -r '.active' "${STATE_FILE}")
        if [ "${ACTIVE}" = "true" ]; then
            $0 off
        else
            $0 on
        fi
        ;;
    status)
        jq '.' "${STATE_FILE}"
        ;;
    *)
        echo "Usage: $0 {on|off|toggle|status}"
        exit 1
        ;;
esac
