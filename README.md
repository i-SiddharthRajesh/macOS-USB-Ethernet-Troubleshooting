# macOS USB Ethernet Troubleshooting

[![Platform](https://img.shields.io/badge/platform-macOS-lightgrey)](https://www.apple.com/macos/)
[![Shell](https://img.shields.io/badge/script-Bash-4EAA25)](https://www.gnu.org/software/bash/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A practical troubleshooting guide for diagnosing USB-C Ethernet adapters on macOS. It focuses on adapter detection, changing network-interface names, DHCP address assignment, and wired connectivity.

> **Important:** This is a community troubleshooting guide, not an official Apple, ASIX, or university support resource. The documented case involved a MacBook Air, a USB-C hub, an ASIX AX88179B adapter, and a university Ethernet network. The exact cause of the intermittent detection was not conclusively identified.

## What this guide helps diagnose

- USB Ethernet does not appear in **System Settings → Network**.
- The adapter appears in USB information but no network interface appears.
- The Ethernet interface has no IPv4 address.
- macOS shows a self-assigned `169.254.x.x` address.
- DHCP does not appear to complete.
- An interface name such as `en5` disappears or changes after reconnecting.
- Ethernet returns after reconnecting the hub or trying a different port.

## Why this guide?

Troubleshooting is easier when each layer is checked separately:

1. **Physical connection** — cable, hub, and Mac USB-C port.
2. **USB detection** — whether macOS can see the adapter.
3. **Network interface** — which `enX` device macOS currently assigned.
4. **IP configuration** — whether DHCP assigned an IPv4 address.
5. **Connectivity** — whether the gateway and internet destination can be reached.

Do not skip straight to network resets or driver changes. Start with read-only checks.

## Requirements

- A Mac running macOS.
- A USB Ethernet adapter or USB-C hub with Ethernet.
- Access to Terminal.
- Permission to use the network you are troubleshooting.

Some diagnostic commands may display private network information. Review and redact output before sharing it publicly.

## Quick start

### 1. Check the physical connection

1. Connect the hub securely to the Mac.
2. Connect the Ethernet cable to the hub.
3. Wait several seconds for the link and network configuration to initialize.
4. If the adapter is missing, disconnect the hub, wait 10–15 seconds, reconnect it, and check again.
5. If available, test another USB-C port or cable one at a time.

### 2. Check USB detection

```bash
system_profiler SPUSBDataType
```

To filter for common Ethernet adapter names:

```bash
system_profiler SPUSBDataType | grep -i -A 8 -E 'ASIX|AX88179|USB.*LAN|Ethernet'
```

The full output is more reliable than a filter. If no matching text appears, the device may be listed under another name.

### 3. Find the current interface name

```bash
networksetup -listallhardwareports
```

Find the hardware-port section for the USB Ethernet adapter and note its `Device` value, such as `en5`. **Do not assume that `en5` will always be the correct interface.** The name can change after disconnecting hardware.

### 4. Check the IP address

Replace `enX` with the current device name:

```bash
ipconfig getifaddr enX
```

- A valid address assigned by the network suggests DHCP completed.
- A blank result means no IPv4 address is currently available on that interface.
- A `169.254.x.x` address is a self-assigned link-local address and commonly indicates that the Mac did not receive a usable IPv4 address through DHCP.

### 5. Request DHCP if the interface exists

```bash
sudo ipconfig set enX DHCP
```

Replace `enX` with the current Ethernet interface. Wait 10–15 seconds, then run:

```bash
ipconfig getifaddr enX
```

If Terminal reports `interface doesn't exist`, stop and rerun `networksetup -listallhardwareports`. The adapter may have disconnected or the interface name may have changed. Do not keep retrying the old name.

### 6. Test the gateway (optional)

Only use the gateway address for the network you are currently connected to:

```bash
ping -c 4 YOUR_GATEWAY_IP
```

Replace `YOUR_GATEWAY_IP` with the correct gateway. Do not copy a gateway from a different network. Replies show that the gateway is reachable, but do not prove that DNS or all internet destinations work.

### 7. Test internet access through Ethernet (optional)

If the interface has a valid IP address:

```bash
curl --interface enX -I --connect-timeout 10 https://www.google.com
```

Replace `enX` with the current Ethernet interface. A successful HTTP response indicates that the interface can reach that destination. Failures may be caused by network policy, a captive portal, DNS, or connectivity.

## Diagnostic script

A read-only diagnostic script is included at [`scripts/diagnose-ethernet.sh`](scripts/diagnose-ethernet.sh). It collects macOS version, USB device information, hardware-port mappings, network service order, interface summaries, and the default route.

Run it from the repository directory:

```bash
chmod +x scripts/diagnose-ethernet.sh
./scripts/diagnose-ethernet.sh
```

The script does **not** request DHCP, change service order, reset network settings, or require administrator privileges. Its output may contain IP addresses, MAC addresses, and other local network information. Redact these before posting publicly.

## Case study: ASIX AX88179B and university Ethernet

The reported setup was a MacBook Air M4 connected through a USB-C hub with an ASIX AX88179B-based Ethernet adapter.

Observed during troubleshooting:

- The adapter was initially detected as `en5`.
- It first had a self-assigned `169.254.x.x` address.
- A packet capture showed DHCP Offers from the university network, but the early capture did not show the complete DHCP exchange.
- Later, DHCP succeeded and the interface received an address.
- The gateway responded to ping.
- An HTTPS test bound to the Ethernet interface succeeded.
- Ethernet was then made the preferred network route.
- After unplugging and reconnecting the hub, `en5` was reported as nonexistent and the adapter was absent from the hardware-port listing and filtered USB output.
- The adapter later reappeared and connected after another physical reconnection.

**What this establishes:** the connection was restored and the adapter can work in this setup.

**What it does not establish:** the exact cause of the intermittent detection, or that a specific port is required. A different port, cable, or hub can be tested one at a time, but none is a guaranteed fix.

## Troubleshooting decision table

| Symptom | Next check |
|---|---|
| Adapter absent from USB information | Reseat the hub; test another port or cable if available |
| Adapter visible over USB but absent from hardware ports | Record macOS version and adapter model; check current compatibility information |
| Interface exists but has no IP | Verify the interface name, then request DHCP |
| `interface doesn't exist` | Re-run `networksetup -listallhardwareports`; do not reuse a stale interface name |
| Valid IP but no internet | Check gateway, captive portal, DNS, and campus access requirements |
| One campus port works but another does not | The second port may be inactive or subject to different network policy; contact campus IT |

## What not to do

- Do not hard-code an interface name from an old terminal session.
- Do not assign a random static IP address on a managed network.
- Do not change DNS, routes, or service order unless necessary and you understand the consequences.
- Do not repeatedly run commands against a nonexistent interface.
- Do not publish credentials, full MAC addresses, serial numbers, or confidential campus network details.
- Do not bypass university authentication, device registration, or other access controls.
- Do not install unofficial drivers or kernel extensions without checking their source, compatibility, and necessity.

## Contributing

Bug reports, corrections, additional adapter experiences, and clearer explanations are welcome. See [`CONTRIBUTING.md`](CONTRIBUTING.md) before opening an issue. Please include macOS and adapter details, the exact symptom, and redacted command output. Distinguish verified results from hypotheses.

## Security and privacy

See [`SECURITY.md`](SECURITY.md). Never publish passwords, tokens, account identifiers, full MAC addresses, or private campus network details. Review diagnostic logs before sharing them.

## License

This project is licensed under the MIT License. See [`LICENSE`](LICENSE).

## Disclaimer

Provided “as is” for educational and troubleshooting purposes. This project is not affiliated with Apple, ASIX, or any university. Behavior varies by macOS version, adapter, hub, and network configuration. Follow your institution's IT policies.
