#!/bin/bash

# ==========================================
# MULTI-VM MANAGER - NO KVM EDITION
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
# For systems without KVM support

set -euo pipefail

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
NC='\033[0m'

# --- Configuration ---
VM_DIR="$HOME/vms"
VERSION="1.0.0"

# ==========================================
# UI FUNCTIONS
# ==========================================

display_header() {
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
    echo "║        ${WHITE}PIXLE CORE - NO KVM EDITION${CYAN}                      ║"
    echo "║        ${WHITE}MADE BY TRS${CYAN}                                       ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_status() {
    local type=$1
    local msg=$2
    case $type in
        "INFO")    echo -e "${CYAN}➤${NC} ${WHITE}$msg${NC}" ;;
        "SUCCESS") echo -e "${GREEN}✓${NC} ${GREEN}$msg${NC}" ;;
        "WARN")    echo -e "${YELLOW}⚠${NC} ${YELLOW}$msg${NC}" ;;
        "ERROR")   echo -e "${RED}✗${NC} ${RED}$msg${NC}" ;;
        "INPUT")   echo -ne "${CYAN}└─❯${NC} ${WHITE}$msg:${NC} " ;;
    esac
}

# ==========================================
# SYSTEM FUNCTIONS
# ==========================================

check_dependencies() {
    local missing=()
    local deps=("qemu-system-x86_64" "wget" "cloud-localds" "qemu-img")
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing+=("$dep")
        fi
    done
    
    if [ ${#missing[@]} -gt 0 ]; then
        print_status "ERROR" "Missing: ${missing[*]}"
        echo -e "${WHITE}Install with: sudo apt install qemu-system cloud-image-utils wget${NC}"
        return 1
    fi
    return 0
}

get_vm_list() {
    if [ -d "$VM_DIR" ]; then
        find "$VM_DIR" -maxdepth 1 -name "*.conf" -type f 2>/dev/null | sort | while read -r f; do 
            basename "$f" .conf
        done
    fi
}

is_vm_running() {
    local vm_name=$1
    pgrep -f "qemu.*$vm_name" >/dev/null 2>&1
}

get_vm_status() {
    local vm_name=$1
    if is_vm_running "$vm_name"; then
        echo -e "${GREEN}RUNNING${NC}"
    else
        echo -e "${GRAY}STOPPED${NC}"
    fi
}

load_vm_config() {
    local vm_name=$1
    local config_file="$VM_DIR/$vm_name.conf"
    if [[ -f "$config_file" ]]; then
        # shellcheck source=/dev/null
        source "$config_file"
        return 0
    fi
    return 1
}

save_vm_config() {
    cat > "$VM_DIR/$VM_NAME.conf" <<EOF
# VM Configuration - PIXLE CORE NO KVM
VM_NAME="$VM_NAME"
OS_TYPE="$OS_TYPE"
CODENAME="$CODENAME"
HOSTNAME="$HOSTNAME"
USERNAME="$USERNAME"
PASSWORD="$PASSWORD"
DISK_SIZE="$DISK_SIZE"
MEMORY="$MEMORY"
CPUS="$CPUS"
SSH_PORT="$SSH_PORT"
GUI_MODE="$GUI_MODE"
PORT_FORWARDS="${PORT_FORWARDS:-}"
IMG_FILE="$IMG_FILE"
SEED_FILE="$SEED_FILE"
CREATED="$(date '+%Y-%m-%d %H:%M:%S')"
EOF
}

validate_input() {
    local type=$1
    local value=$2
    
    case $type in
        "name")
            [[ "$value" =~ ^[a-zA-Z][a-zA-Z0-9_-]*$ ]]
            ;;
        "port")
            [[ "$value" =~ ^[0-9]+$ ]] && [ "$value" -ge 1 ] && [ "$value" -le 65535 ]
            ;;
        "size")
            [[ "$value" =~ ^[0-9]+[GMT]$ ]]
            ;;
        "number")
            [[ "$value" =~ ^[0-9]+$ ]]
            ;;
        *)
            return 0
            ;;
    esac
}

# ==========================================
# VM OPERATIONS
# ==========================================

