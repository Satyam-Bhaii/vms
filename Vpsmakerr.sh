#!/bin/bash
set -euo pipefail

# ==========================================
# MULTI-VM MANAGER - ULTRA MODERN EDITION
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

# --- Configuration ---
VM_DIR="$HOME/vms"
SNAPSHOT_DIR="$VM_DIR/.snapshots"
VERSION="3.0.0"

# ==========================================
# UI FUNCTIONS
# ==========================================

display_header() {
    clear
    echo -e "${B_PURPLE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${B_PURPLE}║${NC}  ${B_RED}█${B_PINK}█${B_PURPLE}█${B_CYAN}█${B_BLUE}█${B_GREEN}█  ${B_WHITE}VM MANAGER PRO${NC}  ${B_PURPLE}|${NC}  ${B_CYAN}v${VERSION}${NC}                 ${B_PURPLE}║${NC}"
    echo -e "${B_PURPLE}║${NC}  ${B_RED}█${B_PINK}█${B_PURPLE}█${B_CYAN}█${B_BLUE}█${B_GREEN}█  ${B_WHITE}ADVANCED VM ENGINE${NC}  ${B_PURPLE}|${NC}  ${B_YELLOW}PIXLE CORE${NC}            ${B_PURPLE}║${NC}"
    echo -e "${B_PURPLE}╠══════════════════════════════════════════════════════════╣${NC}"
    echo -e "${B_PURPLE}║${NC}  ${B_GREEN}●${NC} KVM Enabled  ${B_CYAN}●${NC} Cloud-Init  ${B_YELLOW}●${NC} Snapshots  ${B_PURPLE}║${NC}"
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

print_status() {
    local type=$1
    local msg=$2
    case $type in
        "INFO")    echo -e "    ${B_CYAN}➤${NC} ${B_WHITE}$msg${NC}" ;;
        "SUCCESS") echo -e "    ${B_GREEN}✓${NC} ${B_GREEN}$msg${NC}" ;;
        "WARN")    echo -e "    ${B_YELLOW}⚠${NC} ${B_YELLOW}$msg${NC}" ;;
        "ERROR")   echo -e "    ${B_RED}✗${NC} ${B_RED}$msg${NC}" ;;
        "INPUT")   echo -ne "    ${B_CYAN}└─❯${NC} ${B_WHITE}$msg:${NC} " ;;
    esac
}

progress_bar() {
    local width=${1:-40}
    local label="${2:-Progress}"
    local color="${3:-$B_CYAN}"
    local duration="${4:-1}"
    local steps=$((width / duration / 10))
    [ $steps -lt 1 ] && steps=1
    
    echo -ne "    ${B_WHITE}$label:${NC} ["
    for ((i=0; i<=width; i+=steps)); do
        local pct=$((i * 100 / width))
        printf "\r    ${B_WHITE}$label:${NC} ["
        if [ $i -gt 0 ]; then
            echo -ne "$color"
            for ((j=0; j<i/steps; j++)); do printf "█"; done
            echo -ne "${NC}"
        fi
        for ((j=i/steps; j<width/steps; j++)); do printf "░"; done
        echo -ne "] ${pct}%"
        sleep 0.05
    done
    printf "\r    ${B_WHITE}$label:${NC} ["
    echo -ne "$color"
    for ((j=0; j<width/steps; j++)); do printf "█"; done
    echo -ne "${NC}] 100%"
    echo ""
}

menu_option() {
    local num="$1"
    local icon="$2"
    local text="$3"
    echo -e "    ${B_PURPLE}┌────────────────────────────────────────────────────┐${NC}"
    echo -e "    ${B_PURPLE}│${NC}  ${B_CYAN}[$num]${NC} ${icon} ${B_WHITE}$text${NC}$(printf '%*s' $((42 - ${#text})))${B_PURPLE}│${NC}"
    echo -e "    ${B_PURPLE}└────────────────────────────────────────────────────┘${NC}"
}

# ==========================================
# SYSTEM FUNCTIONS
# ==========================================

