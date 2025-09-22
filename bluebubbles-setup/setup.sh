#!/bin/bash

# BlueBubbles No-Google Setup Script
# Automates the entire setup process

set -e

echo "🚫🔍 BlueBubbles No-Google Setup Starting..."
echo "=========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}❌ This script requires macOS${NC}"
    exit 1
fi

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo -e "${BLUE}📋 Checking prerequisites...${NC}"

# Check for Homebrew
if ! command_exists brew; then
    echo -e "${YELLOW}⚠️  Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo -e "${GREEN}✅ Homebrew found${NC}"
fi

# Check for Node.js
if ! command_exists node; then
    echo -e "${YELLOW}⚠️  Installing Node.js...${NC}"
    brew install node
else
    echo -e "${GREEN}✅ Node.js found ($(node --version))${NC}"
fi

# Check for Firebase CLI
if ! command_exists firebase; then
    echo -e "${YELLOW}⚠️  Installing Firebase CLI...${NC}"
    curl -sL https://firebase.tools | bash
else
    echo -e "${GREEN}✅ Firebase CLI found${NC}"
fi

# Check for BlueBubbles
if ! find /Applications -name "BlueBubbles.app" -type d 2>/dev/null | grep -q .; then
    echo -e "${YELLOW}⚠️  Installing BlueBubbles...${NC}"
    brew install --cask bluebubbles
else
    echo -e "${GREEN}✅ BlueBubbles found${NC}"
fi

echo -e "${BLUE}🔧 Creating configuration files...${NC}"

# Create configs directory
mkdir -p configs

# Generate admin-sdk.json
cat > configs/admin-sdk.json << 'EOF'
{
  "type": "service_account",
  "project_id": "demo-bluebubbles",
  "private_key_id": "demo-key-id",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC5/WZ2Z5QZhg1Z\ndemo-key-content-for-local-emulator-only\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-demo@demo-bluebubbles.iam.gserviceaccount.com",
  "client_id": "123456789012345678901",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-demo%40demo-bluebubbles.iam.gserviceaccount.com"
}
EOF

# Generate google-services.json
cat > configs/google-services.json << 'EOF'
{
  "project_info": {
    "project_number": "123456789012",
    "firebase_url": "http://127.0.0.1:8080",
    "project_id": "demo-bluebubbles",
    "storage_bucket": "demo-bluebubbles.appspot.com"
  },
  "client": [
    {
      "client_info": {
        "mobilesdk_app_id": "1:123456789012:web:demo12345",
        "android_client_info": {
          "package_name": "app.bluebubbles.messaging"
        }
      },
      "oauth_client": [
        {
          "client_id": "123456789012-demo.apps.googleusercontent.com",
          "client_type": 3
        }
      ],
      "api_key": [
        {
          "current_key": "demo-api-key-for-local-emulator"
        }
      ],
      "services": {
        "appinvite_service": {
          "other_platform_oauth_client": [
            {
              "client_id": "123456789012-demo.apps.googleusercontent.com",
              "client_type": 3
            }
          ]
        }
      }
    }
  ],
  "configuration_version": "1"
}
EOF

echo -e "${GREEN}✅ Configuration files created${NC}"

# Create start script
cat > start-emulator.sh << 'EOF'
#!/bin/bash
echo "🚀 Starting Firebase emulator..."
firebase emulators:start --only firestore --project demo-bluebubbles
EOF

chmod +x start-emulator.sh

echo -e "${BLUE}🚀 Starting Firebase emulator...${NC}"

# Start emulator in background
firebase emulators:start --only firestore --project demo-bluebubbles > emulator.log 2>&1 &
EMULATOR_PID=$!

# Wait for emulator to start
echo -e "${YELLOW}⏳ Waiting for emulator to start...${NC}"
sleep 10

# Check if emulator is running
if curl -s http://127.0.0.1:8080 > /dev/null; then
    echo -e "${GREEN}✅ Firebase emulator running${NC}"
else
    echo -e "${RED}❌ Failed to start Firebase emulator${NC}"
    exit 1
fi

echo -e "${GREEN}🎉 Setup complete!${NC}"
echo ""
echo -e "${BLUE}📋 Next steps:${NC}"
echo "1. Open BlueBubbles app"
echo "2. Go to Firebase/Manual Setup tab"
echo "3. Enable Firestore"
echo "4. Drag configs/google-services.json to LEFT box"
echo "5. Drag configs/admin-sdk.json to RIGHT box"
echo "6. Set port to 50000"
echo "7. Create a server password"
echo "8. Click 'Start Server'"
echo ""
echo -e "${BLUE}🌐 Access points:${NC}"
echo "• BlueBubbles Web: http://localhost:50000"
echo "• Emulator UI: http://localhost:4000"
echo "• Firestore: http://localhost:8080"
echo ""
echo -e "${YELLOW}⚠️  Keep this terminal open to maintain the Firebase emulator${NC}"
echo ""
echo -e "${GREEN}🎯 Enjoy your privacy-focused BlueBubbles setup!${NC}"

# Keep script running to maintain emulator
wait $EMULATOR_PID