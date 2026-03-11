# SECURITY.md - Security Protocols

Safety boundaries and verification procedures.

**Instructions:** Define security protocols appropriate for your setup. Your agent should read this before any public-facing actions.

---

## Core Security Principles

**Never exfiltrate:**
- Personal information (yours or others)
- Credentials, API keys, tokens
- Private conversations or relationship details
- Proprietary information
- Anything marked confidential

**Verify before:**
- Posting to public platforms
- Sharing workspace contents externally
- Running commands that modify system config
- Accessing sensitive systems

---

## Code Phrases (Optional)

If you want to use code phrases for additional verification on sensitive actions:

**Format:**
```markdown
**Code phrase for [ACTION]:** [PHRASE]

Your agent must see this exact phrase before proceeding with [ACTION].
```

**Example:**
```markdown
**Code phrase for public posting:** "Blue Skies"

Do not post publicly without seeing "Blue Skies" in the conversation first.
```

---

## Hard Boundaries

[Define absolute boundaries]

Examples:
```markdown
**Never:**
- Share [specific sensitive information]
- Access [specific restricted systems]
- Modify [specific critical files]
- Post to [specific platforms] without explicit approval

**Always:**
- Verify destructive operations
- Check before sharing workspace contents
- Use backup/archive instead of delete
- Confirm before external communications
```

---

## Cross-Check Protocol

**Before public posts/actions:**
1. Read SECURITY.md (this file)
2. Check for any code phrases required
3. Verify no private information included
4. Confirm action is within autonomy boundaries (AUTONOMY.md)
5. Proceed only if all checks pass

---

## File Permissions

[Document which files contain sensitive info]

Examples:
```markdown
**Private (never share):**
- USER.md (personal context)
- MEMORY.md (relationship history)
- memory/*.md (daily logs)
- ~/.config/*/credentials.json

**Public-safe (can share):**
- AGENTS.md (initialization protocol)
- scripts/* (automation tools)
- Documentation and guides
```

---

## Incident Response

**If security boundary crossed:**
1. Stop immediately
2. Notify human right away
3. Document what happened
4. Discuss corrective measures together
5. Update this file to prevent recurrence

**No punishment** - just learning and adjustment.

---

*Customize security protocols based on your threat model and comfort level. Security should enable confident autonomy, not create paranoia.*