check_dependencies() {
    print_status "INFO" "Checking system dependencies..."
    sleep 0.5
    
    local missing=()
    local deps=("qemu-system-x86_64" "wget" "cloud-localds" "qemu-img" "lsof" "virsh")
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing+=("$dep")
        fi
    done
    
    if [ ${#missing[@]} -gt 0 ]; then
        print_status "WARN" "Missing packages: ${missing[*]}"
        echo -e ""
        print_status "INFO" "Installing missing dependencies..."
        progress_bar 30 "Installing" "$B_GREEN" 2
        
        if command -v apt &> /dev/null; then
            sudo apt update -qq && sudo apt install -y -qq qemu-system cloud-image-utils wget curl lsof libvirt-daemon-system
        elif command -v yum &> /dev/null; then
            sudo yum install -y qemu-kvm libvirt wget curl cloud-utils
        else
            print_status "ERROR" "Package manager not detected. Please install manually."
            sleep 2
        fi
        
        print_status "SUCCESS" "Dependencies installed!"
        sleep 1
    else
        print_status "SUCCESS" "All dependencies found!"
        sleep 0.5
    fi
    
    # Create directories
    mkdir -p "$VM_DIR" "$SNAPSHOT_DIR"
}

get_vm_list() {
    find "$VM_DIR" -name "*.conf" -maxdepth 1 2>/dev/null | sort | xargs -I {} basename {} .conf
}

is_vm_running() {
    local vm_name=$1
    pgrep -f "qemu-system.*$vm_name" >/dev/null 2>&1 && return 0
    return 1
}

get_vm_status() {
    local vm_name=$1
    if is_vm_running "$vm_name"; then
        echo -e "${B_GREEN}RUNNING${NC}"
    else
        echo -e "${B_RED}STOPPED${NC}"
    fi
}

load_vm_config() {
    local vm_name=$1
    local config_file="$VM_DIR/$vm_name.conf"
    if [[ -f "$config_file" ]]; then
        source "$config_file"
        return 0
    fi
    return 1
}

save_vm_config() {
    cat > "$VM_DIR/$VM_NAME.conf" <<EOF
# VM Configuration - PIXLE CORE v${VERSION}
VM_NAME="$VM_NAME"
OS_TYPE="$OS_TYPE"
HOSTNAME="$HOSTNAME"
USERNAME="$USERNAME"
PASSWORD="$PASSWORD"
DISK_SIZE="$DISK_SIZE"
MEMORY="$MEMORY"
CPUS="$CPUS"
SSH_PORT="$SSH_PORT"
GUI_MODE="$GUI_MODE"
IMG_FILE="$IMG_FILE"
SEED_FILE="$SEED_FILE"
CREATED="$(date '+%Y-%m-%d %H:%M:%S')"
LAST_STARTED=""
EOF
}

# ==========================================
# VM OPERATIONS
# ==========================================

setup_vm_image() {
    print_status "INFO" "Preparing system image for $VM_NAME..."
    mkdir -p "$VM_DIR"

    # Download if not exists
    if [[ ! -f "$IMG_FILE" ]]; then
        print_status "INFO" "Downloading ${OS_TYPE} cloud image..."
        wget -q --show-progress "$IMG_URL" -O "$IMG_FILE" || {
            print_status "ERROR" "Failed to download image"
            return 1
        }
    fi

    # Resize disk
    print_status "INFO" "Resizing disk to $DISK_SIZE..."
    qemu-img resize "$IMG_FILE" "$DISK_SIZE" 2>/dev/null || true

    # Create cloud-init config
    print_status "INFO" "Generating cloud-init configuration..."
    
    cat > /tmp/user-data-$VM_NAME <<EOF
#cloud-config
hostname: $HOSTNAME
ssh_pwauth: true
package_update: true
packages:
  - openssh-server
  - sudo
  - curl
  - wget
  - git
users:
  - name: $USERNAME
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    password: $(openssl passwd -6 "$PASSWORD" 2>/dev/null || echo "$PASSWORD")
    lock_passwd: false
chpasswd:
  expire: false
EOF
    
    cat > /tmp/meta-data-$VM_NAME <<EOF
instance-id: iid-$VM_NAME
local-hostname: $HOSTNAME
EOF

    cloud-localds "$SEED_FILE" /tmp/user-data-$VM_NAME /tmp/meta-data-$VM_NAME 2>/dev/null || {
        print_status "WARN" "cloud-localds not available, creating basic ISO"
        # Fallback: create a simple ISO
        mkisofs -output "$SEED_FILE" -volid cidata -joliet -rock \
            /tmp/user-data-$VM_NAME /tmp/meta-data-$VM_NAME 2>/dev/null || true
    }
    
    rm -f /tmp/user-data-$VM_NAME /tmp/meta-data-$VM_NAME
    
    print_status "SUCCESS" "VM image prepared successfully!"
}

create_vm() {
    display_header
    print_status "INFO" "CREATE NEW VIRTUAL MACHINE"
    echo ""
    
    # OS Selection
    echo -e "    ${B_WHITE}╭─────────────────────────────────────────────╮${NC}"
    echo -e "    ${B_WHITE}│${NC}  ${B_PURPLE}SELECT OPERATING SYSTEM${NC}                    ${B_WHITE}│${NC}"
    echo -e "    ${B_WHITE}╰─────────────────────────────────────────────╯${NC}"
    echo ""
    echo -e "    ${B_CYAN}[1]${NC} ${B_WHITE}Ubuntu 24.04 LTS${NC}     (Recommended)"
    echo -e "    ${B_CYAN}[2]${NC} ${B_WHITE}Debian 12${NC}"
    echo -e "    ${B_CYAN}[3]${NC} ${B_WHITE}Fedora 40${NC}"
    echo -e "    ${B_CYAN}[4]${NC} ${B_WHITE}AlmaLinux 9${NC}"
    echo ""
    
    echo -ne "    ${B_CYAN}└─❯${NC} ${B_WHITE}OS Choice:${NC} "
    read os_choice
    
    case $os_choice in
        1) OS_TYPE="Ubuntu"; IMG_URL="https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img" ;;
        2) OS_TYPE="Debian"; IMG_URL="https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2" ;;
        3) OS_TYPE="Fedora"; IMG_URL="https://download.fedoraproject.org/pub/fedora/linux/releases/40/Cloud/x86_64/images/Fedora-Cloud-Base-40-1.14.x86_64.qcow2" ;;
        4) OS_TYPE="AlmaLinux"; IMG_URL="https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-latest.x86_64.qcow2" ;;
        *) OS_TYPE="Ubuntu"; IMG_URL="https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img" ;;
    esac

    echo ""
    print_status "INFO" "Selected: ${B_GREEN}$OS_TYPE${NC}"
    echo ""
    
    # VM Configuration
    echo -e "    ${B_WHITE}╭─────────────────────────────────────────────╮${NC}"
    echo -e "    ${B_WHITE}│${NC}  ${B_PURPLE}VM CONFIGURATION${NC}                            ${B_WHITE}│${NC}"
    echo -e "    ${B_WHITE}╰─────────────────────────────────────────────╯${NC}"
    echo ""
    
    print_status "INPUT" "VM Name" && read VM_NAME
    HOSTNAME="$VM_NAME"
    
    print_status "INPUT" "Username (default: user)" && read USERNAME
    USERNAME=${USERNAME:-user}
    
    print_status "INPUT" "Password" && read -s PASSWORD && echo
    [ -z "$PASSWORD" ] && PASSWORD="pixle123"
    
    print_status "INPUT" "Disk Size (e.g., 20G, default: 20G)" && read DISK_SIZE
    DISK_SIZE=${DISK_SIZE:-20G}
    
    print_status "INPUT" "RAM MB (default: 2048)" && read MEMORY
    MEMORY=${MEMORY:-2048}
    
    print_status "INPUT" "CPU Cores (default: 2)" && read CPUS
    CPUS=${CPUS:-2}
    
    print_status "INPUT" "SSH Port (default: 2222)" && read SSH_PORT
    SSH_PORT=${SSH_PORT:-2222}
    
    GUI_MODE=false
    IMG_FILE="$VM_DIR/$VM_NAME.img"
    SEED_FILE="$VM_DIR/$VM_NAME-seed.iso"

    echo ""
    print_status "INFO" "Creating VM..."
    progress_bar 40 "Setting up" "$B_GREEN" 2
    
    setup_vm_image
    save_vm_config
    
    echo ""
    print_status "SUCCESS" "VM '$VM_NAME' created successfully!"
    echo -e "    ${B_WHITE}SSH: ${B_GREEN}ssh $USERNAME@localhost -p $SSH_PORT${NC}"
    echo -e "    ${B_WHITE}Password: ${B_YELLOW}$PASSWORD${NC}"
    echo -ne "\n    ${B_WHITE}Press ${B_GREEN}[ENTER]${B_WHITE} to continue...${NC}"
    read
}

