# 🚀 PIXLE CORE - Ultra Modern VPS Manager

<div align="center">

![Version](https://img.shields.io/badge/version-3.0.1-blue)
![License](https://img.shields.io/badge/license-MIT-green)

**Next-Generation Virtual Machine Management System**

*Modern Gradient UI • Multi-VM Support • Cloud-Init • Snapshots*

</div>

---

## ✨ Features

### 🎨 Modern UI/UX
- **Gradient Color Scheme** - Beautiful rainbow gradient terminal interface
- **Animated Banners** - Eye-catching ASCII art headers
- **Progress Bars** - Visual feedback for all operations
- **Icon-based Menus** - Easy navigation with emoji icons
- **Clean Exit Handling** - Proper cleanup on interrupt

### 🖥️ VM Management
- **Multi-OS Support** - Ubuntu, Debian, Fedora, AlmaLinux
- **One-Click Creation** - Automated VM setup with cloud-init
- **Start/Stop/Delete** - Full VM lifecycle management
- **Status Monitoring** - Real-time VM status display
- **PID Tracking** - Process management for VMs

### 📸 Snapshot System
- **Create Snapshots** - Save VM states instantly
- **List Snapshots** - View all saved states
- **Restore Snapshots** - Rollback to previous states

### 📊 Resource Monitor
- **CPU Info** - Cores, model, usage
- **Memory Usage** - Total, used, free RAM
- **Disk Space** - Storage utilization
- **VM Statistics** - Total and running VMs count

### 🔧 Auto Setup
- **Dependency Check** - Automatic detection of missing packages
- **One-Click Install** - Auto-install required dependencies
- **KVM Support** - Hardware acceleration enabled
- **Internet Check** - Connection verification before download

---

## 🚀 Quick Start

### 🔥 Online Launch (Direct from GitHub)

```bash
# Quick Launch - Recommended!
bash <(curl -sL https://raw.githubusercontent.com/Satyam-Bhaii/vms/main/Satyam.sh)

# Or use the run.sh launcher
bash <(curl -sL https://raw.githubusercontent.com/Satyam-Bhaii/vms/main/run.sh)

# Full Installer (installs + launches)
bash <(curl -sL https://raw.githubusercontent.com/Satyam-Bhaii/vms/main/install.sh)
```

### 📦 Manual Install
```bash
bash Satyam.sh
```

### Direct Access
```bash
# VPS Maker Menu
bash vpsmaker.sh

# VM Manager (Full Control Panel)
bash Vpsmakerr.sh
```

---

## 📋 Prerequisites

### Required Packages
- `qemu-system-x86_64` - Virtualization
- `cloud-image-utils` - Cloud image management
- `wget` / `curl` - Downloads
- `lsof` - Process monitoring
- `libvirt-daemon-system` - Optional, for advanced features

### Auto-Install Dependencies
The scripts will automatically detect and offer to install missing dependencies.

### Manual Installation (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install -y qemu-system cloud-image-utils wget curl lsof
```

### Enable KVM (If not enabled)
```bash
sudo modprobe kvm
sudo modprobe kvm_intel  # For Intel CPUs
sudo modprobe kvm_amd    # For AMD CPUs
```

---

## 🎮 Controls

### Main Menu (Satyam.sh)
| Option | Description |
|--------|-------------|
| `1` | Launch VPS Maker |
| `2` | System Settings |
| `3` | Resource Monitor |
| `4` | Exit |

### VPS Maker (vpsmaker.sh)
| Option | Description |
|--------|-------------|
| `1` | IDX Tool Setup |
| `2` | VPS Maker Pro |
| `3` | Auto Deploy |
| `4` | Exit |

### VM Manager (Vpsmakerr.sh)
| Key | Action |
|-----|--------|
| `N` | Create New VM |
| `S` | Start VM |
| `P` | Stop VM |
| `D` | Delete VM |
| `C` | Snapshot Menu |
| `R` | Resource Monitor |
| `X` | Exit |

---

## 📁 File Structure

```
Satyam IDX/
├── Satyam.sh          # Main menu launcher
├── vpsmaker.sh        # VPS maker intermediate menu
├── Vpsmakerr.sh       # Full VM manager
└── README.md          # Documentation
```

### Generated Files
```
~/vms/                 # VM storage directory
├── *.img             # VM disk images
├── *-seed.iso        # Cloud-init configs
├── *.conf            # VM configurations
├── *.pid             # Process ID files
└── .snapshots/       # Snapshot storage
```

---

## 🔐 Default Credentials

When creating VMs:
- **Default Username:** `user` (or custom)
- **Default Password:** `trs123` (if empty)
- **Default SSH Port:** `2222`

### SSH Connection
```bash
ssh user@localhost -p 2222
```

---

## 🎨 Color Scheme

| Color | Code | Usage |
|-------|------|-------|
| 🔴 Red | `#FF0055` | Errors, Stop |
| 🩷 Pink | `#FF66FF` | Accents, Watermark |
| 🟣 Purple | `#CC66FF` | Borders, Headers |
| 🔵 Blue | `#0066FF` | Info |
| 🟢 Green | `#00FF66` | Success, Running |
| 🟡 Yellow | `#FFFF66` | Warnings |

---

## ⚠️ Important Notes

1. **KVM Required** - Ensure virtualization is enabled in BIOS
2. **Root/Sudo** - Some operations require elevated privileges
3. **Disk Space** - Each VM requires ~2-5GB storage
4. **RAM Usage** - Allocate memory based on system capacity
5. **Port Conflicts** - Ensure SSH ports are unique per VM
6. **Internet** - Required for downloading cloud images

---

## 🛠️ Troubleshooting

### VM Won't Start
```bash
# Check KVM support
lsmod | grep kvm

# Enable KVM (if needed)
sudo modprobe kvm
sudo modprobe kvm_intel  # For Intel
sudo modprobe kvm_amd    # For AMD
```

### Permission Denied
```bash
# Add user to libvirt/kvm groups
sudo usermod -aG libvirt $USER
sudo usermod -aG kvm $USER
# Logout and login again
```

### Network Issues
```bash
# Check if port is available
sudo lsof -i :2222

# Use a different port when creating VM
```

### Download Failed
```bash
# Check internet connection
ping -c 4 google.com

# Try manual download
wget <image-url> -O ~/vms/vm-name.img
```

---

## 🔄 Changelog

### v3.0.1 - Bug Fixes & Enhancements
- ✅ Fixed cursor visibility issues
- ✅ Added proper signal trapping (Ctrl+C handling)
- ✅ Improved input validation
- ✅ Fixed VM list display bugs
- ✅ Added PID tracking for VMs
- ✅ Better error messages
- ✅ Internet connection check
- ✅ Clean exit handling

### v3.0.0 - Initial Release
- 🎨 Modern gradient UI
- 🖥️ Multi-VM management
- 📸 Snapshot system
- 📊 Resource monitoring

---

## 📝 License

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

*PIXLE CORE - Ultra Modern VPS Manager*

</div>
