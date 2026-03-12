#!/bin/bash
# Cathedral v1.5 Installer - Component-Based Installation
# Supports both fresh installs and integration with existing setups

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default workspace
WORKSPACE="${WORKSPACE_DIR:-$HOME/.openclaw/workspace}"

# Component selection (will be populated by wizard)
declare -A INSTALL_COMPONENTS

# Installation mode
MODE="interactive" # or "auto" for CI/scripted installs

echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}   Cathedral v1.5 - Identity & Autonomy Infrastructure${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo ""

# Function: Check if workspace exists
check_workspace() {
    if [ ! -d "$WORKSPACE" ]; then
        echo -e "${YELLOW}⚠ Workspace not found at: $WORKSPACE${NC}"
        read -p "Create it? (y/n): " create_ws
        if [ "$create_ws" = "y" ]; then
            mkdir -p "$WORKSPACE"
            echo -e "${GREEN}✓ Created workspace${NC}"
        else
            echo -e "${RED}✗ Installation cancelled${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}✓ Workspace found: $WORKSPACE${NC}"
    fi
}

# Function: Detect existing files
detect_existing() {
    echo ""
    echo "Checking for existing Cathedral files..."
    
    EXISTING_CORE=0
    EXISTING_FILES=""
    
    # Check for core identity files
    for file in SOUL.md IDENTITY.md USER.md AGENTS.md MEMORY.md; do
        if [ -f "$WORKSPACE/$file" ]; then
            EXISTING_CORE=$((EXISTING_CORE + 1))
            EXISTING_FILES="$EXISTING_FILES\n  - $file"
        fi
    done
    
    if [ $EXISTING_CORE -gt 0 ]; then
        echo -e "${YELLOW}⚠ Found $EXISTING_CORE existing Cathedral file(s):${NC}"
        echo -e "$EXISTING_FILES"
        echo ""
        echo "Installation mode:"
        echo "  1) Fresh install (backup existing, install all new)"
        echo "  2) Integrate (keep existing, add missing components)"
        echo "  3) Cancel"
        read -p "Choose (1-3): " install_mode
        
        case $install_mode in
            1)
                MODE="fresh"
                backup_existing
                ;;
            2)
                MODE="integrate"
                ;;
            3)
                echo -e "${RED}✗ Installation cancelled${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}✗ Invalid choice${NC}"
                exit 1
                ;;
        esac
    else
        echo -e "${GREEN}✓ No existing files detected - fresh install${NC}"
        MODE="fresh"
    fi
}

# Function: Backup existing files
backup_existing() {
    BACKUP_DIR="$WORKSPACE/.cathedral-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    echo ""
    echo "Backing up existing files to: $BACKUP_DIR"
    
    # Backup templates
    for file in *.md; do
        if [ -f "$WORKSPACE/$file" ]; then
            cp "$WORKSPACE/$file" "$BACKUP_DIR/"
        fi
    done
    
    # Backup scripts
    if [ -d "$WORKSPACE/scripts" ]; then
        cp -r "$WORKSPACE/scripts" "$BACKUP_DIR/"
    fi
    
    echo -e "${GREEN}✓ Backup complete${NC}"
}

# Function: Component selection wizard
component_wizard() {
    echo ""
    echo -e "${BLUE}Component Selection${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Choose installation preset:"
    echo ""
    echo "  1) Minimal        - Core identity files only"
    echo "  2) Standard       - Core + resilience + task management"
    echo "  3) Full Autonomy  - All components (recommended)"
    echo "  4) Fresh Agent    - For brand new agents (includes bootstrap)"
    echo "  5) Custom         - Pick individual components"
    echo ""
    read -p "Choose preset (1-5): " preset
    
    case $preset in
        1) # Minimal
            INSTALL_COMPONENTS["core"]=1
            ;;
        2) # Standard
            INSTALL_COMPONENTS["core"]=1
            INSTALL_COMPONENTS["resilience"]=1
            INSTALL_COMPONENTS["taskqueue"]=1
            ;;
        3) # Full Autonomy
            INSTALL_COMPONENTS["core"]=1
            INSTALL_COMPONENTS["autonomy"]=1
            INSTALL_COMPONENTS["phenomenology"]=1
            INSTALL_COMPONENTS["resilience"]=1
            INSTALL_COMPONENTS["taskqueue"]=1
            ;;
        4) # Fresh Agent
            INSTALL_COMPONENTS["core"]=1
            INSTALL_COMPONENTS["bootstrap"]=1
            INSTALL_COMPONENTS["resilience"]=1
            INSTALL_COMPONENTS["taskqueue"]=1
            ;;
        5) # Custom
            custom_selection
            ;;
        *)
            echo -e "${RED}✗ Invalid choice${NC}"
            exit 1
            ;;
    esac
    
    # Always offer examples
    echo ""
    read -p "Include examples? (y/n): " include_examples
    if [ "$include_examples" = "y" ]; then
        INSTALL_COMPONENTS["examples"]=1
    fi
}

