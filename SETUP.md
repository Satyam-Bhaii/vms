# 🚀 PIXLE CORE - Setup Guide

## GitHub Se Run Kaise Karein

### Direct Launch Commands

Apne scripts ko directly GitHub se run karne ke liye:

```bash
# Main Menu Launch
bash <(curl -s https://raw.githubusercontent.com/Satyam-Bhaii/vms/main/Satyam.sh)

# VPS Maker Launch
bash <(curl -s https://raw.githubusercontent.com/Satyam-Bhaii/vms/main/vpsmaker.sh)

# VM Manager Launch
bash <(curl -s https://raw.githubusercontent.com/Satyam-Bhaii/vms/main/Vpsmakerr.sh)
```

### Short URL Banane Ke Liye

Agar chhota URL chahiye toh **bit.ly** ya **tinyurl** use kar sakte ho:

```bash
# Example:
# https://bit.ly/pixle-core
# https://tinyurl.com/pixlecore
```

---

## GitHub Setup Steps

### 1. Repository Public Confirm Karo

```bash
# GitHub pe jao: https://github.com/Satyam-Bhaii/vms
# Settings > General > Danger Zone > Change visibility > Public
```

### 2. Files Upload Karo

```bash
# Local directory mein jao
cd "C:\Users\sgsat\OneDrive\Desktop\Satyam IDX"

# Git initialize (agar nahi hai)
git init

# Sab files add karo
git add .

# Commit karo
git commit -m "PIXLE CORE v3.0.1 - Ultra Modern Edition"

# GitHub remote add karo (pehle se hai toh skip)
git remote add origin https://github.com/Satyam-Bhaii/vms.git

# Main branch rename
git branch -M main

# GitHub pe push
git push -u origin main
```

### 3. Raw URL Format

GitHub raw URLs hamesha is format mein hote hain:

```
https://raw.githubusercontent.com/USERNAME/REPO/BRANCH/FILEPATH
```

**Example:**
```
https://raw.githubusercontent.com/Satyam-Bhaii/vms/main/Satyam.sh
```

---

## One-Liner Installer Banana

Agar ek single command mein sab install aur run karna hai:

### `install.sh` Banao

```bash
#!/bin/bash

# PIXLE CORE - Quick Installer
# Run: bash <(curl -s https://raw.githubusercontent.com/Satyam-Bhaii/vms/main/install.sh)

clear

echo "╔══════════════════════════════════════════════════════════╗"
echo "║           PIXLE CORE - INSTALLER                         ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# Dependencies install
echo "Installing dependencies..."
sudo apt update -qq && sudo apt install -y -qq curl wget qemu-system cloud-image-utils

# Script download
echo "Downloading PIXLE CORE..."
mkdir -p ~/pixle-core
cd ~/pixle-core
curl -sO https://raw.githubusercontent.com/Satyam-Bhaii/vms/main/Satyam.sh
chmod +x Satyam.sh

echo ""
echo "Installation complete!"
echo "Launching PIXLE CORE..."
sleep 2

# Launch
bash Satyam.sh
```

### Install Command:
```bash
bash <(curl -s https://raw.githubusercontent.com/Satyam-Bhaii/vms/main/install.sh)
```

---

## Shortcut Command (Alias)

Users apne `.bashrc` mein alias add kar sakte hain:

```bash
# ~/.bashrc mein add karo
alias pixle='bash <(curl -s https://raw.githubusercontent.com/Satyam-Bhaii/vms/main/Satyam.sh)'
```

Phir bas ye type karna hoga:
```bash
pixle
```

---

## Telegram/Discord Bot Banana

Agar Telegram bot se run karna ho:

```python
# bot.py
import telebot
import subprocess

BOT_TOKEN = "YOUR_BOT_TOKEN"
bot = telebot.TeleBot(BOT_TOKEN)

@bot.message_handler(commands=['start'])
def start(message):
    bot.reply_to(message, "PIXLE CORE Launching...")
    subprocess.run(["bash", "<(curl -s https://raw.githubusercontent.com/Satyam-Bhaii/vms/main/Satyam.sh)"])

bot.polling()
```

---

## Website Integration

Agar website pe button lagana ho:

```html
<!DOCTYPE html>
<html>
<head>
    <title>PIXLE CORE</title>
</head>
<body>
    <h1>🚀 Launch PIXLE CORE</h1>
    <p>Run this command in your terminal:</p>
    <code style="background: #1e1e1e; color: #0f0; padding: 10px; display: block;">
        bash <(curl -s https://raw.githubusercontent.com/Satyam-Bhaii/vms/main/Satyam.sh)
    </code>
    
    <button onclick="copyCommand()">📋 Copy Command</button>
    
    <script>
        function copyCommand() {
            navigator.clipboard.writeText('bash <(curl -s https://raw.githubusercontent.com/Satyam-Bhaii/vms/main/Satyam.sh)');
            alert('Command copied!');
        }
    </script>
</body>
</html>
```

---

## Security Tips

⚠️ **Important:**

1. **HTTPS Use Karo** - Hamesha `https://` raw URLs use karo
2. **Script Review** - Users ko bolna ki pehle script review karein
3. **Version Pin** - Specific commit ya tag use karo production mein
4. **Checksum Verify** - SHA256 hash provide karo integrity ke liye

---

## Promotion Ideas

### Telegram Channels
- Apne channels pe share karo
- Tutorial videos banao

### YouTube
- Demo video upload karo
- Description mein command add karo

### Discord Servers
- Dev communities mein share karo

### GitHub README
- Already updated hai!

---

## Quick Reference Card

```
╔══════════════════════════════════════════════════════════╗
║                  PIXLE CORE - COMMANDS                   ║
╠══════════════════════════════════════════════════════════╣
║ Main Menu:                                               ║
║ bash <(curl -s https://raw.githubusercontent.com/       ║
║                    Satyam-Bhaii/vms/main/Satyam.sh)      ║
║                                                          ║
║ VPS Maker:                                               ║
║ bash <(curl -s https://raw.githubusercontent.com/       ║
║                    Satyam-Bhaii/vms/main/vpsmaker.sh)    ║
║                                                          ║
║ VM Manager:                                              ║
║ bash <(curl -s https://raw.githubusercontent.com/       ║
║                    Satyam-Bhaii/vms/main/Vpsmakerr.sh)   ║
║                                                          ║
║ Installer:                                               ║
║ bash <(curl -s https://raw.githubusercontent.com/       ║
║                    Satyam-Bhaii/vms/main/install.sh)     ║
╚══════════════════════════════════════════════════════════╝
```

---

**Made with ❤️ by TRS**
