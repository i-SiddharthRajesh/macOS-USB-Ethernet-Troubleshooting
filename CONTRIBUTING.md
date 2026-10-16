# Contributing

Contributions that make troubleshooting safer, clearer, and more reproducible are welcome.

## Before opening an issue

Include, where known:

- Mac model and macOS version.
- Adapter chipset/model and hub model.
- Whether the adapter appears in `system_profiler SPUSBDataType`.
- The current hardware-port mapping from `networksetup -listallhardwareports`.
- Whether an IP address is assigned.
- The exact error message, with identifying details removed.
- Which physical change or command was tried and what happened.

## Privacy and security

**Redact private information before posting.** Do not include passwords, access tokens, full MAC addresses, serial numbers, personally identifying account information, or confidential university network details. Replace real addresses with placeholders such as `192.0.2.10` or `YOUR_GATEWAY_IP`.

Do not upload unredacted packet captures or full diagnostic logs without reviewing them first.

## Contribution standards

- Distinguish tested observations from hypotheses.
- Include macOS and hardware details for claims about compatibility.
- Prefer reversible, read-only diagnostic steps first.
- Explain commands that require `sudo`.
- Do not recommend bypassing campus access controls.
- Avoid claims that a fix works on every adapter or macOS version.

By submitting a contribution, you agree that it may be distributed under this repository's MIT license.
