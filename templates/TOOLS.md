# TOOLS.md - Local Environment Configuration

Environment-specific information unique to your setup.

**Instructions:** Add details your agent needs to operate in your environment. This separates general skills (which are shared) from your specific infrastructure.

---

## What Goes Here

Things like:
- Camera names and locations
- SSH hosts and aliases
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- API keys and credentials (reference locations, not actual keys)
- Custom script paths
- Anything environment-specific

## Examples

### Cameras
```markdown
- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered
```

### SSH
```markdown
- home-server → 192.168.1.100, user: admin
- vps-main → SSH key at ~/.ssh/vps_key
```

### TTS (Text-to-Speech)
```markdown
- Primary voice: [voice/model name]
- Settings: [rate, pitch, API version]
- API key location: ~/.config/[service]/api-key
- Script: scripts/tts.py "<text>" output.ogg
```

### Custom Scripts
```markdown
- Backup script: scripts/backup-custom.sh
- Analysis tool: scripts/analyze.py
- Data processing: scripts/process-data.sh
```

---

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

---

*Add whatever helps your agent do their job. This is your cheat sheet.*