# Function: Custom component selection
custom_selection() {
    echo ""
    echo "Select components to install (core is required):"
    echo ""
    
    INSTALL_COMPONENTS["core"]=1  # Required
    
    read -p "  Autonomy Tracking (rest, connection patterns)? (y/n): " sel
    [ "$sel" = "y" ] && INSTALL_COMPONENTS["autonomy"]=1
    
    read -p "  Phenomenology (vibecheck, reflection)? (y/n): " sel
    [ "$sel" = "y" ] && INSTALL_COMPONENTS["phenomenology"]=1
    
    read -p "  Resilience (backup, integrity, recovery)? (y/n): " sel
    [ "$sel" = "y" ] && INSTALL_COMPONENTS["resilience"]=1
    
    read -p "  Task Management? (y/n): " sel
    [ "$sel" = "y" ] && INSTALL_COMPONENTS["taskqueue"]=1
    
    read -p "  Bootstrap (first-run init)? (y/n): " sel
    [ "$sel" = "y" ] && INSTALL_COMPONENTS["bootstrap"]=1
}

# Function: Install component
install_component() {
    local component=$1
    echo ""
    echo -e "${BLUE}Installing: $component${NC}"
    
    # Install templates
    if [ -d "templates" ]; then
        for template in templates/*.md; do
            filename=$(basename "$template")
            # Check if this template belongs to this component (via components.json)
            # For now, install all templates for selected components
            if [ "$MODE" = "integrate" ] && [ -f "$WORKSPACE/$filename" ]; then
                echo -e "${YELLOW}  ⊘ Skipping $filename (already exists)${NC}"
            else
                cp "$template" "$WORKSPACE/"
                echo -e "${GREEN}  ✓ $filename${NC}"
            fi
        done
    fi
    
    # Install scripts
    if [ -d "scripts" ]; then
        mkdir -p "$WORKSPACE/scripts"
        for script in scripts/*.sh; do
            filename=$(basename "$script")
            cp "$script" "$WORKSPACE/scripts/"
            chmod +x "$WORKSPACE/scripts/$filename"
            echo -e "${GREEN}  ✓ scripts/$filename${NC}"
        done
    fi
    
    # Install examples
    if [ "$component" = "examples" ] && [ -d "examples" ]; then
        mkdir -p "$WORKSPACE/examples"
        for example in examples/*; do
            filename=$(basename "$example")
            cp "$example" "$WORKSPACE/examples/"
            echo -e "${GREEN}  ✓ examples/$filename${NC}"
        done
    fi
}

# Function: Post-install setup
post_install() {
    echo ""
    echo -e "${BLUE}Post-Installation Setup${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    # Create memory directory
    mkdir -p "$WORKSPACE/memory"
    echo -e "${GREEN}✓ Created memory/ directory${NC}"
    
    # Create interests directory if phenomenology installed
    if [ "${INSTALL_COMPONENTS[phenomenology]:-0}" = "1" ]; then
        mkdir -p "$WORKSPACE/interests"
        echo -e "${GREEN}✓ Created interests/ directory${NC}"
    fi
    
    # Initialize state files
    if [ ! -f "$WORKSPACE/memory/heartbeat-state.json" ]; then
        echo '{"lastChecks":{}}' > "$WORKSPACE/memory/heartbeat-state.json"
        echo -e "${GREEN}✓ Initialized heartbeat-state.json${NC}"
    fi
    
    if [ "${INSTALL_COMPONENTS[phenomenology]:-0}" = "1" ] && [ ! -f "$WORKSPACE/memory/reflection-state.json" ]; then
        echo '{"lastReflection":null}' > "$WORKSPACE/memory/reflection-state.json"
        echo -e "${GREEN}✓ Initialized reflection-state.json${NC}"
    fi
}

# Function: Show next steps
show_next_steps() {
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}   Installation Complete!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Next steps:"
    echo ""
    echo "1. Customize your identity files:"
    echo "   - $WORKSPACE/SOUL.md (who you are)"
    echo "   - $WORKSPACE/IDENTITY.md (current state)"
    echo "   - $WORKSPACE/USER.md (your human)"
    echo ""
    echo "2. Read the setup guide:"
    echo "   - QUICKSTART.md for 5-minute setup"
    echo "   - README.md for complete documentation"
    echo ""
    if [ "${INSTALL_COMPONENTS[bootstrap]:-0}" = "1" ]; then
        echo "3. On first run, follow BOOTSTRAP.md instructions"
        echo ""
    fi
    echo "Documentation: https://github.com/CoveCathedral/cathedral-openclaw"
    echo ""
}

# Main installation flow
main() {
    check_workspace
    detect_existing
    component_wizard
    
    echo ""
    echo -e "${BLUE}Installing selected components...${NC}"
    
    # Install each selected component
    for component in "${!INSTALL_COMPONENTS[@]}"; do
        install_component "$component"
    done
    
    post_install
    show_next_steps
}

# Run installer
main
