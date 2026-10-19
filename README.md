# PRISM | RIVALS

An unofficial, community-made **local cosmetic menu** for Roblox RIVALS, designed for a compatible Matcha environment.

## Latest release — V5.17.1 (pre-release)

**[Download PRISM V5.17.1 Protected Release (.zip)](https://github.com/helpmefromschool/PRISM-RIVALS/releases/download/v5.17.1/PRISM_V5_17_1_Protected_Release.zip)**

[View the release](https://github.com/helpmefromschool/PRISM-RIVALS/releases/tag/v5.17.1) · [Verify your download](releases/v5.17.1/VERIFY.md)

Download the specifically named **Protected Release ZIP** under **Assets**. Extract and review its README before using it. The packaged `PRISM.lua` is the V5.17.1 minified build that the project owner tested; it is **not** the same as the `PRISM.lua` currently at the root of this repository.

> **Important:** `main/PRISM.lua` and GitHub's automatic **Source code (zip/tar.gz)** downloads still contain the older **V5.16** version. They are **not** the V5.17.1 protected release.

### What was tested

The project owner reported that V5.17.1 opened correctly, allowed cosmetic selections, completed Apply All, kept menu navigation responsive afterward, closed and reopened with Right Shift, and showed no new errors during that test. This does not guarantee compatibility with every game or software update.

### Verify the official file

GitHub reports the uploaded release ZIP SHA-256 as:

```text
A6E15142DFBC4A1DD2F2B3742BD24D4F8D103E21107183C393D848410B69F200
```

The `PRISM.lua` inside the tested protected ZIP has SHA-256:

```text
AF97947EC3967D3C5BE1EABAA4525703CF8ED3D4EB028961D7BAD37E4CBFFFC4
```

See [verification steps](releases/v5.17.1/VERIFY.md). Checksums help detect files that differ from the official upload; they are **not** encryption, copy prevention, or a guarantee that code is safe.

## Project notes

- Cosmetic changes and preferences are local to the user. PRISM does **not** grant ownership of paid cosmetics or Roblox account entitlements.
- The default PRISM menu toggle is **Right Shift**.
- Applying cosmetics invokes an independent third-party RIVALS skin engine by **Martini**. See [RivalsSkinChangerFULLMATCHA](https://github.com/Martinikaws/RivalsSkinChangerFULLMATCHA); PRISM does not claim ownership of that work.
- Third-party scripts can carry security risks and may violate Roblox or individual game rules. Use discretion and review downloaded code.
- This is an unofficial community project, not affiliated with Roblox or the RIVALS developers.

## For maintainers

- Keep readable development source in a **separate private repository**. Do not commit it to this public repository.
- Publish tested versioned artifacts under **Releases**. Verify the contents and SHA-256 before sharing a new version.
- Do not upload `rivals_config.lua`, cached data, player settings, private Matcha workspace files, access tokens, credentials or secrets.
- The public legacy V5.16 source remains visible in GitHub history and may already have been downloaded; future source should be treated as separate.
- Minification raises the effort of casual copying but does not prevent skilled reverse engineering.