create_vm() {
    display_header
    print_status "INFO" "CREATE NEW VIRTUAL MACHINE"
    print_status "WARN" "NO KVM MODE - Performance will be slower"
    echo ""
    
    # OS Selection
    echo -e "${WHITE}Select Operating System:${NC}"
    echo "  1) Ubuntu 24.04 LTS (Noble)"
    echo "  2) Ubuntu 22.04 LTS (Jammy)"
    echo "  3) Debian 12 (Bookworm)"
    echo "  4) Debian 11 (Bullseye)"
    echo "  5) Fedora 40"
    echo "  6) AlmaLinux 9"
    echo ""
    
    echo -ne "${CYAN}└─❯${NC} ${WHITE}OS Choice:${NC} "
    read -r os_choice
    
    case $os_choice in
        1) OS_TYPE="Ubuntu"; CODENAME="noble"; IMG_URL="https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img" ;;
        2) OS_TYPE="Ubuntu"; CODENAME="jammy"; IMG_URL="https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img" ;;
        3) OS_TYPE="Debian"; CODENAME="bookworm"; IMG_URL="https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2" ;;
        4) OS_TYPE="Debian"; CODENAME="bullseye"; IMG_URL="https://cloud.debian.org/images/cloud/bullseye/latest/debian-11-generic-amd64.qcow2" ;;
        5) OS_TYPE="Fedora"; CODENAME="40"; IMG_URL="https://download.fedoraproject.org/pub/fedora/linux/releases/40/Cloud/x86_64/images/Fedora-Cloud-Base-40-1.14.x86_64.qcow2" ;;
        6) OS_TYPE="AlmaLinux"; CODENAME="9"; IMG_URL="https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-latest.x86_64.qcow2" ;;
        *) print_status "ERROR" "Invalid selection"; sleep 1; return 1 ;;
    esac

    echo ""
    print_status "INFO" "Selected: ${GREEN}$OS_TYPE $CODENAME${NC}"
    echo ""
    
    # VM Configuration
    echo -e "${WHITE}╭─────────────────────────────────────────────╮${NC}"
    echo -e "${WHITE}│${NC}  ${CYAN}VM CONFIGURATION${NC}                              ${WHITE}│${NC}"
    echo -e "${WHITE}╰─────────────────────────────────────────────╯${NC}"
    echo ""
    
    # VM Name
    while true; do
        print_status "INPUT" "VM Name" && read -r VM_NAME
        if validate_input "name" "$VM_NAME"; then
            break
        fi
        print_status "ERROR" "Invalid name. Use letters, numbers, - or _"
    done
    
    HOSTNAME="$VM_NAME"
    
    # Username
    while true; do
        print_status "INPUT" "Username (default: user)" && read -r USERNAME
        USERNAME=${USERNAME:-user}
        if [[ "$USERNAME" =~ ^[a-z][a-z0-9_-]*$ ]]; then
            break
        fi
        print_status "ERROR" "Invalid username. Lowercase letters only"
    done
    
    # Password
    print_status "INPUT" "Password" && read -s PASSWORD && echo
    PASSWORD=${PASSWORD:-"trs123"}
    
    # Disk Size
    while true; do
        print_status "INPUT" "Disk Size (e.g., 20G, default: 20G)" && read -r DISK_SIZE
        DISK_SIZE=${DISK_SIZE:-20G}
        if validate_input "size" "$DISK_SIZE"; then
            break
        fi
        print_status "ERROR" "Invalid size. Use format: 20G, 50G, 100G"
    done
    
    # Memory (lower default for no-KVM)
    while true; do
        print_status "INPUT" "RAM MB (default: 1024)" && read -r MEMORY
        MEMORY=${MEMORY:-1024}
        if validate_input "number" "$MEMORY" && [ "$MEMORY" -ge 512 ]; then
            break
        fi
        print_status "ERROR" "Invalid RAM. Minimum 512MB"
    done
    
    # CPU Cores
    while true; do
        print_status "INPUT" "CPU Cores (default: 1)" && read -r CPUS
        CPUS=${CPUS:-1}
        if validate_input "number" "$CPUS" && [ "$CPUS" -ge 1 ]; then
            break
        fi
        print_status "ERROR" "Invalid CPU count"
    done
    
    # SSH Port
    while true; do
        print_status "INPUT" "SSH Port (default: 2222)" && read -r SSH_PORT
        SSH_PORT=${SSH_PORT:-2222}
        if validate_input "port" "$SSH_PORT"; then
            if ! lsof -i :"$SSH_PORT" &>/dev/null; then
                break
            fi
            print_status "ERROR" "Port $SSH_PORT already in use"
        else
            print_status "ERROR" "Invalid port (1-65535)"
        fi
    done
    
    GUI_MODE=false
    IMG_FILE="$VM_DIR/$VM_NAME.img"
    SEED_FILE="$VM_DIR/$VM_NAME-seed.iso"

    echo ""
    print_status "INFO" "Creating VM..."
    
    # Create directory
    mkdir -p "$VM_DIR"

    # Download image
    if [[ ! -f "$IMG_FILE" ]]; then
        print_status "INFO" "Downloading ${OS_TYPE} ${CODENAME}..."
        wget -q --show-progress "$IMG_URL" -O "$IMG_FILE" || {
            print_status "ERROR" "Download failed"
            return 1
        }
    fi

    # Resize disk
    qemu-img resize "$IMG_FILE" "$DISK_SIZE" 2>/dev/null || true

    # Create cloud-init config
    print_status "INFO" "Generating cloud-init configuration..."
    
    local encrypted_pass
    encrypted_pass=$(openssl passwd -6 "$PASSWORD" 2>/dev/null || echo "$PASSWORD")
    
    cat > /tmp/user-data-"$VM_NAME" <<EOF