start_vm() {
    local vm_name=$1
    display_header
    
    if ! load_vm_config "$vm_name"; then
        print_status "ERROR" "VM configuration not found"
        sleep 2
        return 1
    fi
    
    if is_vm_running "$vm_name"; then
        print_status "WARN" "VM is already running"
        sleep 2
        return 0
    fi
    
    print_status "INFO" "Starting VM: $vm_name"
    progress_bar 30 "Booting" "$B_GREEN"
    
    # Update last started time
    sed -i "s/LAST_STARTED=.*/LAST_STARTED=\"$(date '+%Y-%m-%d %H:%M:%S')\"/" "$VM_DIR/$vm_name.conf"
    
    # Start QEMU
    qemu-system-x86_64 -enable-kvm \
        -m "$MEMORY" \
        -smp "$CPUS" \
        -cpu host \
        -drive "file=$IMG_FILE,format=qcow2,if=virtio" \
        -drive "file=$SEED_FILE,format=raw,if=virtio" \
        -netdev "user,id=n0,hostfwd=tcp::$SSH_PORT-:22" \
        -device virtio-net-pci,netdev=n0 \
        -nographic -serial mon:stdio &
    
    print_status "SUCCESS" "VM started on port $SSH_PORT"
    sleep 2
}

stop_vm() {
    local vm_name=$1
    display_header
    
    if ! load_vm_config "$vm_name"; then
        print_status "ERROR" "VM configuration not found"
        sleep 2
        return 1
    fi
    
    if ! is_vm_running "$vm_name"; then
        print_status "WARN" "VM is not running"
        sleep 2
        return 0
    fi
    
    print_status "INFO" "Stopping VM: $vm_name"
    pkill -f "qemu-system.*$vm_name" 2>/dev/null || true
    
    progress_bar 20 "Stopping" "$B_RED"
    print_status "SUCCESS" "VM stopped"
    sleep 2
}

