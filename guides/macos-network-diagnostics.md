# macOS Network Diagnostics

This guide explains how to read common outputs while troubleshooting USB Ethernet.

## Hardware port listing

Command:

```bash
networksetup -listallhardwareports
```

Each section associates a hardware-port name with a BSD device name such as `en0` or `en5`. The device name is not guaranteed to remain the same after hardware is disconnected and reconnected. Identify the current adapter every time it disappears.

## Interface status

Command:

```bash
ifconfig -a
```

Look for the adapter's interface and its status. An interface being listed does not guarantee it has a valid IP address or internet access.

## IP address

Command:

```bash
ipconfig getifaddr enX
```

Replace `enX` with the interface found in the hardware-port listing. A blank response means no IPv4 address is available for that interface at that moment.

A `169.254.x.x` IPv4 address is a link-local self-assigned address. It is not the same as a DHCP address supplied by a managed network.

## DHCP request

Command:

```bash
sudo ipconfig set enX DHCP
```

Only use this after confirming the current interface exists and is the intended Ethernet adapter. If it reports that the interface does not exist, re-identify the interface rather than repeating the command.

## Route selection

Command:

```bash
route -n get default
```

The `interface` field indicates which interface macOS is using for the default route at that time. Wi-Fi and Ethernet can both be connected; the default route determines where ordinary traffic is sent.

Changing service order is not required merely to diagnose a missing adapter. Change it only if needed, and note the original order first.
