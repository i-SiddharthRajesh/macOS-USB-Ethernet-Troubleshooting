# macOS USB Ethernet Troubleshooting

A practical, community-maintained guide for diagnosing USB-C Ethernet adapters on macOS, especially when an adapter disappears after reconnecting or a wired network does not obtain an IP address.

> **Scope:** This repository documents one real troubleshooting case involving a MacBook Air with an ASIX AX88179B-based USB Ethernet adapter and a university Ethernet network. It is a troubleshooting guide, not an official ASIX, Apple, or university support resource. Results vary by macOS version, adapter, hub, and network policy.

## Symptoms this guide covers

- USB Ethernet does not appear in **System Settings → Network**.
- A USB Ethernet adapter appears in System Information but has no network address.
- macOS shows a self-assigned `169.254.x.x` IPv4 address.
- DHCP does not appear to complete.
- An interface name such as `en5` disappears or changes after unplugging and reconnecting.
- Ethernet works after reconnecting the hub or using a different USB-C port.

## Start here: safe troubleshooting sequence

### 1. Check the physical connection

1. Connect the USB-C hub securely to the Mac.
2. Connect the Ethernet cable to the hub.
3. Wait several seconds for the link and network configuration to initialize.
4. If the adapter is missing, disconnect the hub, wait 10–15 seconds, reconnect it, and check again.
5. If available, test another USB-C port, cable, or hub port one at a time. Change only one thing at a time so the cause is easier to identify.

### 2. Check whether macOS sees the USB adapter

Open Terminal and run:

```bash
system_profiler SPUSBDataType
```

Look for terms such as `ASIX`, `AX88179B`, or `USB 10/100/1000 LAN`.

To filter the output:

```bash
system_profiler SPUSBDataType | grep -i -A 8 -E 'ASIX|AX88179|USB.*LAN'
```

No matching text does not prove the adapter is broken; the device may be listed under another name. Review the full output if needed.

### 3. Find the current Ethernet interface name

Do **not** assume the interface will always be `en5`. Interface names can change after reconnecting hardware.

```bash
networksetup -listallhardwareports
```

Find the hardware-port section corresponding to the USB Ethernet adapter. Note the `Device` value (for example, `en5`). Then inspect interfaces:

```bash
ifconfig -a
```

If the adapter is not listed at all, return to the physical/USB detection steps before attempting DHCP.

### 4. Check whether an IP address was assigned

Replace `enX` below with the actual device name found in Step 3:

```bash
ipconfig getifaddr enX
```

Interpretation:

- A normal address assigned by the network suggests DHCP completed.
- A blank response means no IPv4 address is currently available on that interface.
- A `169.254.x.x` address is a self-assigned link-local address and commonly indicates that the Mac did not receive a usable IPv4 address through DHCP.

Do not publish your real IP address, MAC address, or network details in a public issue.

### 5. Request DHCP (only after confirming the interface)

If the interface exists and is the intended Ethernet adapter, request a DHCP lease:

```bash
sudo ipconfig set enX DHCP
```

Replace `enX` with the current interface name. Wait 10–15 seconds, then check again:

```bash
ipconfig getifaddr enX
```

If the command says `interface doesn't exist`, stop and run `networksetup -listallhardwareports` again. The adapter may have disconnected, or the interface name may have changed. Do not keep retrying the old interface name.

### 6. Test the gateway (only if you know the correct gateway)

If your network administrator or current network configuration identifies a gateway, test that address:

```bash
ping -c 4 YOUR_GATEWAY_IP
```

Replace `YOUR_GATEWAY_IP` with the actual gateway. Do not copy a gateway from another network: campus subnets and gateways can differ.

Replies show that the gateway is reachable; they do not, by themselves, prove that DNS or all internet destinations work.

### 7. Test Ethernet-specific internet access (optional)

If the interface has a valid IP address and you have permission to access the test destination, you can test HTTPS bound to that interface:

```bash
curl --interface enX -I --connect-timeout 10 https://www.google.com
```

Replace `enX` with the current Ethernet interface. A successful HTTP response indicates that the interface can reach that destination. A failure can have several causes, including network policy, captive portals, DNS, or connectivity.

## Case study: what happened in the original report

The reported setup was a MacBook Air M4, a USB-C hub, an ASIX AX88179B USB Ethernet adapter, and university Ethernet.

Observed during troubleshooting:

- The adapter was initially detected as `en5`.
- It first had a self-assigned `169.254.x.x` address.
- A packet capture showed DHCP Offers from the university network, including an offered address, but the early capture did not show the complete DHCP exchange.
- Later, DHCP succeeded and the interface received an address.
- The gateway responded to ping.
- An HTTPS test bound to the Ethernet interface succeeded.
- Ethernet was then made the preferred network route.
- After the hub/cable was unplugged and reconnected, `en5` was reported as nonexistent and the adapter was absent from the hardware-port listing and the filtered USB output.
- The adapter later reappeared and connected again after another physical reconnection. The user suspected that the hub/port position mattered, but the exact cause was not established.

**Conclusion:** Ethernet connectivity was restored, but the precise cause of the intermittent detection was not conclusively identified. The case supports checking physical connection, USB detection, current interface names, and DHCP in that order; it does not establish that a specific port is required.

## Diagnostic script

This repository includes [`scripts/diagnose-ethernet.sh`](scripts/diagnose-ethernet.sh), a read-only collection of common diagnostics. It does not request DHCP, change service order, reset network settings, or require administrator privileges.

Run it with:

```bash
chmod +x scripts/diagnose-ethernet.sh
./scripts/diagnose-ethernet.sh
```

Review its output before sharing it. It may include local interface names, MAC addresses, IP addresses, and other identifying network information. Redact those values before posting publicly.

## What not to do

- Do not hard-code an interface name from an old terminal session.
- Do not assign a random static IP address on a managed university network.
- Do not change DNS, routes, or service order unless you understand the change and have recorded the original settings.
- Do not repeatedly run commands against a nonexistent interface.
- Do not publish campus IP details, MAC addresses, credentials, serial numbers, or unredacted packet captures.
- Do not assume that every campus Ethernet port is active or configured for the same network.
- Do not install unofficial drivers or kernel extensions unless you have verified their source, compatibility, and need.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). If you report an issue, include the macOS version, adapter model if known, hub model if known, symptoms, and redacted diagnostic output. Never post passwords, account identifiers, full MAC addresses, or private campus network details.

## Disclaimer

This project is provided “as is” for educational and troubleshooting purposes. It is not affiliated with Apple, ASIX, or any university. Commands can behave differently across macOS versions and network configurations. Follow your institution's IT policies and contact its network administrator if the port requires authorization.

## License

Released under the MIT License. See [LICENSE](LICENSE).
