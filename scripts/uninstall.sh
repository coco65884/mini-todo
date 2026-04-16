#!/bin/bash
set -euo pipefail

APP_BUNDLE="/Applications/MiniTodo.app"
DATA_DIR="${HOME}/Library/Application Support/MiniTodo"

echo "Uninstalling Mini Todo..."

if [ -d "${APP_BUNDLE}" ]; then
    rm -rf "${APP_BUNDLE}"
    echo "Removed ${APP_BUNDLE}"
else
    echo "${APP_BUNDLE} not found, skipping."
fi

read -p "Delete saved data (todos/memos)? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf "${DATA_DIR}"
    echo "Removed ${DATA_DIR}"
else
    echo "Data preserved at ${DATA_DIR}"
fi

echo "Uninstall complete."