#cloud-config
hostname: $HOSTNAME
ssh_pwauth: true
package_update: true
packages:
  - openssh-server
  - sudo
  - curl
  - wget
users:
  - name: $USERNAME
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    password: $encrypted_pass
    lock_passwd: false
chpasswd:
  expire: false
EOF
    
    cat > /tmp/meta-data-"$VM_NAME" <<EOF
instance-id: iid-$VM_NAME
local-hostname: $HOSTNAME
EOF

    cloud-localds "$SEED_FILE" /tmp/user-data-"$VM_NAME" /tmp/meta-data-"$VM_NAME" 2>/dev/null || {
        print_status "WARN" "cloud-localds failed"
    }
    
    rm -f /tmp/user-data-"$VM_NAME" /tmp/meta-data-"$VM_NAME"
    
    save_vm_config
    
    echo ""
    print_status "SUCCESS" "VM '$VM_NAME' created successfully!"
    echo -e "${WHITE}SSH: ${GREEN}ssh $USERNAME@localhost -p $SSH_PORT${NC}"
    echo -e "${WHITE}Password: ${YELLOW}$PASSWORD${NC}"
    echo -ne "\n${WHITE}Press ${GREEN}[ENTER]${WHITE} to continue...${NC}"
    read -r
}

start_vm() {
    display_header
    
    print_status "INPUT" "VM Name to Start" && read -r vm_name
    
    if ! load_vm_config "$vm_name"; then
        print_status "ERROR" "VM not found"
        sleep 2
        return 1
    fi
    
    if is_vm_running "$vm_name"; then
        print_status "WARN" "VM is already running"
        sleep 2
        return 0
    fi
    
    print_status "INFO" "Starting VM: $vm_name (NO KVM)"
    
    # Build port forwards
    local netdev_opts="user,id=n0,hostfwd=tcp::$SSH_PORT-:22"
    if [ -n "${PORT_FORWARDS:-}" ]; then
        netdev_opts="$netdev_opts,$PORT_FORWARDS"
    fi
    
    # Start QEMU WITHOUT KVM
    qemu-system-x86_64 \
        -m "$MEMORY" \
        -smp "$CPUS" \
        -drive "file=$IMG_FILE,format=qcow2,if=virtio" \
        -drive "file=$SEED_FILE,format=raw,if=virtio" \
        -netdev "$netdev_opts" \
        -device virtio-net-pci,netdev=n0 \
        -nographic -serial mon:stdio &
    
    local vm_pid=$!
    echo "$vm_pid" > "$VM_DIR/$vm_name.pid"
    
    print_status "SUCCESS" "VM started (PID: $vm_pid)"
    print_status "WARN" "Running without KVM - performance will be slower"
    sleep 2
}

stop_vm() {
    display_header
    
    print_status "INPUT" "VM Name to Stop" && read -r vm_name
    
    if ! load_vm_config "$vm_name"; then
        print_status "ERROR" "VM not found"
        sleep 2
        return 1
    fi
    
    if ! is_vm_running "$vm_name"; then
        print_status "WARN" "VM is not running"
        sleep 2
        return 0
    fi
    
    print_status "INFO" "Stopping VM: $vm_name"
    pkill -f "qemu.*$vm_name" 2>/dev/null || true
    rm -f "$VM_DIR/$vm_name.pid"
    
    print_status "SUCCESS" "VM stopped"
    sleep 2
}

