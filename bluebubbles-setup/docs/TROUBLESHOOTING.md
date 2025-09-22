# Troubleshooting Guide

## Common Issues and Solutions

### 🔒 Permission Issues

**Problem**: "Permission Denied" accessing Messages database

**Solution**:
1. Open System Preferences → Privacy & Security
2. Click "Full Disk Access" in the left sidebar
3. Click the lock icon and enter your password
4. Click "+" and add BlueBubbles.app
5. Also add Terminal.app if you're using terminal commands
6. Restart BlueBubbles

### 🌐 Connection Issues

**Problem**: "Can't connect to server" or "Server not responding"

**Solutions**:
1. Check if Firebase emulator is running:
   ```bash
   curl http://127.0.0.1:8080
   ```
   Should return "Ok"

2. Restart the emulator:
   ```bash
   firebase emulators:start --only firestore --project demo-bluebubbles
   ```

3. Check if port 50000 is available:
   ```bash
   lsof -i :50000
   ```

**Problem**: "Port already in use"

**Solution**:
1. Find and kill the process using the port:
   ```bash
   lsof -i :50000
   kill [PID]
   ```

2. Or use a different port in BlueBubbles settings

### 📱 Messages Not Syncing

**Problem**: Messages not appearing or not syncing

**Solutions**:
1. Ensure Messages.app is signed in to iCloud
2. Restart Messages.app:
   ```bash
   killall Messages
   open -a Messages
   ```

3. Check Messages database permissions:
   ```bash
   ls -la ~/Library/Messages/chat.db
   ```

4. Restart BlueBubbles server

### 🔥 Firebase Emulator Issues

**Problem**: Emulator won't start or crashes

**Solutions**:
1. Clear emulator data:
   ```bash
   rm -rf ~/.cache/firebase/emulators
   ```

2. Update Firebase CLI:
   ```bash
   curl -sL https://firebase.tools | bash
   ```

3. Check Java version (emulator requires Java):
   ```bash
   java --version
   ```

4. Install Java if missing:
   ```bash
   brew install openjdk
   ```

### 🖥️ Web Interface Issues

**Problem**: Web interface not loading

**Solutions**:
1. Check BlueBubbles server status
2. Try different browser
3. Clear browser cache
4. Check browser console for errors (F12)
5. Try incognito/private mode

**Problem**: Can't access from other devices

**Solutions**:
1. Change bind address to `0.0.0.0` in BlueBubbles settings
2. Check firewall settings:
   ```bash
   sudo /usr/libexec/ApplicationFirewall/socketfilterfw --listapps
   ```

3. Add BlueBubbles to firewall exceptions if needed

### 🔧 Configuration Issues

**Problem**: "Invalid configuration" or JSON errors

**Solutions**:
1. Validate JSON files:
   ```bash
   python -m json.tool configs/admin-sdk.json
   python -m json.tool configs/google-services.json
   ```

2. Re-generate configuration files:
   ```bash
   ./setup.sh
   ```

3. Check file permissions:
   ```bash
   ls -la configs/
   ```

### 📊 Performance Issues

**Problem**: Slow message loading or high CPU usage

**Solutions**:
1. Check Messages database size:
   ```bash
   du -h ~/Library/Messages/chat.db
   ```

2. Restart BlueBubbles periodically
3. Monitor system resources:
   ```bash
   top -pid $(pgrep BlueBubbles)
   ```

4. Consider message history limits in BlueBubbles settings

### 🔄 Update Issues

**Problem**: Features not working after update

**Solutions**:
1. Update all components:
   ```bash
   brew upgrade bluebubbles
   curl -sL https://firebase.tools | bash
   ```

2. Re-run setup script:
   ```bash
   ./setup.sh
   ```

3. Reset BlueBubbles settings if needed

## Debug Commands

### Check System Status
```bash
# Check all processes
ps aux | grep -E "(BlueBubbles|firebase|Messages)"

# Check ports
netstat -an | grep LISTEN | grep -E "(50000|8080|4000)"

# Check Firebase emulator
curl http://127.0.0.1:4000
```

### Logs and Debugging
```bash
# View emulator logs
tail -f emulator.log

# View system logs
log stream --predicate 'process == "BlueBubbles"' --level info

# Check Messages app logs
log stream --predicate 'process == "Messages"' --level error
```

### Reset Everything
If all else fails, complete reset:

```bash
# Stop all processes
pkill -f firebase
pkill BlueBubbles

# Clean up
rm -rf ~/.cache/firebase/emulators
rm -rf ~/bluebubbles-setup

# Start fresh
git clone [your-repo] ~/bluebubbles-setup
cd ~/bluebubbles-setup
./setup.sh
```

## Getting Help

1. **Check logs** first - most issues have clear error messages
2. **Search existing issues** on GitHub
3. **Create detailed issue** with:
   - Your macOS version
   - BlueBubbles version
   - Error messages
   - Steps to reproduce
4. **Include logs** from troubleshooting commands above

## Prevention Tips

- Keep emulator running consistently
- Don't force-quit BlueBubbles (use proper shutdown)
- Regularly check for updates
- Monitor disk space (Messages database can be large)
- Backup configuration files before major changes