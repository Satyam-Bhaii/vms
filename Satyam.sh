#!/bin/bash

# ==========================================
# PIXLE CORE - ULTRA MODERN EDITION
# ==========================================
# 
# ███████╗██╗  ██╗ ██████╗ ███████╗
# ██╔════╝╚██╗██╔╝██╔════╝ ██╔════╝
# ███████╗ ╚███╔╝ ██║  ███╗█████╗  
# ╚════██║ ██╔██╗ ██║   ██║██╔══╝  
# ███████║██╔╝ ██╗╚██████╔╝███████╗
# ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝
#           MADE BY SATYAM
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
B_RED='\033[1;38;5;196m'
B_PINK='\033[1;38;5;207m'
B_CYAN='\033[1;38;5;51m'
B_GREEN='\033[1;38;5;82m'
B_YELLOW='\033[1;38;5;226m'
B_WHITE='\033[1;38;5;255m'
B_BLUE='\033[1;38;5;39m'
NC='\033[0m'
BOLD='\033[1m'

# --- Gradient Text Function ---
gradient_text() {
    local text="$1"
    local len=${#text}
    local colors=("$B_RED" "$B_PINK" "$B_PURPLE" "$B_CYAN" "$B_BLUE" "$B_GREEN")
    for ((i=0; i<len; i++)); do
        local color_idx=$((i % ${#colors[@]}))
        echo -ne "${colors[$color_idx]}${text:$i:1}${NC}"
    done
    echo ""
}

# --- Loading Animation ---
modern_loading() {
    local duration="${1:-2}"
    local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
    local end_time=$((SECONDS + duration))
    
    while [ $SECONDS -lt $end_time ]; do
        for frame in "${frames[@]}"; do
            printf "\r    ${B_CYAN}%s${NC} ${B_WHITE}Loading...${NC}" "$frame"
            sleep 0.05
        done
    done
    printf "\r    ${B_GREEN}✓${NC} ${B_WHITE}Ready!          ${NC}\n"
    sleep 0.3
}

# --- Progress Bar ---
progress_bar() {
    local width=${1:-40}
    local label="${2:-Progress}"
    echo -ne "    ${B_WHITE}$label:${NC} ["
    for ((i=0; i<=width; i++)); do
        local pct=$((i * 100 / width))
        printf "\r    ${B_WHITE}$label:${NC} ["
        if [ $i -gt 0 ]; then
            echo -ne "${B_GREEN}"
            for ((j=0; j<i; j++)); do printf "█"; done
            echo -ne "${NC}"
        fi
        for ((j=i; j<width; j++)); do printf "░"; done
        echo -ne "] ${pct}%"
        sleep 0.02
    done
    echo ""
}

# --- Animated Banner ---
animated_banner() {
    clear
    echo -e "${B_PURPLE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${B_PURPLE}║${NC}                                                      ${B_PURPLE}║${NC}"
    echo -e "${B_PURPLE}║${NC}  ${B_RED}█${B_PINK}█${B_PURPLE}█${B_CYAN}█${B_BLUE}█${B_GREEN}█  ${B_WHITE}PIXLE CORE${NC}  ${B_PURPLE}|${NC}  ${B_CYAN}ULTRA EDITION v3.0${NC}          ${B_PURPLE}║${NC}"
    echo -e "${B_PURPLE}║${NC}  ${B_RED}█${B_PINK}█${B_PURPLE}█${B_CYAN}█${B_BLUE}█${B_GREEN}█  ${B_WHITE}NEXT-GEN VPS MANAGER${NC}                          ${B_PURPLE}║${NC}"
    echo -e "${B_PURPLE}║${NC}                                                      ${B_PURPLE}║${NC}"
    echo -e "${B_PURPLE}╠══════════════════════════════════════════════════════════╣${NC}"
    echo -e "${B_PURPLE}║${NC}  ${B_GREEN}●${NC} System Ready    ${B_YELLOW}●${NC} Multi-VM    ${B_CYAN}●${NC} Cloud-Init    ${B_PURPLE}║${NC}"
    echo -e "${B_PURPLE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "    ${GRAY}╭──────────────────────────────────────────────╮${NC}"
    echo -e "    ${GRAY}│${NC}  ${B_CYAN}███████╗██╗  ██╗ ██████╗ ███████╗${NC}          ${GRAY}│${NC}"
    echo -e "    ${GRAY}│${NC}  ${B_CYAN}██╔════╝╚██╗██╔╝██╔════╝ ██╔════╝${NC}          ${GRAY}│${NC}"
    echo -e "    ${GRAY}│${NC}  ${B_CYAN}███████╗ ╚███╔╝ ██║  ███╗█████╗  ${NC}          ${GRAY}│${NC}"
    echo -e "    ${GRAY}│${NC}  ${B_CYAN}╚════██║ ██╔██╗ ██║   ██║██╔══╝  ${NC}          ${GRAY}│${NC}"
    echo -e "    ${GRAY}│${NC}  ${B_CYAN}███████║██╔╝ ██╗╚██████╔╝███████╗${NC}          ${GRAY}│${NC}"
    echo -e "    ${GRAY}│${NC}  ${B_CYAN}╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝${NC}          ${GRAY}│${NC}"
    echo -e "    ${GRAY}│${NC}           ${B_PINK}MADE BY SATYAM${NC}                      ${GRAY}│${NC}"
    echo -e "    ${GRAY}╰──────────────────────────────────────────────╯${NC}"
    echo ""
}

# --- Menu Option with Icons ---
menu_option() {
    local num="$1"
    local icon="$2"
    local text="$3"
    local desc="$4"
    echo -e "    ${B_PURPLE}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "    ${B_PURPLE}│${NC}  ${B_CYAN}[$num]${NC} ${icon} ${B_WHITE}$text${NC}"
    echo -e "    ${B_PURPLE}│${NC}      ${GRAY}$desc${NC}$(printf '%*s' $((48 - ${#desc})))${NC}"
    echo -e "    ${B_PURPLE}└─────────────────────────────────────────────────────────┘${NC}"
}

# --- System Info Display ---
show_system_info() {
    local cpu_cores=$(nproc 2>/dev/null || echo "N/A")
    local mem_total=$(free -h 2>/dev/null | awk '/^Mem:/{print $2}' || echo "N/A")
    local disk_free=$(df -h ~ 2>/dev/null | awk 'NR==2{print $4}' || echo "N/A")
    
    echo -e "    ${B_PURPLE}┌─────────────────────────────────────────────────────┐${NC}"
    echo -e "    ${B_PURPLE}│${NC}  ${B_CYAN}SYSTEM STATUS:${NC}"
    echo -e "    ${B_PURPLE}│${NC}  ${B_GREEN}CPU:${NC} $cpu_cores cores  ${B_BLUE}RAM:${NC} $mem_total  ${B_YELLOW}DISK:${NC} $disk_free"
    echo -e "    ${B_PURPLE}└─────────────────────────────────────────────────────┘${NC}"
    echo ""
}

# --- Main Logic ---
GRAY='\033[38;5;240m'

animated_banner
modern_loading 1
show_system_info

while true; do
    animated_banner
    show_system_info

    echo -e "    ${B_WHITE}╭─────────────────────────────────────────────╮${NC}"
    echo -e "    ${B_WHITE}│${NC}  ${B_PURPLE}MAIN MENU${NC}                                    ${B_WHITE}│${NC}"
    echo -e "    ${B_WHITE}╰─────────────────────────────────────────────╯${NC}"
    echo ""
    
    menu_option "01" "🚀" "LAUNCH VPS MAKER" "Create & manage virtual machines"
    menu_option "02" "⚙️" "SYSTEM SETTINGS" "Configure preferences"
    menu_option "03" "📊" "RESOURCE MONITOR" "View system resources"
    menu_option "04" "❌" "EXIT" "Close application"
    echo ""

    echo -ne "    ${B_CYAN}└─❯${NC} ${B_WHITE}Select option:${NC} "
    read choice

    case $choice in
        1|01)
            echo -e "\n    ${B_CYAN}⚡ Connecting to VPS Engine...${NC}"
            progress_bar 30 "Initializing"
            sleep 0.5
            bash <(curl -s https://raw.githubusercontent.com/Satyam-Bhaii/pixleninja/main/vpsmaker.sh)
            echo -e "\n    ${B_WHITE}Press ${B_GREEN}[ENTER]${B_WHITE} to return...${NC}"
            read
            ;;
        2|02)
            echo -e "\n    ${B_YELLOW}⚠️  Settings panel coming soon!${NC}"
            sleep 1.5
            ;;
        3|03)
            clear
            echo -e "\n    ${B_CYAN}═══ SYSTEM RESOURCES ═══${NC}\n"
            echo -e "    ${B_WHITE}CPU Cores:${NC} $(nproc 2>/dev/null || echo 'N/A')"
            echo -e "    ${B_WHITE}Memory:${NC} $(free -h 2>/dev/null | grep Mem || echo 'N/A')"
            echo -e "    ${B_WHITE}Disk Usage:${NC}\n"
            df -h ~ 2>/dev/null | head -2
            echo -e "\n    ${B_WHITE}Press ${B_GREEN}[ENTER]${B_WHITE} to return...${NC}"
            read
            ;;
        4|04)
            echo -e "\n    ${B_PINK}Shutting down PIXLE CORE...${NC}"
            progress_bar 20 "Closing"
            echo -e "    ${B_CYAN}Goodbye! 👋${NC}\n"
            exit 0
            ;;
        *)
            echo -e "\n    ${B_RED}❌ Invalid selection!${NC}"
            sleep 1
            ;;
    esac
done
