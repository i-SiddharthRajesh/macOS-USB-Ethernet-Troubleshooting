#!/bin/bash
# Read-only macOS USB Ethernet diagnostics.
# Does not change network configuration or request a DHCP lease.

set -u

section() {
  printf '\n%s\n' "===== $1 ====="
}

section "Date and macOS version"
date
sw_vers

section "USB devices that may be Ethernet adapters"
system_profiler SPUSBDataType 2>/dev/null | grep -i -A 8 -E 'ASIX|AX88179|USB.*LAN|Ethernet' || \
  echo "No matching USB device name found in filtered output. Review the full System Information USB list."

section "Hardware ports and device names"
networksetup -listallhardwareports

section "Network services and service order"
networksetup -listnetworkserviceorder

section "Interface summary"
ifconfig -a | awk '
  /^[a-zA-Z0-9]+: flags=/ { iface=$1; sub(/:$/, "", iface); print "\n" iface }
  /status:|inet / { print "  " $0 }
'

section "DHCP/IP address checks"
echo "The current interface names are shown above."
echo "For a specific Ethernet interface, run: ipconfig getifaddr enX"
echo "Replace enX with the current device name. This script intentionally does not guess the interface."

section "Routing summary"
route -n get default 2>&1 | grep -E 'gateway:|interface:' || true

section "Complete"
echo "Review and redact output before sharing it publicly."
