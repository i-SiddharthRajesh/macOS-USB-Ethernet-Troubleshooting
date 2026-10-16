# University Ethernet Troubleshooting

Campus wired networks may use DHCP, device registration, authentication, VLANs, or other access controls. A cable that works on one computer does not guarantee that every wall port is active or permits every device.

## Recommended sequence

1. Verify the hub and cable are physically connected.
2. Confirm that macOS detects the USB adapter.
3. Identify the current network interface.
4. Check whether the interface has an IPv4 address.
5. Request DHCP only after verifying the interface.
6. Test the gateway only when you know the correct gateway for that connection.
7. If the adapter has a valid address but internet access fails, check whether the network requires a captive portal, registration, or IT authorization.

## Privacy

Before opening a public issue, redact:

- Full MAC addresses and serial numbers.
- Usernames, passwords, tokens, and account IDs.
- Private campus network details where publication is not permitted.
- Internal hostnames and unneeded packet-capture data.

If the port is restricted or inactive, contact the university's IT/network team. Do not bypass network access controls.
