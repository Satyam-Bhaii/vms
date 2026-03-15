#!/bin/bash
# PIXLE CORE - Quick Launcher
# Run: bash <(curl -sL https://github.com/Satyam-Bhaii/vms/raw/main/run.sh)

set -e

# Colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════════════════╗"
echo "║              PIXLE CORE - QUICK LAUNCH                   ║"
echo "║                  MADE BY TRS                             ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check if already installed
if [ -d "$HOME/pixle-core" ] && [ -f "$HOME/pixle-core/Satyam.sh" ]; then
    echo -e "${GREEN}✓ Found existing installation${NC}"
    echo -e "${CYAN}Launching...${NC}"
    cd "$HOME/pixle-core"
    bash Satyam.sh
else
    echo -e "${YELLOW}⚠ PIXLE CORE not installed${NC}"
    echo ""
    echo -e "${CYAN}Installing now...${NC}"
    echo ""
    
    # Quick install
    mkdir -p "$HOME/pixle-core"
    cd "$HOME/pixle-core"
    
    echo -ne "${CYAN}⠋${NC} Downloading scripts..."
    curl -sLO https://raw.githubusercontent.com/Satyam-Bhaii/vms/main/Satyam.sh
    curl -sLO https://raw.githubusercontent.com/Satyam-Bhaii/vms/main/vpsmaker.sh
    curl -sLO https://raw.githubusercontent.com/Satyam-Bhaii/vms/main/Vpsmakerr.sh
    chmod +x *.sh
    echo -e "\r${GREEN}✓${NC} Downloading scripts... ${GREEN}Done!${NC}"
    
    echo ""
    echo -e "${GREEN}✓ Installation complete!${NC}"
    echo -e "${CYAN}Launching PIXLE CORE...${NC}"
    echo ""
    
    bash Satyam.sh
fi
