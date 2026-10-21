# ATELIER Cosmetic UI Selection Probe v0.1

Read-only, original diagnostic to compare GUI behavior for an available cosmetic versus a locked one. This is not a skin changer, unlocker, or RIVALS exploit. It does not click any button or change ownership/selection state.

## Steps

1. In the cosmetic menu, hover over an **available** item's card and press **F6** (before selecting).
2. Click that available item normally, leave the pointer on its card, and press **F7** (after selecting).
3. Hover over a **locked** item's card and press **F8** (before).
4. Click that locked item normally, leave the pointer in place, and press **F9** (after).
5. Press **F10** to print a consolidated report and copy it if `setclipboard` is available. Review before sharing; remove personal names if present.

The report includes a small number of GUI elements under the mouse, typical UI properties (`Visible`, `Active`, `Selectable`, `Interactable`), displayed labels/icon IDs, optional boolean cosmetic attributes, and the names of locally visible preview models. No private user identifiers, account credentials, remote calls, privileged memory access, or file writes are performed by the script.

## Execution

Use as a client `LocalScript` in `StarterPlayerScripts` in an experience you control. In other environments, the normal Roblox client APIs used here may not be exposed; **executor compatibility is not verified**. The script itself does not contain or download third-party loaders. Re-running replaces the previous listener. Run `_G.__ATELIER_SELECTION_PROBE_STOP()` to stop the listener if it is present.

The GitHub-hosted source is inspectable at `ATELIER-COSMETICS/diagnostics/selection_probe.lua`.