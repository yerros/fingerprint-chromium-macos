_root_dir="$(dirname "$(greadlink -f "$0")")"

# For packaging
_chromium_version=$(cat "$_root_dir"/ungoogled-chromium/chromium_version.txt)
_ungoogled_revision=$(cat "$_root_dir"/ungoogled-chromium/revision.txt)
_package_revision=$(cat "$_root_dir"/revision.txt)

# Fix issue where macOS requests permission for incoming network connections
# See https://github.com/ungoogled-software/ungoogled-chromium-macos/issues/17
xattr -cs out/Default/Chromium.app

# Ad-hoc signing (tanpa Apple Developer ID / notarisasi)
codesign --force --deep --sign - out/Default/Chromium.app
codesign --verify --deep --verbose=2 out/Default/Chromium.app

# Package the app
chrome/installer/mac/pkg-dmg \
  --sourcefile --source out/Default/Chromium.app \
  --target "$_root_dir/build/fingerprint-chromium_${_chromium_version}-${_ungoogled_revision}.${_package_revision}_macos.dmg" \
  --volname Chromium --symlink /Applications:/Applications \
  --format UDBZ --verbosity 2
