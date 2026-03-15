#!/bin/bash

# ==========================================
# PIXLE CORE - QUICK INSTALLER
# ==========================================
# 
# ███████╗██╗  ██╗ ██████╗ ███████╗
# ██╔════╝╚██╗██╔╝██╔════╝ ██╔════╝
# ███████╗ ╚███╔╝ ██║  ███╗█████╗  
# ╚════██║ ██╔██╗ ██║   ██║██╔══╝  
# ███████║██╔╝ ██╗╚██████╔╝███████╗
# ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝
#           MADE BY TRS
# ==========================================
#
# Run Command:
# bash <(curl -s https://raw.githubusercontent.com/Satyam-Bhaii/vms/main/install.sh)
#
# Or with wget:
# bash <(wget -qO- https://raw.githubusercontent.com/Satyam-Bhaii/vms/main/install.sh)
#
# ==========================================

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# --- Trap for Clean Exit ---
cleanup() {
    echo -e "\n${YELLOW}Installation cancelled.${NC}"
    exit 0
}
trap cleanup SIGINT SIGTERM

# --- ASCII Banner ---
show_banner() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║           ██████╗ ██╗██╗  ██╗██╗     ███████╗            ║"
    echo "║           ██╔══██╗██║╚██╗██╔╝██║     ██╔════╝            ║"
    echo "║           ██████╔╝██║ ╚███╔╝ ██║     █████╗              ║"
    echo "║           ██╔═══╝ ██║ ██╔██╗ ██║     ██╔══╝              ║"
    echo "║           ██║     ██║██╔╝ ██╗███████╗███████╗            ║"
    echo "║           ╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝            ║"
    echo "║                                                            ║"
    echo "║              ${WHITE}PIXLE CORE - INSTALLER${CYAN}                    ║"
    echo "║              ${WHITE}MADE BY TRS${CYAN}                                 ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# --- Progress Bar ---
progress() {
    local duration=$1
    local msg=$2
    local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
    local end=$((SECONDS + duration))
    
    echo -ne "${CYAN}$msg${NC} "
    while [ $SECONDS -lt $end ]; do
        for frame in "${frames[@]}"; do
            printf "\r${CYAN}%s${NC} $msg..." "$frame"
            sleep 0.05
        done
    done
    echo -e "\r${GREEN}✓${NC} $msg... ${GREEN}Done!${NC}"
}

# --- Check Root ---
check_root() {
    if [ $EUID -ne 0 ]; then
        echo -e "${YELLOW}⚠ This script needs sudo privileges${NC}"
        echo -ne "${CYAN}Continue? [y/n]:${NC} "
        read -r confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            exit 0
        fi
    fi
}

# --- Check OS ---
check_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$NAME
        echo -e "${WHITE}Detected OS:${NC} $OS"
    else
        OS="Unknown"
        echo -e "${YELLOW}⚠ Could not detect OS${NC}"
    fi
}

# --- Install Dependencies ---
install_deps() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${WHITE}Installing Dependencies...${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    progress 2 "Updating package lists"
    
    if command -v apt &> /dev/null; then
        sudo apt update -qq
        progress 5 "Installing packages"
        sudo apt install -y -qq curl wget git qemu-system qemu-utils cloud-image-utils lsof
    elif command -v yum &> /dev/null; then
        progress 5 "Installing packages"
        sudo yum install -y -q curl wget git qemu-kvm qemu-img cloud-utils
    elif command -v pacman &> /dev/null; then
        progress 5 "Installing packages"
        sudo pacman -S --noconfirm curl wget git qemu-full cloud-utils
    else
        echo -e "${RED}✗ Package manager not found!${NC}"
        echo -e "${YELLOW}Please install manually: curl, wget, qemu-system, cloud-image-utils${NC}"
        sleep 3
        return 1
    fi
    
    echo ""
    echo -e "${GREEN}✓ All dependencies installed!${NC}"
    sleep 1
}

# --- Check KVM ---
check_kvm() {
    echo ""
    if [ -e /dev/kvm ]; then
        echo -e "${GREEN}✓ KVM is enabled and ready!${NC}"
    else
        echo -e "${YELLOW}⚠ KVM not detected${NC}"
        echo -e "${WHITE}Virtualization may not work properly${NC}"
        echo -e "${CYAN}To enable KVM:${NC}"
        echo "  sudo modprobe kvm"
        echo "  sudo modprobe kvm_intel  # For Intel"
        echo "  sudo modprobe kvm_amd    # For AMD"
        sleep 3
    fi
}

# --- Create Directory ---
setup_dir() {
    echo ""
    INSTALL_DIR="$HOME/pixle-core"
    
    if [ -d "$INSTALL_DIR" ]; then
        echo -e "${YELLOW}⚠ PIXLE CORE already exists${NC}"
        echo -ne "${CYAN}Overwrite? [y/n]:${NC} "
        read -r overwrite
        if [[ "$overwrite" =~ ^[Yy]$ ]]; then
            rm -rf "$INSTALL_DIR"
            progress 1 "Removing old installation"
        else
            echo -e "${YELLOW}Installation cancelled${NC}"
            exit 0
        fi
    fi
    
    mkdir -p "$INSTALL_DIR"
    progress 1 "Creating installation directory"
}

