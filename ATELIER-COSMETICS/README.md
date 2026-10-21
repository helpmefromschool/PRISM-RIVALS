# ATELIER COSMETICS v0.2 — Local finish changer

A standalone **original** Roblox client-side cosmetic **finish changer**. This is a new project, separate from PRISM; it does not include protected Yabujin code.

## What this first functional build does

- Changes the visible color/material/reflectance of compatible `BasePart` and `MeshPart` objects on your **locally equipped Tool**, or on a matching local `CurrentCamera` viewmodel.
- Temporarily hides existing mesh textures and SurfaceAppearance from those target parts while showing the selected original finish.
- Has 12 original finishes, searchable cards, tabs, a preview, a target-mode selector, Reset, and Find Models diagnostic.
- Automatically reapplies chosen finish after a compatible target model changes, once per second. Right Shift toggles the menu.
- Snapshots and restores original appearance of changed parts using Reset, or when the menu script is destroyed/reloaded.
- Only changes *client-side presentation*. No permanent item unlocks, purchase requests, server modifications, or affecting other players.

## What it does NOT yet do

- These are **original color/material finishes**, not the official skin assets/catalog of any third-party Roblox game. Proper themed skins need their own model/texture assets and game-specific asset mappings.
- Camera mode requires an equipped tool name matching the camera model/descendant, or a camera model named `Viewmodel`/`View_Model` when no tool is equipped.
- **Not verified with Roblox RIVALS or Real Executor**. If no compatible tool or camera model is found, the GUI reports that nothing changed. It does not pretend to succeed.
- Does not bypass anticheat/security controls, hook protected methods, or call remotes.

## Test in your own Roblox Studio experience

1. Place the contents of `main.lua` in a **LocalScript** under `StarterPlayer > StarterPlayerScripts`.
2. Place `DemoTool.server.lua` in a **Script** under `ServerScriptService` to spawn an original test Tool.
3. Play; equip the `ATELIER Test Tool` from your hotbar.
4. Open the ATELIER GUI, select a finish, click **APPLY FINISH**, then **RESET**. Switch finishes and equip/unequip to test automatic reapply.
5. Use **FIND MODELS** to see the equipped Tool and camera models in Studio Output.

## Known limitations

- A proprietary game can recreate its models or override client materials frequently. Those clients may not be compatible.
- Color/material changes will not reproduce UV-mapped pattern skins; that requires properly licensed textures/model assets, not just recolors.
- Animation, audio, and game-specific cosmetic effects are not included.
- The standalone script needs to be run client-side in an environment that supports standard Roblox LocalScript APIs. Executor compatibility is untested.

## Safety

No obfuscated code, external network requests, file-system access, hidden remotes, paid features, or elevated permissions. Public code may be inspected before use.