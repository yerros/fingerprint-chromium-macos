#!/usr/bin/env bash
set -euo pipefail

# Pilih Xcode 26.x terendah yang tersedia di image runner (ungoogled-chromium 148 dibangun dengan 26.0)
BASE_XCODE_PATH="$(ls -d /Applications/Xcode_26*.app 2>/dev/null | grep -v beta | sort -V | head -1 || true)"
if [ -z "$BASE_XCODE_PATH" ]; then
  echo "Failed to find a suitable version of Xcode (need 26.x)"; ls -l /Applications | grep Xcode; exit 1
fi
echo "Using $BASE_XCODE_PATH"
ls -l /Applications | grep Xcode || true

# Hapus Xcode lain agar disk lega, lalu pakai path konsisten antar job
for x in /Applications/Xcode*.app; do
  if [ "$(readlink -f "$x")" != "$(readlink -f "$BASE_XCODE_PATH")" ]; then sudo rm -rf "$x"; fi
done
if [ ! -e /Applications/Xcode_26.app ]; then
  sudo mv "$(readlink -f "$BASE_XCODE_PATH")" /Applications/Xcode_26.app 2>/dev/null || sudo ln -s "$(readlink -f "$BASE_XCODE_PATH")" /Applications/Xcode_26.app
fi
sudo xcode-select --switch /Applications/Xcode_26.app
sudo xcodebuild -license accept || true
sudo xcrun simctl delete all || true
xcodebuild -version