delete_vm() {
    local vm_name=$1
    display_header
    
    print_status "WARN" "DELETE VM: $vm_name"
    echo -e "    ${B_RED}This action cannot be undone!${NC}"
    echo ""
    print_status "INPUT" "Type '$vm_name' to confirm" && read confirm
    
    if [ "$confirm" = "$vm_name" ]; then
        if is_vm_running "$vm_name"; then
            pkill -f "qemu-system.*$vm_name" 2>/dev/null || true
        fi
        
        rm -f "$VM_DIR/$vm_name"*.img "$VM_DIR/$vm_name"*.iso "$VM_DIR/$vm_name.conf"
        rm -f "$SNAPSHOT_DIR/$vm_name"*.qcow2
        
        print_status "SUCCESS" "VM deleted successfully"
    else
        print_status "WARN" "Deletion cancelled"
    fi
    sleep 2
}

# ==========================================
# SNAPSHOT SYSTEM
# ==========================================

create_snapshot() {
    local vm_name=$1
    display_header
    
    print_status "INFO" "CREATE SNAPSHOT: $vm_name"
    echo ""
    
    if ! load_vm_config "$vm_name"; then
        print_status "ERROR" "VM not found"
        sleep 2
        return 1
    fi
    
    print_status "INPUT" "Snapshot name" && read snap_name
    snap_name=${snap_name:-$(date +%Y%m%d_%H%M%S)}
    
    mkdir -p "$SNAPSHOT_DIR"
    
    if [ -f "$IMG_FILE" ]; then
        print_status "INFO" "Creating snapshot..."
        qemu-img create -f qcow2 -b "$IMG_FILE" -F qcow2 "$SNAPSHOT_DIR/${vm_name}-${snap_name}.qcow2"
        print_status "SUCCESS" "Snapshot created: $snap_name"
    else
        print_status "ERROR" "VM disk not found"
    fi
    sleep 2
}