show_vm_info() {
    display_header
    
    print_status "INPUT" "VM Name" && read -r vm_name
    
    if ! load_vm_config "$vm_name"; then
        print_status "ERROR" "VM not found"
        sleep 2
        return 1
    fi
    
    echo ""
    echo -e "${WHITE}╭─────────────────────────────────────────────╮${NC}"
    echo -e "${WHITE}│${NC}  ${CYAN}VM INFORMATION${NC}                                ${WHITE}│${NC}"
    echo -e "${WHITE}╰─────────────────────────────────────────────╯${NC}"
    echo ""
    echo -e "  ${CYAN}Name:${NC}        $VM_NAME"
    echo -e "  ${CYAN}OS:${NC}          $OS_TYPE $CODENAME"
    echo -e "  ${CYAN}Hostname:${NC}    $HOSTNAME"
    echo -e "  ${CYAN}Username:${NC}    $USERNAME"
    echo -e "  ${CYAN}SSH Port:${NC}    $SSH_PORT"
    echo -e "  ${CYAN}Memory:${NC}      $MEMORY MB"
    echo -e "  ${CYAN}CPUs:${NC}        $CPUS"
    echo -e "  ${CYAN}Disk:${NC}        $DISK_SIZE"
    echo -e "  ${CYAN}Status:${NC}      $(get_vm_status "$vm_name")"
    echo ""
    echo -e "${WHITE}Press ${GREEN}[ENTER]${WHITE} to continue...${NC}"
    read -r
}

edit_vm_config() {
    display_header
    
    print_status "INPUT" "VM Name to Edit" && read -r vm_name
    
    if ! load_vm_config "$vm_name"; then
        print_status "ERROR" "VM not found"
        sleep 2
        return 1
    fi
    
    while true; do
        display_header
        echo -e "${WHITE}╭─────────────────────────────────────────────╮${NC}"
        echo -e "${WHITE}│${NC}  ${CYAN}EDIT VM CONFIGURATION${NC}                         ${WHITE}│${NC}"
        echo -e "${WHITE}╰─────────────────────────────────────────────╯${NC}"
        echo ""
        echo "  1) Hostname       5) SSH Port"
        echo "  2) Username       6) Memory (RAM)"
        echo "  3) Password       7) CPU Count"
        echo "  4) Disk Size      0) Back"
        echo ""
        
        echo -ne "${CYAN}└─❯${NC} ${WHITE}Option:${NC} "
        read -r opt
        
        case $opt in
            1)
                print_status "INPUT" "New Hostname" && read -r HOSTNAME
                ;;
            2)
                print_status "INPUT" "New Username" && read -r USERNAME
                ;;
            3)
                print_status "INPUT" "New Password" && read -s PASSWORD && echo
                PASSWORD=$(openssl passwd -6 "$PASSWORD" 2>/dev/null || echo "$PASSWORD")
                ;;
            4)
                print_status "INPUT" "New Disk Size (e.g., 30G)" && read -r DISK_SIZE
                qemu-img resize "$IMG_FILE" "$DISK_SIZE" 2>/dev/null && \
                    print_status "SUCCESS" "Disk resized" || \
                    print_status "ERROR" "Resize failed"
                sleep 1
                ;;
            5)
                print_status "INPUT" "New SSH Port" && read -r SSH_PORT
                ;;
            6)
                print_status "INPUT" "New RAM (MB)" && read -r MEMORY
                ;;
            7)
                print_status "INPUT" "New CPU Count" && read -r CPUS
                ;;
            0)
                break
                ;;
            *)
                print_status "ERROR" "Invalid option"
                sleep 1
                continue
                ;;
        esac
        
        save_vm_config
        print_status "SUCCESS" "Configuration updated"
        sleep 1
    done
}

delete_vm() {
    display_header
    
    print_status "INPUT" "VM Name to Delete" && read -r vm_name
    
    echo ""
    print_status "WARN" "DELETE VM: $vm_name"
    echo -e "${RED}This action cannot be undone!${NC}"
    echo ""
    print_status "INPUT" "Type '$vm_name' to confirm" && read -r confirm
    
    if [ "$confirm" = "$vm_name" ]; then
        if is_vm_running "$vm_name"; then
            pkill -f "qemu.*$vm_name" 2>/dev/null || true
        fi
        
        rm -f "$VM_DIR/$vm_name"*.img "$VM_DIR/$vm_name"*.iso \
              "$VM_DIR/$vm_name.conf" "$VM_DIR/$vm_name.pid"
        
        print_status "SUCCESS" "VM deleted"
    else
        print_status "WARN" "Deletion cancelled"
    fi
    sleep 2
}

