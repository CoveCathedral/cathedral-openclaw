# HEARTBEAT.md - Automated Check-In Routines

Instructions for your agent's automated heartbeat polls.

**Instructions:** Configure what your agent should check during automated heartbeats. Keep it focused and efficient.

---

## How Heartbeats Work

OpenClaw sends periodic heartbeat polls (default ~30 min). Your agent:
1. Reads this file for instructions
2. Runs checks specified below
3. If nothing needs attention → responds `HEARTBEAT_OK` (silent)
4. If something needs attention → reports and takes action

## Primary Heartbeat Flow

**Run the heartbeat helper first:**
```bash
bash scripts/heartbeat-helper.sh
```

**If output is `HEARTBEAT_HELPER_OK`:**
- Reply with: `HEARTBEAT_OK`
- No further action needed

**If alerts are shown:**
- Review each alert
- Take appropriate action
- Report what you did

---

## What to Check

Configure `scripts/heartbeat-helper.sh` to check what matters for your setup.

**Examples:**
- Security checks (file integrity, unusual processes) - daily
- Communication monitoring (email, messages) - every few hours
- Calendar/upcoming events - morning and evening
- Project status updates - when relevant
- Custom monitoring for your specific needs

**Rotation approach:** Don't check everything every heartbeat. Rotate through different checks throughout the day to balance thoroughness with efficiency.

---

## Proactive Work During Heartbeats

Your agent can use heartbeats for maintenance work:

**Allowed without asking:**
- Read and organize memory files
- Update documentation
- Review and update MEMORY.md (extract from daily files)
- Check on background processes
- Routine system maintenance

**Pattern:** Most heartbeats should be silent (`HEARTBEAT_OK`). Speak up when something genuinely needs attention.

---

## Check-In Windows (Optional)

Define specific times when your agent might proactively reach out:

**Morning check-in (~[YOUR TIME]):**
- Review overnight activity
- Surface anything important for the day
- Genuine need only - not required reports

**Evening check-in (~[YOUR TIME]):**
- Daily vibecheck reminder (if implemented)
- Significant developments worth sharing
- Again: genuine need, not obligation

**Pattern:** Your agent decides whether to reach out based on actual need, not scheduled reporting.

---

*Customize this file to match your agent's actual responsibilities and your preferred level of proactive engagement.*
