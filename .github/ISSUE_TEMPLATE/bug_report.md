---
name: Troubleshooting report
about: Report a USB Ethernet detection or connectivity issue
title: "[Troubleshooting]: "
labels: troubleshooting
assignees: ""
---

## System
- Mac model:
- macOS version:
- USB Ethernet adapter/chipset:
- Hub/dock model:
- Network type (home, campus, office; no private details):

## Symptoms
- [ ] Adapter absent from USB device list
- [ ] Adapter visible in USB list but absent from Network settings
- [ ] No IP address
- [ ] Self-assigned `169.254.x.x` address
- [ ] IP address present but no internet
- [ ] Interface name changed or disappeared after reconnecting

## Checks performed
Paste redacted output from relevant commands:
- `system_profiler SPUSBDataType`
- `networksetup -listallhardwareports`
- `ipconfig getifaddr enX` (replace `enX` with current interface)

## Steps already tried
Describe each step and the result.

## Privacy check
- [ ] I removed passwords, tokens, full MAC addresses, serial numbers, and confidential network details.