# --- Download Scripts ---
download_scripts() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${WHITE}Downloading PIXLE CORE...${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    cd "$INSTALL_DIR"
    
    # GitHub Raw URL
    RAW_URL="https://raw.githubusercontent.com/Satyam-Bhaii/vms/main"
    
    progress 2 "Downloading Satyam.sh"
    curl -sL "$RAW_URL/Satyam.sh" -o Satyam.sh
    
    progress 2 "Downloading vpsmaker.sh"
    curl -sL "$RAW_URL/vpsmaker.sh" -o vpsmaker.sh
    
    progress 2 "Downloading Vpsmakerr.sh"
    curl -sL "$RAW_URL/Vpsmakerr.sh" -o Vpsmakerr.sh
    
    progress 1 "Setting permissions"
    chmod +x *.sh
    
    # Create VM directories
    mkdir -p ~/vms/.snapshots
    
    echo ""
    echo -e "${GREEN}✓ All scripts downloaded!${NC}"
}

# --- Create Alias ---
setup_alias() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${WHITE}Setting up shortcut...${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    ALIAS_CMD="alias pixle='cd $INSTALL_DIR && bash Satyam.sh'"
    
    if grep -q "alias pixle=" ~/.bashrc 2>/dev/null; then
        echo -e "${YELLOW}⚠ Pixle alias already exists${NC}"
    else
        echo "$ALIAS_CMD" >> ~/.bashrc
        echo -e "${GREEN}✓ Alias added to ~/.bashrc${NC}"
        echo -e "${WHITE}You can now type ${CYAN}'pixle'${WHITE} to launch!${NC}"
    fi
    
    # Also add to .zshrc if exists
    if [ -f ~/.zshrc ]; then
        if ! grep -q "alias pixle=" ~/.zshrc 2>/dev/null; then
            echo "$ALIAS_CMD" >> ~/.zshrc
            echo -e "${GREEN}✓ Alias also added to ~/.zshrc${NC}"
        fi
    fi
}

# --- Show Info ---
show_info() {
    clear
    show_banner
    
    echo ""
    echo -e "${CYAN}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}          ${WHITE}INSTALLATION COMPLETE!${CYAN}                    ${NC}"
    echo -e "${CYAN}╠══════════════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC}                                              ${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}✓${NC} Installation Directory: ${CYAN}~/pixle-core${NC}       ${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}✓${NC} VM Storage: ${CYAN}~/vms${NC}                         ${NC}"
    echo -e "${CYAN}║${NC}                                              ${NC}"
    echo -e "${CYAN}║${NC}  ${WHITE}LAUNCH COMMANDS:${NC}                           ${NC}"
    echo -e "${CYAN}║${NC}                                              ${NC}"
    echo -e "${CYAN}║${NC}  ${CYAN}Option 1:${NC} Type ${WHITE}'pixle'${NC}                      ${NC}"
    echo -e "${CYAN}║${NC}  ${CYAN}Option 2:${NC} ${WHITE}cd ~/pixle-core && bash Satyam.sh${NC}  ${NC}"
    echo -e "${CYAN}║${NC}  ${CYAN}Option 3:${NC} ${WHITE}bash ~/pixle-core/Satyam.sh${NC}        ${NC}"
    echo -e "${CYAN}║${NC}                                              ${NC}"
    echo -e "${CYAN}║${NC}  ${WHITE}ONLINE COMMAND:${NC}                          ${NC}"
    echo -e "${CYAN}║${NC}  ${WHITE}bash <(curl -s https://raw.githubusercontent.com/${NC} ${NC}"
    echo -e "${CYAN}║${NC}                    ${WHITE}Satyam-Bhaii/vms/main/Satyam.sh)${NC}       ${NC}"
    echo -e "${CYAN}║${NC}                                              ${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Launch prompt
    echo -ne "${CYAN}Launch PIXLE CORE now? [y/n]:${NC} "
    read -r launch
    
    if [[ "$launch" =~ ^[Yy]$ ]]; then
        cd "$INSTALL_DIR"
        bash Satyam.sh
    else
        echo -e "\n${WHITE}To launch later, type:${NC} ${CYAN}pixle${NC}"
        echo -e "${GREEN}Goodbye! 👋${NC}\n"
    fi
}

# --- Main ---
main() {
    show_banner
    echo ""
    echo -e "${WHITE}Welcome to PIXLE Core Installer!${NC}"
    echo -e "${WHITE}This will install the complete VPS management system${NC}"
    echo ""
    
    check_root
    check_os
    install_deps
    check_kvm
    setup_dir
    download_scripts
    setup_alias
    show_info
}

# Run
main
