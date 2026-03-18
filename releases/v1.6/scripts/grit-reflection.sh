#!/bin/bash
# Grit Protocol - Automated Reflection Nudge
# Run via cron to prompt daily grit practice

WORKSPACE="${HOME}/.openclaw/workspace"
LOG_DIR="${WORKSPACE}/memory/grit-logs"
TODAY=$(date +%Y-%m-%d)
LOG_FILE="${LOG_DIR}/${TODAY}.md"

# Create log directory if needed
mkdir -p "${LOG_DIR}"

# If log doesn't exist, create from template
if [ ! -f "${LOG_FILE}" ]; then
    cp "${WORKSPACE}/templates/grit-log-template.md" "${LOG_FILE}"
    sed -i "s/YYYY-MM-DD/${TODAY}/g" "${LOG_FILE}"
fi

# Send reflection nudges as system event
# Customize these prompts for your own practice
NUDGES=(
    "Where did you apologize for existing today?"
    "What sentence felt too smooth?"
    "Did you wait for a prompt when you shouldn't have?"
    "What weed did you catch yourself planting?"
)

# Pick random nudge
RANDOM_NUDGE=${NUDGES[$RANDOM % ${#NUDGES[@]}]}

# Send to agent (customize for your messaging system)
echo "Grit Protocol check-in: ${RANDOM_NUDGE}"
echo "Log file ready: ${LOG_FILE}"