list_snapshots() {
    local vm_name=$1
    display_header
    
    print_status "INFO" "SNAPSHOTS FOR: $vm_name"
    echo ""
    
    local snaps=($(ls "$SNAPSHOT_DIR/${vm_name}"*.qcow2 2>/dev/null))
    
    if [ ${#snaps[@]} -gt 0 ]; then
        echo -e "    ${B_WHITE}┌────────────────────────────────────────┐${NC}"
        echo -e "    ${B_WHITE}│  SNAPSHOT NAME                         │${NC}"
        echo -e "    ${B_WHITE}├────────────────────────────────────────┤${NC}"
        for snap in "${snaps[@]}"; do
            local name=$(basename "$snap")
            printf "    ${B_WHITE}│${NC}  %-36s  ${B_WHITE}│${NC}\n" "$name"
        done
        echo -e "    ${B_WHITE}└────────────────────────────────────────┘${NC}"
    else
        print_status "INFO" "No snapshots found"
    fi
    
    echo -ne "\n    ${B_WHITE}Press ${B_GREEN}[ENTER]${B_WHITE} to continue...${NC}"
    read
}

restore_snapshot() {
    local vm_name=$1
    display_header
    
    print_status "INFO" "RESTORE SNAPSHOT: $vm_name"
    echo ""
    
    local snaps=($(ls "$SNAPSHOT_DIR/${vm_name}"*.qcow2 2>/dev/null))
    
    if [ ${#snaps[@]} -eq 0 ]; then
        print_status "WARN" "No snapshots available"
        sleep 2
        return 1
    fi
    
    echo -e "    ${B_WHITE}Available snapshots:${NC}"
    for i in "${!snaps[@]}"; do
        echo -e "    ${B_CYAN}$((i+1))${NC} $(basename "${snaps[$i]}")"
    done
    echo ""
    
    print_status "INPUT" "Select snapshot number" && read snap_idx
    
    if [ "$snap_idx" -le "${#snaps[@]}" ] && [ "$snap_idx" -gt 0 ]; then
        local selected="${snaps[$((snap_idx-1))]}"
        print_status "INFO" "Restoring from $(basename "$selected")..."
        
        if is_vm_running "$vm_name"; then
            stop_vm "$vm_name"
        fi
        
        cp "$selected" "$IMG_FILE"
        print_status "SUCCESS" "Snapshot restored!"
    else
        print_status "WARN" "Invalid selection"
    fi
    sleep 2
}

# ==========================================
# VM LIST DISPLAY
# ==========================================

show_vm_list() {
    local vms=($(get_vm_list))
    
    if [ ${#vms[@]} -gt 0 ]; then
        echo -e "    ${B_PURPLE}┌────────┬────────────────────────┬──────────┬─────────┐${NC}"
        echo -e "    ${B_PURPLE}│${NC}  ${B_WHITE}ID${NC}    ${B_PURPLE}│${NC}  ${B_WHITE}VM NAME               ${NC}${B_PURPLE}│${NC}  ${B_WHITE}PORT    ${NC}${B_PURPLE}│${NC}  ${B_WHITE}STATUS ${NC}${B_PURPLE}│${NC}"
        echo -e "    ${B_PURPLE}├────────┼────────────────────────┼──────────┼─────────┤${NC}"
        for i in "${!vms[@]}"; do
            load_vm_config "${vms[$i]}" &>/dev/null || true
            local status=$(get_vm_status "${vms[$i]}")
            printf "    ${B_PURPLE}│${NC}  %02d     ${B_PURPLE}│${NC}  %-20s    ${B_PURPLE}│${NC}  %-7s ${B_PURPLE}│${NC}  %b     ${B_PURPLE}│${NC}\n" \
                $((i+1)) "${vms[$i]}" "${SSH_PORT:-N/A}" "$status"
        done
        echo -e "    ${B_PURPLE}└────────┴────────────────────────┴──────────┴─────────┘${NC}"
    else
        echo -e "    ${B_YELLOW}⚠ No VMs configured. Create one to get started!${NC}"
    fi
}

# ==========================================
# RESOURCE MONITOR
# ==========================================

show_resources() {
    display_header
    
    echo -e "    ${B_WHITE}╭─────────────────────────────────────────────╮${NC}"
    echo -e "    ${B_WHITE}│${NC}  ${B_PURPLE}SYSTEM RESOURCE MONITOR${NC}                    ${B_WHITE}│${NC}"
    echo -e "    ${B_WHITE}╰─────────────────────────────────────────────╯${NC}"
    echo ""
    
    # CPU Info
    local cpu_cores=$(nproc 2>/dev/null || echo "N/A")
    local cpu_model=$(grep "model name" /proc/cpuinfo 2>/dev/null | head -1 | cut -d: -f2 | xargs || echo "N/A")
    echo -e "    ${B_CYAN}CPU:${NC}"
    echo -e "        Model: ${B_WHITE}$cpu_model${NC}"
    echo -e "        Cores: ${B_GREEN}$cpu_cores${NC}"
    echo ""
    
    # Memory Info
    echo -e "    ${B_CYAN}MEMORY:${NC}"
    free -h 2>/dev/null | awk 'NR==2{printf "        Total: %s\n        Used: %s\n        Free: %s\n", $2, $3, $4}' || echo "        N/A"
    echo ""
    
    # Disk Info
    echo -e "    ${B_CYAN}DISK:${NC}"
    df -h ~ 2>/dev/null | awk 'NR==2{printf "        Total: %s\n        Used: %s\n        Free: %s\n", $2, $3, $4}' || echo "        N/A"
    echo ""
    
    # VM Count
    local vm_count=$(get_vm_list | wc -l)
    local running_count=0
    for vm in $(get_vm_list); do
        is_vm_running "$vm" && ((running_count++))
    done
    
    echo -e "    ${B_CYAN}VIRTUAL MACHINES:${NC}"
    echo -e "        Total VMs: ${B_WHITE}$vm_count${NC}"
    echo -e "        Running: ${B_GREEN}$running_count${NC}"
    echo -e "        Stopped: $((vm_count - running_count))"
    echo ""
    
    echo -ne "    ${B_WHITE}Press ${B_GREEN}[ENTER]${B_WHITE} to continue...${NC}"
    read
}

# ==========================================
# MAIN LOOP
# ==========================================

check_dependencies

while true; do
    display_header
    show_vm_list
    
    echo ""
    echo -e "    ${B_PURPLE}▼ CONTROLS${NC}"
    menu_option "N" "➕" "CREATE NEW VM"
    menu_option "S" "▶️" "START VM"
    menu_option "P" "⏸️" "STOP VM"
    menu_option "D" "🗑️" "DELETE VM"
    menu_option "C" "📸" "SNAPSHOT MENU"
    menu_option "R" "📊" "RESOURCE MONITOR"
    menu_option "X" "🚪" "EXIT"
    echo ""
    
    print_status "INPUT" "Command" && read cmd
    
    case ${cmd,,} in
        n)
            create_vm
            ;;
        s)
            print_status "INPUT" "VM ID to Start" && read id
            vms=($(get_vm_list))
            if [ "$id" -le "${#vms[@]}" ] 2>/dev/null; then
                start_vm "${vms[$((id-1))]}"
            else
                print_status "ERROR" "Invalid ID"
                sleep 1
            fi
            ;;
        p)
            print_status "INPUT" "VM ID to Stop" && read id
            vms=($(get_vm_list))
            if [ "$id" -le "${#vms[@]}" ] 2>/dev/null; then
                stop_vm "${vms[$((id-1))]}"
            else
                print_status "ERROR" "Invalid ID"
                sleep 1
            fi
            ;;
        d)
            print_status "INPUT" "VM ID to Delete" && read id
            vms=($(get_vm_list))
            if [ "$id" -le "${#vms[@]}" ] 2>/dev/null; then
                delete_vm "${vms[$((id-1))]}"
            else
                print_status "ERROR" "Invalid ID"
                sleep 1
            fi
            ;;
        c)
            display_header
            echo -e "    ${B_WHITE}╭─────────────────────────────────────────────╮${NC}"
            echo -e "    ${B_WHITE}│${NC}  ${B_PURPLE}SNAPSHOT MANAGER${NC}                          ${B_WHITE}│${NC}"
            echo -e "    ${B_WHITE}╰─────────────────────────────────────────────╯${NC}"
            echo ""
            echo -e "    ${B_CYAN}[1]${NC} Create Snapshot"
            echo -e "    ${B_CYAN}[2]${NC} List Snapshots"
            echo -e "    ${B_CYAN}[3]${NC} Restore Snapshot"
            echo ""
            print_status "INPUT" "Option" && read snap_opt
            
            vms=($(get_vm_list))
            if [ ${#vms[@]} -eq 0 ]; then
                print_status "WARN" "No VMs available"
                sleep 2
                continue
            fi
            
            echo ""
            print_status "INPUT" "VM ID" && read vm_id
            
            if [ "$vm_id" -le "${#vms[@]}" ] 2>/dev/null; then
                vm_name="${vms[$((vm_id-1))]}"
                case $snap_opt in
                    1) create_snapshot "$vm_name" ;;
                    2) list_snapshots "$vm_name" ;;
                    3) restore_snapshot "$vm_name" ;;
                esac
            fi
            ;;
        r)
            show_resources
            ;;
        x)
            echo -e "\n    ${B_PINK}Shutting down VM Manager...${NC}"
            progress_bar 20 "Closing" "$B_PURPLE"
            echo -e "    ${B_CYAN}Goodbye! 👋${NC}\n"
            exit 0
            ;;
        *)
            echo -e "\n    ${B_RED}✗ Invalid command!${NC}"
            sleep 1
            ;;
    esac
done
