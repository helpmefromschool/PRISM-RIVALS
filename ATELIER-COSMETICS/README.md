# ATELIER COSMETICS v0.3 (Original Local Cosmetic Prototype)

An original **client-side** Roblox cosmetic-finish preview and local recoloring system. This project is *not* Yabujin and contains no copied Yabujin source.

## Scope

- `main.lua` offers a searchable catalog of **12 original ATELIER finishes**, previews, a **UNLOCK ALL (LOCAL)** option, Apply/Reset, target detection, and a Right Shift GUI toggle.
- **Unlock All (Local)** makes all 12 ATELIER catalog finishes available within this running client session. Four starter finishes are available before pressing it. Everything is free; this is a demonstration of selection, not purchased or game-owned unlocks.
- **It cannot unlock RIVALS items on your account**, send ownership changes to the server, create legitimate weapon skins, or make other players see cosmetic changes.
- Applying a finish attempts to locally recolor BaseParts within your *own* equipped Tool or matching camera model. Not all games use compatible models, and Roblox games may replace their own appearance frequently.
- `DemoTool.server.lua` creates a simple local test tool in your own Studio place so the appearance engine can be inspected visually without targeting third-party games.

## Recommended Studio test

1. Open a Roblox place you control in **Roblox Studio**.
2. Add `main.lua` as a **LocalScript** under `StarterPlayer > StarterPlayerScripts`.
3. Add `DemoTool.server.lua` as a **Script** under `ServerScriptService`.
4. Press Play, equip **ATELIER Test Tool**, and select a finish. Click **APPLY FINISH**.
5. Click **UNLOCK ALL (LOCAL)** to reveal the rest of the original finish previews. Use **RESET** to restore original materials and color.
6. Inspect Output for any warnings. UI right shift opens/closes.

## GitHub source loader

If your environment supports `game:HttpGet` and `loadstring`, the one-line launcher is:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/helpmefromschool/PRISM-RIVALS/main/ATELIER-COSMETICS/main.lua"))()
```

This launcher is **not supported by normal Roblox Studio LocalScripts**. Use local script source in Studio instead. Compatibility with any external runtime is untested. Review the public source before running. The repository is user-controlled and code may change on future updates.

## Technical notes

- Material changes and mesh texture hiding are reversible via `RESET` while the script remains active.
- The main script makes no game remotes or server requests.
- This project has **not been live-playtested in RIVALS or Real Executor**; do not interpret detection messages as proof the visual result was correct.
- All changes remain on the local client and are subject to game restrictions.