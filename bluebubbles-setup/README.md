# De-Googled BlueBubbles Server Setup 🚫🔍

**Access your iMessages anywhere without Google dependencies**

This repository provides a complete guide to set up BlueBubbles server with full functionality while maintaining privacy and avoiding Google services dependencies.

## 🌟 What This Achieves

- ✅ **Full BlueBubbles functionality** (web interface, mobile apps, push notifications)
- ✅ **Zero Google account required** 
- ✅ **Complete privacy** - everything runs locally
- ✅ **No data sent to Google** - uses local Firebase emulator
- ✅ **All iMessage features** - send, receive, attachments, groups
- ✅ **Cross-platform access** - works on any device with a browser

## 🎯 Perfect For

- Privacy-conscious users who don't want Google involvement
- People who can't access Google services
- Users who prefer local-only solutions
- Anyone wanting full control over their messaging data

## 🛠️ What You'll Need

- **macOS** (any recent version)
- **iMessage account** signed in
- **Node.js** installed
- **BlueBubbles app** (free download)
- **10 minutes of setup time**

## 🚀 Quick Start

### 1. Install Prerequisites

```bash
# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Node.js
brew install node

# Install Firebase CLI
curl -sL https://firebase.tools | bash

# Install BlueBubbles
brew install --cask bluebubbles
```

### 2. Setup Firebase Emulator (Local Only)

```bash
# Create setup directory
mkdir ~/bluebubbles-setup && cd ~/bluebubbles-setup

# Start Firebase emulator (runs locally, no Google account needed)
firebase emulators:start --only firestore --project demo-bluebubbles &
```

### 3. Generate Configuration Files

Download and run our automated setup:

```bash
# Download configuration generator
curl -O https://raw.githubusercontent.com/pdubbbbbs/de-googled-blue-bubbles-server-setup/main/setup.sh

# Make executable and run
chmod +x setup.sh
./setup.sh
```

### 4. Configure BlueBubbles

1. Open BlueBubbles app
2. Navigate to Firebase/Manual Setup tab
3. Enable Firestore
4. Drag `google-services.json` to left box
5. Drag `admin-sdk.json` to right box
6. Set port to `50000` (or your preference)
7. Create a server password
8. Click "Start Server"

## 📁 Repository Contents

```
├── README.md                 # This file
├── setup.sh                 # Automated setup script
├── configs/
│   ├── admin-sdk.json       # Local Firebase admin configuration
│   └── google-services.json # Local Firebase services configuration
├── scripts/
│   ├── install-deps.sh      # Install all dependencies
│   ├── start-emulator.sh    # Start Firebase emulator
│   └── generate-config.js   # Generate configuration files
└── docs/
    ├── TROUBLESHOOTING.md   # Common issues and solutions
    ├── ADVANCED.md          # Advanced configuration options
    └── SECURITY.md          # Security best practices
```

## 🔧 Advanced Configuration

### Custom Ports
Change the default ports if needed:
```bash
# BlueBubbles server
PORT=50000

# Firebase emulator
FIRESTORE_PORT=8080
EMULATOR_UI_PORT=4000
```

### SSL/HTTPS Setup
For secure connections:
```bash
# Generate self-signed certificate
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes
```

### Network Access
Enable access from other devices on your network:
```json
{
  "bindAddress": "0.0.0.0",
  "port": 50000,
  "enableHTTPS": true
}
```

## 🛡️ Security & Privacy

- **No Google tracking** - Firebase emulator runs locally
- **No cloud storage** - all data stays on your Mac
- **No telemetry** - no usage data sent anywhere
- **Full control** - you own all components of the system
- **Open source** - audit all code yourself

## 🌐 Accessing Your Server

Once configured, access your messages at:
- **Local**: `http://localhost:50000`
- **Network**: `http://YOUR_MAC_IP:50000`
- **Mobile apps**: Use the BlueBubbles mobile app with your server URL

## 🔍 Monitoring & Logs

View your local Firebase emulator:
- **Emulator UI**: `http://localhost:4000`
- **Firestore data**: `http://localhost:4000/firestore`

## 🐛 Troubleshooting

### Common Issues

**"Permission Denied" accessing Messages database**
- Add BlueBubbles to Full Disk Access in System Preferences → Privacy & Security

**"Can't connect to server"**
- Ensure Firebase emulator is running: `firebase emulators:start --only firestore --project demo-bluebubbles`

**"Port already in use"**
- Change BlueBubbles port in settings or kill existing processes

**"Messages not syncing"**
- Restart Messages app
- Check that Messages is signed in to iCloud

See [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) for more solutions.

## 🤝 Contributing

Contributions welcome! Please read our contributing guidelines:

1. Fork this repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📝 License

MIT License - feel free to use, modify, and distribute.

## 🙏 Acknowledgments

- [BlueBubbles Team](https://github.com/BlueBubblesApp) - for the amazing BlueBubbles server
- [Firebase Team](https://github.com/firebase) - for the local emulator suite
- Privacy advocates everywhere who inspire solutions like this

## ⭐ Star This Repo

If this helped you set up BlueBubbles without Google, please star this repository to help others find it!

---

**Need help?** Open an issue or check our [documentation](docs/).

**Want to support this project?** Star the repo and share it with others who value privacy!