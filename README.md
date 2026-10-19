# PRISM | RIVALS

A community-made local cosmetic menu for Roblox RIVALS, designed for normal Matcha. Contains the V5.16 inventory-style GUI and its cosmetic selection, queue and local configuration features.

## Publishing to GitHub

1. At github.com, create a **public** repository named `PRISM-RIVALS` (or your preferred name).
2. Choose **Add file → Upload files** and upload `PRISM.lua` from this package. Upload this `README.md` too if desired.
3. Commit the files on the `main` branch.
4. Replace `YOUR_GITHUB_USERNAME` in the command below with your real GitHub username. If you picked another repository name, replace `PRISM-RIVALS` too.
5. Share this one-line script with people using a compatible Matcha setup:

```lua
loadstring(httpget("https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/PRISM-RIVALS/main/PRISM.lua"))()
```

If your Matcha environment lacks `httpget` but has `game:HttpGet`:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/PRISM-RIVALS/main/PRISM.lua"))()
```

**Important:** This script is not on GitHub until you upload it; the placeholders are not working links. Test the raw link in your browser first (it should display Lua source, not a GitHub web page or 404).

## Updating without changing the shared link

Replace the contents of the **same** `PRISM.lua` file on the `main` branch. Everyone using the same one-line loader gets the newer code the next time they execute it. Consider keeping versioned backups and reviewing changes before publishing.

## What not to upload

Do **not** upload your `rivals_config.lua`, cached game files, local profile/favorites data, access tokens, or any files from your personal Matcha workspace. Only upload `PRISM.lua` and optional public documentation.

## Notes

- Runs client-side; saved options are local to each person's Matcha workspace. They do not grant Roblox account ownership of cosmetics.
- Press **Right Shift** for the default PRISM menu toggle.
- Skin application invokes Martini's separate third-party RIVALS skin engine from GitHub when the user explicitly applies changes. Review external code before running it.
- Modifying multiplayer games using third-party scripts may violate game/platform rules and can be risky. This is an unofficial community project.
- This package keeps the existing PRISM application logic; no account-unlock bypass is included.
