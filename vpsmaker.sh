#!/bin/bash

# ==========================================
# VPS MAKER - ULTRA MODERN EDITION
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

# --- Modern Gradient Colors ---
RED='\033[38;5;196m'
PINK='\033[38;5;207m'
PURPLE='\033[38;5;141m'
CYAN='\033[38;5;51m'
BLUE='\033[38;5;39m'
GREEN='\033[38;5;82m'
YELLOW='\033[38;5;226m'
ORANGE='\033[38;5;214m'
WHITE='\033[38;5;255m'
GRAY='\033[38;5;240m'
B_RED='\033[1;38;5;196m'
B_PINK='\033[1;38;5;207m'
B_CYAN='\033[1;38;5;51m'
B_GREEN='\033[1;38;5;82m'
B_YELLOW='\033[1;38;5;226m'
B_WHITE='\033[1;38;5;255m'
B_BLUE='\033[1;38;5;39m'
B_PURPLE='\033[1;38;5;141m'
NC='\033[0m'

# --- Trap for Clean Exit ---
cleanup() {
    echo -e "\n    ${B_PINK}Exiting...${NC}"
    tput cnorm
    exit 0
}
trap cleanup SIGINT SIGTERM

# --- Header ---
print_header() {
    clear
    echo -e "${B_PURPLE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${B_PURPLE}║${NC}  ${B_RED}█${B_PINK}█${B_PURPLE}█${B_CYAN}█${B_BLUE}█${B_GREEN}█  ${B_WHITE}VPS MAKER${NC}  ${B_PURPLE}|${NC}  ${B_CYAN}CONTROL PANEL v3.0${NC}           ${B_PURPLE}║${NC}"
    echo -e "${B_PURPLE}║${NC}  ${B_RED}█${B_PINK}█${B_PURPLE}█${B_CYAN}█${B_BLUE}█${B_GREEN}█  ${B_WHITE}PIXLE CORE${NC}  ${B_PURPLE}|${NC}  ${B_YELLOW}POWERED BY PIXLE${NC}            ${B_PURPLE}║${NC}"
    echo -e "${B_PURPLE}╠══════════════════════════════════════════════════════════╣${NC}"
    echo -e "${B_PURPLE}║${NC}  ${B_GREEN}●${NC} Auto-Setup  ${B_CYAN}●${NC} Cloud-Init  ${B_YELLOW}●${NC} Multi-OS  ${B_PURPLE}║${NC}"
    echo -e "${B_PURPLE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "    ${GRAY}╭──────────────────────────────────────────────╮${NC}"
    echo -e "    ${GRAY}│${NC}  ${B_CYAN}███████╗██╗  ██╗ ██████╗ ███████╗${NC}          ${GRAY}│${NC}"
    echo -e "    ${GRAY}│${NC}  ${B_CYAN}██╔════╝╚██╗██╔╝██╔════╝ ██╔════╝${NC}          ${GRAY}│${NC}"
    echo -e "    ${GRAY}│${NC}  ${B_CYAN}███████╗ ╚███╔╝ ██║  ███╗█████╗  ${NC}          ${GRAY}│${NC}"
    echo -e "    ${GRAY}│${NC}  ${B_CYAN}╚════██║ ██╔██╗ ██║   ██║██╔══╝  ${NC}          ${GRAY}│${NC}"
    echo -e "    ${GRAY}│${NC}  ${B_CYAN}███████║██╔╝ ██╗╚██████╔╝███████╗${NC}          ${GRAY}│${NC}"
    echo -e "    ${GRAY}│${NC}  ${B_CYAN}╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝${NC}          ${GRAY}│${NC}"
    echo -e "    ${GRAY}│${NC}           ${B_PINK}MADE BY TRS${NC}                      ${GRAY}│${NC}"
    echo -e "    ${GRAY}╰──────────────────────────────────────────────╯${NC}"
    echo ""
}

# --- Progress Bar ---
progress_bar() {
    local width=${1:-40}
    local label="${2:-Progress}"
    local color="${3:-$B_CYAN}"
    tput civis
    echo -ne "    ${B_WHITE}$label:${NC} ["
    for ((i=0; i<=width; i++)); do
        local pct=$((i * 100 / width))
        printf "\r    ${B_WHITE}$label:${NC} ["
        if [ $i -gt 0 ]; then
            echo -ne "$color"
            for ((j=0; j<i; j++)); do printf "█"; done
            echo -ne "${NC}"
        fi
        for ((j=i; j<width; j++)); do printf "░"; done
        echo -ne "] ${pct}%"
        sleep 0.02
    done
    tput cnorm
    echo ""
}

# --- Menu Option ---
menu_option() {
    local num="$1"
    local icon="$2"
    local text="$3"
    echo -e "    ${B_PURPLE}┌────────────────────────────────────────────────────┐${NC}"
    echo -e "    ${B_PURPLE}│${NC}  ${B_CYAN}[$num]${NC} ${icon} ${B_WHITE}$text${NC}$(printf '%*s' $((42 - ${#text})))${B_PURPLE}│${NC}"
    echo -e "    ${B_PURPLE}└────────────────────────────────────────────────────┘${NC}"
}

# --- Status Messages ---
print_status() {
    local type=$1
    local msg=$2
    case $type in
        "INFO")    echo -e "    ${B_CYAN}➤${NC} ${B_WHITE}$msg${NC}" ;;
        "SUCCESS") echo -e "    ${B_GREEN}✓${NC} ${B_GREEN}$msg${NC}" ;;
        "WARN")    echo -e "    ${B_YELLOW}⚠${NC} ${B_YELLOW}$msg${NC}" ;;
        "ERROR")   echo -e "    ${B_RED}✗${NC} ${B_RED}$msg${NC}" ;;
    esac
}

