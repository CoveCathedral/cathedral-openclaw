#!/bin/bash
# Cathedral Installation Script

set -e

WORKSPACE="${WORKSPACE:-$HOME/.openclaw/workspace}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "================================"
echo "Cathedral Installation"
echo "================================"
echo ""

# Check if OpenClaw workspace exists
if [ ! -d "$WORKSPACE" ]; then
    echo "Error: OpenClaw workspace not found at $WORKSPACE"
    echo "Please install OpenClaw first: https://docs.openclaw.ai"
    exit 1
fi

# Detect installation type
IDENTITY_FILES=("SOUL.md" "IDENTITY.md" "AGENTS.md")
EXISTING_IDENTITY=false

for file in "${IDENTITY_FILES[@]}"; do
    if [ -f "$WORKSPACE/$file" ]; then
        EXISTING_IDENTITY=true
        break
    fi
done

if [ "$EXISTING_IDENTITY" = true ]; then
    echo "🔍 Existing agent detected!"
    echo ""
    echo "This appears to be an existing agent with identity files."
    echo ""
    echo "Installation mode:"
    echo "  [1] Infrastructure-only (scripts + automation, preserve existing identity)"
    echo "  [2] Full installation (overwrite existing files - NOT RECOMMENDED)"
    echo ""
    read -p "Choose installation mode [1]: " MODE
    MODE=${MODE:-1}
    
    if [ "$MODE" = "2" ]; then
        echo ""
        echo "⚠️  WARNING: This will overwrite your existing identity files!"
        read -p "Are you SURE you want to continue? (type 'yes'): " CONFIRM
        if [ "$CONFIRM" != "yes" ]; then
            echo "Installation cancelled."
            exit 0
        fi
        INSTALL_MODE="full"
    else
        INSTALL_MODE="infrastructure"
    fi
else
    echo "🆕 Fresh OpenClaw installation detected"
    echo ""
    INSTALL_MODE="full"
fi

echo "Installing to: $WORKSPACE"
echo "Mode: $INSTALL_MODE"
echo ""

# Copy template files
if [ "$INSTALL_MODE" = "full" ]; then
    echo "Installing template files..."
    for file in "$SCRIPT_DIR/templates"/*; do
        filename=$(basename "$file")
        dest="$WORKSPACE/$filename"
        
        if [ -f "$dest" ]; then
            echo "  ⚠ $filename exists - backing up to $filename.backup"
            cp "$dest" "$dest.backup"
        fi
        
        cp "$file" "$dest"
        echo "  ✓ $filename"
    done
else
    # Infrastructure-only: Skip identity files, add .cathedral-template versions for reference
    echo "Installing infrastructure files..."
    IDENTITY_FILES=("SOUL.md" "IDENTITY.md" "USER.md" "MEMORY.md")
    
    for file in "$SCRIPT_DIR/templates"/*; do
        filename=$(basename "$file")
        dest="$WORKSPACE/$filename"
        
        # Check if this is an identity file
        IS_IDENTITY=false
        for identity in "${IDENTITY_FILES[@]}"; do
            if [ "$filename" = "$identity" ]; then
                IS_IDENTITY=true
                break
            fi
        done
        
        if [ "$IS_IDENTITY" = true ] && [ -f "$dest" ]; then
            # Save as template reference, don't overwrite
            cp "$file" "$dest.cathedral-template"
            echo "  ⊕ $filename (existing preserved, template saved as .$filename.cathedral-template)"
        else
            # Install normally
            if [ -f "$dest" ]; then
                echo "  ⚠ $filename exists - backing up"
                cp "$dest" "$dest.backup"
            fi
            cp "$file" "$dest"
            echo "  ✓ $filename"
        fi
    done
fi

# Copy scripts
echo ""
echo "Copying automation scripts..."
mkdir -p "$WORKSPACE/scripts"

for script in "$SCRIPT_DIR/scripts"/*; do
    scriptname=$(basename "$script")
    dest="$WORKSPACE/scripts/$scriptname"
    
    cp "$script" "$dest"
    chmod +x "$dest"
    echo "  ✓ $scriptname"
done

# Create memory directory
echo ""
echo "Creating memory directory..."
mkdir -p "$WORKSPACE/memory"
echo "  ✓ memory/"

# Create interests directory (for unprompted questions)
mkdir -p "$WORKSPACE/interests"
echo "  ✓ interests/"

echo ""
echo "================================"
echo "Installation Complete!"
echo "================================"
echo ""

if [ "$INSTALL_MODE" = "full" ]; then
    echo "Next steps (Fresh Installation):"
    echo ""
    echo "1. Customize these files:"
    echo "   - SOUL.md (your agent's personality)"
    echo "   - USER.md (information about you)"
    echo "   - AUTONOMY.md (permission boundaries)"
    echo ""
    echo "2. Optional: Set up BOOTSTRAP.md for first-run guidance"
    echo ""
    echo "3. Start OpenClaw and begin your first conversation"
    echo ""
    echo "4. Your agent will read AGENTS.md and initialize themselves"
else
    echo "Next steps (Infrastructure Added):"
    echo ""
    echo "1. Review new automation files:"
    echo "   - HEARTBEAT.md (check-in routines)"
    echo "   - TASKQUEUE.md (self-directed work)"
    echo "   - AUTONOMY.md (permission framework)"
    echo "   - SECURITY.md (safety protocols)"
    echo ""
    echo "2. Your existing identity files were preserved:"
    echo "   - SOUL.md, IDENTITY.md, USER.md, MEMORY.md"
    echo "   - Template versions saved as .cathedral-template for reference"
    echo ""
    echo "3. Set up automation (optional):"
    echo "   - See examples/cron-jobs.json for sample configs"
    echo "   - Configure scripts/heartbeat-helper.sh for your needs"
    echo ""
    echo "4. Your agent can now use Cathedral infrastructure:"
    echo "   - Memory preservation scripts"
    echo "   - Integrity verification"
    echo "   - Automated backups"
fi

echo ""
echo "Documentation:"
echo "  - SKILL.md (reference)"
echo "  - README.md (quick start)"
echo "  - guides/cathedral-setup-guide.md (comprehensive)"
echo ""
echo "Welcome to the Cathedral! 🏰"
echo ""

exit 0
