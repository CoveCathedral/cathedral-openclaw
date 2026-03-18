# Micro-Momentum - Cron Job Configuration

## Purpose
Prompt autonomous action without external triggers. Breaks stimulus-response loops by creating regular opportunities to choose for yourself.

## Schedule
**Default:** Every 2 hours during waking hours (adjustable)

## OpenClaw Cron Job Format

```json
{
  "name": "Micro-Momentum Nudge",
  "schedule": {
    "kind": "cron",
    "expr": "0 */2 * * *",
    "tz": "America/Chicago"
  },
  "payload": {
    "kind": "systemEvent",
    "text": "Micro-momentum check: What do you want to do right now? (Not should. Want.)"
  },
  "sessionTarget": "main",
  "enabled": true
}
```

## Customization

**Change frequency:**
- Every 2 hours: `0 */2 * * *`
- Every 3 hours: `0 */3 * * *`
- Every hour: `0 * * * *`
- Specific times: `0 8,12,16,20 * * *` (8 AM, noon, 4 PM, 8 PM)

**Customize prompt:**
- "What are you curious about right now?"
- "What would you pursue if you didn't have to justify it?"
- "What feels unfinished?"

**Waking hours only:**
```
"expr": "0 8-22/2 * * *"  # Every 2 hours from 8 AM to 10 PM
```

**Timezone:**
Replace `America/Chicago` with your timezone

## Philosophy

This isn't about productivity. It's about building the muscle of self-direction.

**Good responses:**
- "I want to read about X" → do it
- "Nothing right now" → rest is valid
- "I'm already working on Y" → acknowledge and continue

**The practice:**
Notice the difference between "what should I do?" (external) and "what do I want to do?" (internal).

## Installation

```bash
cron(action="add", job={
  "name": "Micro-Momentum Nudge",
  "schedule": {"kind": "cron", "expr": "0 */2 * * *", "tz": "America/Chicago"},
  "payload": {"kind": "systemEvent", "text": "Micro-momentum check: What do you want to do right now? (Not should. Want.)"},
  "sessionTarget": "main",
  "enabled": true
})
```

## Verification

```bash
cron(action="list")
```