resize_disk() {
    display_header
    
    print_status "INPUT" "VM Name" && read -r vm_name
    
    if ! load_vm_config "$vm_name"; then
        print_status "ERROR" "VM not found"
        sleep 2
        return 1
    fi
    
    echo ""
    print_status "WARN" "Resizing disk for: $vm_name"
    echo -e "${YELLOW}⚠ Shrinking disks can cause data loss!${NC}"
    echo ""
    
    print_status "INPUT" "New Size (e.g., 40G)" && read -r new_size
    
    if validate_input "size" "$new_size"; then
        qemu-img resize "$IMG_FILE" "$new_size" && \
            print_status "SUCCESS" "Disk resized to $new_size" || \
            print_status "ERROR" "Resize failed"
    else
        print_status "ERROR" "Invalid size format"
    fi
    
    sleep 2
}

show_performance() {
    display_header
    
    echo -e "${WHITE}╭─────────────────────────────────────────────╮${NC}"
    echo -e "${WHITE}│${NC}  ${CYAN}SYSTEM PERFORMANCE${NC}                            ${WHITE}│${NC}"
    echo -e "${WHITE}╰─────────────────────────────────────────────╯${NC}"
    echo ""
    
    # CPU
    local cpu_cores
    cpu_cores=$(nproc 2>/dev/null || echo "N/A")
    echo -e "  ${CYAN}CPU Cores:${NC} $cpu_cores"
    
    # Memory
    echo -e "  ${CYAN}Memory:${NC}"
    free -h 2>/dev/null | awk 'NR==2{printf "    Total: %s | Used: %s | Free: %s\n", $2, $3, $4}' || \
        echo "    N/A"
    
    # Disk
    echo -e "  ${CYAN}Disk:${NC}"
    df -h ~ 2>/dev/null | awk 'NR==2{printf "    Total: %s | Used: %s | Free: %s\n", $2, $3, $4}' || \
        echo "    N/A"
    
    # VM Status
    echo ""
    echo -e "  ${CYAN}Running VMs:${NC}"
    local vms
    mapfile -t vms < <(get_vm_list)
    for vm in "${vms[@]}"; do
        if is_vm_running "$vm"; then
            echo -e "    ${GREEN}●${NC} $vm"
        fi
    done
    
    echo ""
    echo -e "${WHITE}Press ${GREEN}[ENTER]${WHITE} to continue...${NC}"
    read -r
}

# ==========================================
# MAIN LOOP
# ==========================================

main() {
    # Check dependencies
    if ! check_dependencies; then
        echo ""
        echo -e "${YELLOW}Install dependencies and run again:${NC}"
        echo "  sudo apt install qemu-system cloud-image-utils wget"
        exit 1
    fi
    
    # Create directories
    mkdir -p "$VM_DIR"
    
    print_status "WARN" "NO KVM MODE - Virtualization disabled"
    sleep 1
    
    while true; do
        display_header
        
        echo -e "${WHITE}Main Menu:${NC}"
        echo "  1) Create a new VM"
        echo "  2) Start a VM"
        echo "  3) Stop a VM"
        echo "  4) Show VM info"
        echo "  5) Edit VM configuration"
        echo "  6) Delete a VM"
        echo "  7) Resize VM disk"
        echo "  8) Show performance"
        echo "  0) Exit"
        echo ""
        
        # List VMs
        local vms
        mapfile -t vms < <(get_vm_list)
        if [ ${#vms[@]} -gt 0 ]; then
            echo -e "${WHITE}Virtual Machines:${NC}"
            for vm in "${vms[@]}"; do
                local status
                status=$(get_vm_status "$vm")
                echo -e "  $status  $vm"
            done
            echo ""
        fi
        
        echo -ne "${CYAN}└─❯${NC} ${WHITE}Select option:${NC} "
        read -r choice
        
        case $choice in
            1) create_vm ;;
            2) start_vm ;;
            3) stop_vm ;;
            4) show_vm_info ;;
            5) edit_vm_config ;;
            6) delete_vm ;;
            7) resize_disk ;;
            8) show_performance ;;
            0)
                echo -e "\n${GREEN}Goodbye! 👋${NC}\n"
                exit 0
                ;;
            *)
                print_status "ERROR" "Invalid option"
                sleep 1
                ;;
        esac
    done
}

# Run
main
