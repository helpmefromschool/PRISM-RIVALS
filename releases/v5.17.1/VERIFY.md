# Verify PRISM V5.17.1 (protected release)

The official, owner-tested V5.17.1 distribution is the **[Protected Release ZIP](https://github.com/helpmefromschool/PRISM-RIVALS/releases/download/v5.17.1/PRISM_V5_17_1_Protected_Release.zip)** on the [GitHub release page](https://github.com/helpmefromschool/PRISM-RIVALS/releases/tag/v5.17.1).

The repository's root `PRISM.lua` remains **V5.16**. Do **not** treat GitHub's automatic Source code archives as the V5.17.1 distribution.

## Windows PowerShell verification

Download the protected ZIP from the official GitHub Release, then run this command in the folder containing it:

```powershell
(Get-FileHash '.\PRISM_V5_17_1_Protected_Release.zip' -Algorithm SHA256).Hash
```

Expected ZIP SHA-256:

```text
A6E15142DFBC4A1DD2F2B3742BD24D4F8D103E21107183C393D848410B69F200
```

Extract the ZIP and, from the folder containing its `PRISM.lua`, run:

```powershell
(Get-FileHash '.\PRISM.lua' -Algorithm SHA256).Hash
```

Expected protected **Lua** SHA-256:

```text
AF97947EC3967D3C5BE1EABAA4525703CF8ED3D4EB028961D7BAD37E4CBFFFC4
```

[Plain-text Lua checksum](SHA256SUMS.txt)

A mismatch means the file differs from the recorded release. Checking a hash does not make the file harmless, unmodifiable, or uncrackable.

## Tested behavior

On 2026-10-19, the project owner reported these V5.17.1 Matcha checks passed: opens menu, selections, Apply All, post-Apply navigation, Right Shift toggle, and no new visible errors. These were user-reported tests, not independent security certification.

## Release and privacy notes

Only the minified distribution should be published as new releases. Maintain readable source separately in a private repository and never place credentials, private configurations or personal workspace files in the public release. Previous V5.16 source remains public and may be copied.

The project is unofficial. It depends on an independent third-party changer; proper attribution remains necessary. The release does not prevent inspection or modification of client-side Lua code.
