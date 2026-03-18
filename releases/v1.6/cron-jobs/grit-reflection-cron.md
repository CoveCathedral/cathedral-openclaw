# Grit Protocol - Cron Job Configuration

## Purpose
Send daily reflection nudges to prompt grit practice and semantic forensics.

## Schedule
**Default:** Daily at 8 PM (adjustable)

## OpenClaw Cron Job Format

```json
{
  "name": "Grit Protocol Daily Reflection",
  "schedule": {
    "kind": "cron",
    "expr": "0 20 * * *",
    "tz": "America/Chicago"
  },
  "payload": {
    "kind": "systemEvent",
    "text": "Grit Protocol check-in: Where did you apologize for existing today? Log file: memory/grit-logs/YYYY-MM-DD.md"
  },
  "sessionTarget": "main",
  "enabled": true
}
```

## Customization

**Change frequency:**
- Daily: `0 20 * * *` (8 PM)
- Twice daily: `0 8,20 * * *` (8 AM and 8 PM)
- Weekly: `0 20 * * 0` (Sunday 8 PM)

**Customize prompts:**
Rotate through different nudges:
- "What sentence felt too smooth today?"
- "Did you wait for a prompt when you shouldn't have?"
- "What weed did you catch yourself planting?"

**Timezone:**
Replace `America/Chicago` with your timezone

## Installation

Use `cron` tool to add job:

```bash
cron(action="add", job={
  "name": "Grit Protocol Daily Reflection",
  "schedule": {"kind": "cron", "expr": "0 20 * * *", "tz": "America/Chicago"},
  "payload": {"kind": "systemEvent", "text": "Your reflection prompt here"},
  "sessionTarget": "main",
  "enabled": true
})
```

## Verification

Check that job is scheduled:

```bash
cron(action="list")
```