# --- Auto Dependency Check ---
check_dependencies() {
    print_status "INFO" "Checking dependencies..."
    sleep 0.5
    
    local missing=()
    local deps=("curl" "wget")
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing+=("$dep")
        fi
    done
    
    if [ ${#missing[@]} -gt 0 ]; then
        print_status "WARN" "Missing: ${missing[*]}"
        echo -e "\n    ${B_WHITE}Install missing dependencies?${NC}"
        echo -ne "    ${B_CYAN}└─❯${NC} ${B_WHITE}[y/n]:${NC} "
        read install
        if [[ "$install" =~ ^[Yy]$ ]]; then
            print_status "INFO" "Installing dependencies..."
            if command -v apt &> /dev/null; then
                sudo apt update -qq && sudo apt install -y -qq "${missing[@]}"
                progress_bar 30 "Installing" "$B_GREEN"
                print_status "SUCCESS" "Dependencies installed!"
            else
                print_status "ERROR" "Package manager not found. Please install manually."
                sleep 2
            fi
        else
            print_status "WARN" "Some features may not work without dependencies"
            sleep 1
        fi
    else
        print_status "SUCCESS" "All dependencies found!"
        sleep 0.5
    fi
}

# --- IDX Setup ---
setup_idx() {
    print_header
    print_status "INFO" "Setting up Google IDX workspace..."
    progress_bar 30 "Configuring"
    
    cd ~ || return
    rm -rf myapp flutter 2>/dev/null
    mkdir -p vps123/.idx && cd vps123/.idx || return

    cat <<EOF > dev.nix
{ pkgs, ... }: {
  channel = "stable-24.05";
  packages = with pkgs; [ 
    unzip openssh git qemu_kvm sudo cdrkit 
    cloud-utils qemu flutter dart-sdk 
    nodejs_20 python3 docker-compose 
  ];
  env = { 
    EDITOR = "nano";
    FLUTTER_HOME = "\$HOME/flutter";
  };
  idx = {
    extensions = [ 
      "Dart-Code.flutter" 
      "Dart-Code.dart-code"
      "ms-vscode.vscode-typescript-next"
    ];
    workspace = { 
      onCreate = { 
        "Install Dependencies" = "flutter pub get";
      }; 
      onStart = { 
        "Start Dev Server" = "flutter run -d chrome";
      }; 
    };
    previews = { enable = true; };
  };
}
EOF
    progress_bar 30 "Finalizing" "$B_GREEN"
    print_status "SUCCESS" "IDX Setup Completed!"
    echo -e "    ${B_WHITE}Path: ${B_GREEN}~/vps123/.idx/dev.nix${NC}"
    echo -ne "\n    ${B_WHITE}Press ${B_GREEN}[ENTER]${B_WHITE} to continue...${NC}"
    read
}

# --- Main Menu ---
check_dependencies

while true; do
    print_header

    echo -e "    ${B_PURPLE}▼ AVAILABLE TOOLS${NC}"
    menu_option "01" "🔧" "IDX TOOL SETUP"
    menu_option "02" "🖥️" "VPS MAKER PRO"
    menu_option "03" "📦" "AUTO DEPLOY"
    menu_option "04" "❌" "EXIT CONSOLE"
    echo ""

    echo -ne "    ${B_CYAN}└─❯${NC} ${B_WHITE}Command:${NC} "
    read op

    case $op in
        1|01)
            setup_idx
            ;;

        2|02)
            print_header
            print_status "INFO" "Launching VPS Engine..."
            progress_bar 20 "Connecting"
            
            if bash <(curl -s https://raw.githubusercontent.com/Satyam-Bhaii/pixleninja/main/Vpsmakerr.sh); then
                echo -e "\n    ${B_GREEN}✓ Session ended.${NC}"
            else
                echo -e "\n    ${B_RED}✗ Failed to load VM Manager.${NC}"
            fi
            
            echo -ne "\n    ${B_WHITE}Press ${B_GREEN}[ENTER]${B_WHITE} to return...${NC}"
            read
            ;;

        3|03)
            print_header
            print_status "INFO" "Auto Deploy Feature"
            echo -e "\n    ${B_WHITE}This will create a pre-configured VM${NC}"
            echo -e "    ${B_WHITE}with default settings.${NC}\n"
            echo -ne "    ${B_CYAN}└─❯${NC} ${B_WHITE}Continue? [y/n]:${NC} "
            read confirm
            if [[ "$confirm" =~ ^[Yy]$ ]]; then
                print_status "INFO" "Deploying default VM..."
                print_status "WARN" "Auto-deploy requires VPS MAKER PRO"
                echo -e "    ${B_WHITE}Please use option 2 for full VM creation.${NC}"
                progress_bar 40 "Preparing" "$B_GREEN"
                print_status "SUCCESS" "Ready for deployment!"
                sleep 2
            fi
            ;;

        4|04)
            echo -e "\n    ${B_PINK}Terminating session...${NC}"
            progress_bar 20 "Closing" "$B_PINK"
            echo -e "    ${B_CYAN}Goodbye! 👋${NC}\n"
            tput cnorm
            exit 0
            ;;

        *)
            echo -e "\n    ${B_RED}✗ Invalid command!${NC}"
            echo -e "    ${B_WHITE}Please enter 1-4${NC}"
            sleep 1.5
            ;;
    esac
done
