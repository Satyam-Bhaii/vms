# PIXLE CORE - Multi-VM Manager

<div align="center">

**Install VMs on your machine with multiple OS**

*Made by TRS*

</div>

---

## Features

- ✅ **Multi-OS Support** - Ubuntu, Debian, Fedora, AlmaLinux, Rocky, CentOS
- ✅ **Cloud-Init** - Automatic user setup with SSH access
- ✅ **Interactive Menu** - Easy terminal-based UI
- ✅ **VM Management** - Create, Start, Stop, Edit, Delete
- ✅ **Disk Resize** - Expand VM disks on demand
- ✅ **Performance Monitor** - View CPU, RAM, Disk usage
- ✅ **Port Forwarding** - Access VMs via SSH
- ✅ **No KVM Mode** - Works without hardware virtualization

---

## Supported Operating Systems

| OS | Version | Codename |
|----|---------|----------|
| Ubuntu | 24.04 LTS | Noble |
| Ubuntu | 22.04 LTS | Jammy |
| Debian | 12 | Bookworm |
| Debian | 11 | Bullseye |
| Fedora | 40 | - |
| AlmaLinux | 9 | - |
| Rocky Linux | 9 | - |
| CentOS | Stream 9 | - |

---

## Requirements

### System Requirements
- **RAM:** Minimum 2GB (4GB+ recommended)
- **Disk:** 20GB+ free space per VM
- **CPU:** Virtualization support (KVM) preferred

### Software Dependencies

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install -y qemu-system cloud-image-utils wget curl lsof
```

---

## Installation

### Option 1: Direct Launch (GitHub)

```bash
# Main VM Manager (with KVM)
bash <(curl -s https://raw.githubusercontent.com/Satyam-Bhaii/vms/main/vm.sh)

# No KVM Version (for systems without virtualization)
bash <(curl -s https://raw.githubusercontent.com/Satyam-Bhaii/vms/main/nokvm.sh)
```

### Option 2: Clone Repository

```bash
git clone https://github.com/Satyam-Bhaii/vms.git
cd vms
chmod +x vm.sh nokvm.sh
./vm.sh
```

---

## Usage

### Main Menu Options

```
1) Create a new VM       - Create new virtual machine
2) Start a VM            - Launch a created VM
3) Stop a VM             - Gracefully stop running VM
4) Show VM info          - View VM configuration
5) Edit VM configuration - Modify VM settings
6) Delete a VM           - Remove VM permanently
7) Resize VM disk        - Expand disk size
8) Show performance      - Monitor system resources
0) Exit                  - Close application
```

### Create VM Steps

1. Run `./vm.sh`
2. Select option `1) Create a new VM`
3. Choose operating system
4. Enter VM name
5. Set username and password
6. Configure resources (RAM, CPU, Disk)
7. Set SSH port
8. Wait for download and setup
9. Start VM from main menu
10. Connect via SSH

### SSH Connection

```bash
ssh <username>@localhost -p <ssh_port>
# Example: ssh user@localhost -p 2222
```

**Default password:** `trs123` (or your custom password)

---

## Edit VM Configuration

You can modify these settings after creation:

1. **Hostname** - VM hostname
2. **Username** - Login username
3. **Password** - Login password
4. **Disk Size** - Storage capacity
5. **SSH Port** - Host port for SSH
6. **Memory (RAM)** - Allocated RAM
7. **CPU Count** - Number of CPU cores

---

## File Structure

```
~/vms/
├── <vm-name>.conf      # VM configuration file
├── <vm-name>.img       # VM disk image
├── <vm-name>-seed.iso  # Cloud-init configuration
└── <vm-name>.pid       # Process ID (when running)
```

---

## Troubleshooting

### KVM Not Available

If you get KVM errors, use the No KVM version:

```bash
bash <(curl -s https://raw.githubusercontent.com/Satyam-Bhaii/vms/main/nokvm.sh)
```

### Enable KVM (Linux)

```bash
# Check KVM support
lsmod | grep kvm

# Load KVM modules
sudo modprobe kvm
sudo modprobe kvm_intel  # For Intel
sudo modprobe kvm_amd    # For AMD

# Add user to kvm group
sudo usermod -aG kvm $USER
```

### Port Already in Use

If SSH port is busy, choose a different port during VM creation.

### Download Failed

Check your internet connection and try again. Some images are 500MB-1GB.

### Permission Denied

Run with sudo or fix permissions:

```bash
sudo chown -R $USER:$USER ~/vms
```

---

## Performance Tips

1. **Use KVM** - Hardware virtualization is much faster
2. **Allocate proper RAM** - Don't over-allocate
3. **Use SSD** - Faster disk I/O
4. **Limit concurrent VMs** - Based on your system resources
5. **Close unused VMs** - Free up resources

---

## Security Notes

⚠️ **Important:**

- Change default passwords after first login
- Use strong passwords for production VMs
- Keep VM images updated
- Don't expose VM ports to public networks
- Regular backups recommended

---

## Commands Quick Reference

```bash
# Launch VM Manager
./vm.sh

# Launch No KVM Version
./nokvm.sh

# Check if VM is running
pgrep -f "qemu.*<vm-name>"

# Stop all VMs
pkill -f "qemu-system"

# List VM configurations
ls ~/vms/*.conf

# View VM config
cat ~/vms/<vm-name>.conf

# Manual SSH connection
ssh user@localhost -p 2222
```

---

## License

MIT License - Feel free to use and modify!

---

<div align="center">

---

```
███████╗██╗  ██╗ ██████╗ ███████╗
██╔════╝╚██╗██╔╝██╔════╝ ██╔════╝
███████╗ ╚███╔╝ ██║  ███╗█████╗  
╚════██║ ██╔██╗ ██║   ██║██╔══╝  
███████║██╔╝ ██╗╚██████╔╝███████╗
╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝
          MADE BY TRS
```

**Made with ❤️ by TRS**

*PIXLE CORE - Multi-VM Manager*

</div>
