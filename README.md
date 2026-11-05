# fingerprint-chromium-macos

Unofficial macOS (Intel x86_64 and Apple Silicon) builds of [adryfish/fingerprint-chromium](https://github.com/adryfish/fingerprint-chromium), an anti-detect Chromium with engine-level fingerprint spoofing, packaged with the build scripts of [ungoogled-chromium-macos](https://github.com/ungoogled-software/ungoogled-chromium-macos).

Upstream publishes macOS builds for Apple Silicon only. This repository exists to produce an Intel (x86_64) DMG on GitHub-hosted runners.

- Builds are ad-hoc signed and **not notarized**. After mounting the DMG run `xattr -cr /path/to/Chromium.app`.
- Source tag: fingerprint-chromium `148.0.7778.215` on top of ungoogled-chromium-macos `148.0.7778.215-1.1`.
- Trigger: Actions → *Build fingerprint-chromium for macOS* → Run workflow (arch, runner label, optional release tag).

Used by [Profile Manager](https://github.com/yerros/profile-manager) as its anti-detect engine on Intel Macs.
