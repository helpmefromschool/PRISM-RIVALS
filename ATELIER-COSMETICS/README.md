# ATELIER COSMETICS v0.5 (Original Local Cosmetic Prototype)

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


## Native Roblox RIVALS cosmetic UI padlock visual test (v0.5)

This experimental **local UI-only** tool hides repeated padlock *images* in the actual in-game PlayerGui. **It does not** make locked game cosmetics selectable, grant real inventory ownership, activate finishers, or change server state. If the game draws a lock as part of a single texture or checks ownership before allowing selection, this feature cannot bypass that.

1. Open the RIVALS cosmetic collection first, then open ATELIER using Right Shift.
2. Press **UNLOCK ALL** once. This makes all 12 ATELIER finishes selectable and attempts to hide recognizably named local cosmetic padlock graphics.
3. Read ATELIER's status line. It shows the number of lock icons hidden. Zero means no identifiable icons were found; **no ownership or in-game availability changed**.
4. If zero icons were detected, press **LEARN PADLOCK**, hover over a padlock graphic in the game, and press L. Reopen ATELIER using Right Shift.
5. **HIDE LOCKS: ON/OFF** restores/reapplies the visual change. Closing/destroying ATELIER attempts to restore the changed GUI visibility properties.

Implementation: the first pass scans PlayerGui for small GUI icons explicitly named as locks or visibly labeled LOCKED; the fallback uses PlayerGui:GetGuiObjectsAtPosition to learn the image ID and sprite coordinates from a hovered lock. Subsequent matching UI objects are hidden locally, including newly loaded badges. If a lock is drawn into a card image, uses an unnamed sprite, or is re-created by the game, this may show zero results or have no visible effect. If no suitable object is detected, **no RIVALS UI is modified**. It may not work with every type of lock overlay. Don't treat the result as an actual unlock.

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
## Research status and limitations

- Roblox documents PlayerGui:GetGuiObjectsAtPosition for graphical hit-testing; it **does not** reveal an image's meaning or override eligibility/ownership checks: https://create.roblox.com/docs/reference/engine/classes/BasePlayerGui
- Roblox's server/client boundary keeps authoritative game inventory separate from a local visual UI: https://create.roblox.com/docs/scripting/security/client-server-boundary
- The public Martini engine (https://github.com/Martinikaws/RivalsSkinChangerFULLMATCHA) describes cosmetic *substitution* with a cosmetic you already own. It does not establish a verified Yabujin-style full unlock method.
- A Yabujin product description calling itself an unlock-all is not proof of its mechanism. We have not verified Yabujin's protected implementation.
- **No authenticated or server-side unlock is attempted by ATELIER.** This feature currently changes cosmetic preview availability within ATELIER and possibly the appearance of standalone GUI padlocks. It is not a working RIVALS skin/finisher unlock-all.
- ATELIER v0.5 has been statically inspected after publishing. No live RIVALS/Real Executor test has been performed.
