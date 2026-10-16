# USB Ethernet Adapter Detection

## Symptom: adapter missing from Network settings

First determine whether macOS sees the adapter at the USB layer:

```bash
system_profiler SPUSBDataType
```

Then inspect network hardware ports:

```bash
networksetup -listallhardwareports
```

Interpretation:

- **Absent from USB listing:** check the hub connection, USB-C port, adapter, and cable seating. A powered hub or another port may be useful as a controlled test if available.
- **Visible in USB listing but absent from hardware ports:** macOS may not have created a network interface for it. Record the macOS version and adapter model and consult current vendor/macOS compatibility information.
- **Visible in both lists:** use the current device name to inspect IP assignment and connectivity.

## ASIX AX88179B case

The original report identified an ASIX AX88179B-based adapter. During one successful session, macOS mapped it to `en5`. After disconnecting the hub, `en5` disappeared and the adapter was not found by the filtered USB query. The adapter later returned after physical reconnection.

This observation does not prove a hardware fault or a software fault. The cause could not be isolated conclusively. Avoid presenting a particular USB-C port, cable, or hub position as a guaranteed fix unless further tests reproduce the result.
