# Verify a PRISM V5.17.1 release

This directory records the exact SHA-256 checksum of the independently packaged **PRISM V5.17.1 official release kit**.

**Important:** The repository's current `main/PRISM.lua` is the older V5.16 file. The checksum here applies **only** to the **V5.17.1 `PRISM.lua` included in the separate V5.17.1 release kit**, not the older file on `main`.

## Windows check

Download the release kit from a trusted official PRISM release source, extract `PRISM.lua`, then open PowerShell in that folder and run:

```powershell
(Get-FileHash .\PRISM.lua -Algorithm SHA256).Hash
```

Compare the result with [SHA256SUMS.txt](./SHA256SUMS.txt). A mismatch means the downloaded file does not exactly match the checked release file. A match is meaningful only if you obtained this reference checksum from the genuine official project, not from an unverified repost.

## Limits

- The checksum identifies the **bytes** of the release; it does **not** prevent copying, editing, modification at runtime, or redistribution.
- There is **no obfuscation, telemetry, anti-debugging or forced shutdown** in this release kit.
- Do not publish credentials, private configuration, or any user's Matcha workspace data.
- Do not portray changed or unaffiliated copies as official PRISM releases.
- Preserve attribution for external projects and code. The PRISM project uses a separate third-party cosmetic changer; this verification note does not claim ownership of that project's work.

## Publishing process

1. Test V5.17.1 in the actual environment, since a file hash cannot verify that a script functions correctly.
2. Publish the packaged release asset via an official versioned GitHub Release (the current tools cannot upload a ZIP release asset for you).
3. Include the same checksum in the Release description.
4. Keep the editable development repository private if public source-code visibility is a concern. A distributed local Lua file can still be inspected.

Official project: https://github.com/helpmefromschool/PRISM-RIVALS
