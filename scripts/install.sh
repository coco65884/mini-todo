#!/bin/bash
set -euo pipefail

APP_NAME="MiniTodo"
INSTALL_DIR="/Applications"
BUILD_DIR=".build/release"
APP_BUNDLE="${INSTALL_DIR}/${APP_NAME}.app"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "${SCRIPT_DIR}")"

echo "Building ${APP_NAME} in release mode..."
swift build -c release

echo "Creating app bundle..."
rm -rf "${APP_BUNDLE}"
mkdir -p "${APP_BUNDLE}/Contents/MacOS"
mkdir -p "${APP_BUNDLE}/Contents/Resources"

cp "${BUILD_DIR}/${APP_NAME}" "${APP_BUNDLE}/Contents/MacOS/${APP_NAME}"

# Copy icon if exists
if [ -f "${PROJECT_DIR}/Assets/AppIcon.icns" ]; then
    cp "${PROJECT_DIR}/Assets/AppIcon.icns" "${APP_BUNDLE}/Contents/Resources/AppIcon.icns"
fi

cat > "${APP_BUNDLE}/Contents/Info.plist" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.org/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key>
    <string>MiniTodo</string>
    <key>CFBundleDisplayName</key>
    <string>Mini Todo</string>
    <key>CFBundleIdentifier</key>
    <string>com.minitodo.app</string>
    <key>CFBundleVersion</key>
    <string>1.0.0</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    <key>CFBundleExecutable</key>
    <string>MiniTodo</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>LSMinimumSystemVersion</key>
    <string>14.0</string>
    <key>LSUIElement</key>
    <true/>
    <key>NSHighResolutionCapable</key>
    <true/>
</dict>
</plist>
PLIST

echo ""
echo "Installed to ${APP_BUNDLE}"
echo "Spotlight or Launchpad from launch Mini Todo."
echo ""
echo "Tip: ログイン時に自動起動するには:"
echo "  システム設定 > 一般 > ログイン項目 で MiniTodo を追加してください"
