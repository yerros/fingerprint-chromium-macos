#!/usr/bin/env bash
# Build fingerprint-chromium for macOS Intel (x86_64) on an Apple Silicon Mac, locally.
# Usage: ./local_build_m1.sh            -> builds x86_64 (default)
#        ./local_build_m1.sh arm64      -> builds arm64
# Needs: macOS 15.6+, Xcode 26 (opened once, license accepted), Homebrew, ~100 GB free disk.
set -euo pipefail
ARCH="${1:-x86_64}"
ROOT="$(cd "$(dirname "$0")" && pwd)"

echo "== prerequisites =="
xcodebuild -version | head -1
if ! xcodebuild -version | grep -q "Xcode 26"; then echo "Need Xcode 26.x selected (xcode-select --switch /Applications/Xcode.app)"; exit 1; fi
command -v brew >/dev/null || { echo "Install Homebrew first: https://brew.sh"; exit 1; }
brew install python@3.13 ninja coreutils readline node >/dev/null
brew unlink binutils >/dev/null 2>&1 || true
pip3 install -q PySocks httplib2 --break-system-packages 2>/dev/null || pip3 install -q PySocks httplib2
xcodebuild -downloadComponent MetalToolchain >/dev/null 2>&1 || true
FREE_GB=$(df -g "$ROOT" | awk 'NR==2{print $4}')
echo "free disk: ${FREE_GB} GB"; [ "$FREE_GB" -ge 90 ] || { echo "Need at least 90 GB free"; exit 1; }
git -C "$ROOT" submodule update --init --depth 1

echo "== build $ARCH (hours) =="
export PATH="/opt/homebrew/opt/python@3.13/bin:/opt/homebrew/bin:$PATH"
# Ad-hoc signing is already wired in sign_and_package_app.sh (no Apple Developer ID needed)
cd "$ROOT" && caffeinate -dims ./build.sh "$ARCH" 2>&1 | tee "build_${ARCH}.log"

echo "== result =="
ls -la "$ROOT"/build/*.dmg
echo "Upload with: gh release upload 148.0.7778.215-1.1 build/*.dmg --clobber -R yerros/fingerprint-chromium-macos"
