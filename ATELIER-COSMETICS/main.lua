-- ATELIER COSMETICS v0.3
-- Original client-side cosmetic finish changer; model compatibility varies.
-- Changes only local appearance of your equipped Tool or a matching Camera model.
-- Does NOT unlock cosmetics, change ownership, or replicate to other players.
-- Install: LocalScript in StarterPlayer > StarterPlayerScripts.

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
if not player then
    warn("ATELIER must run in a client LocalScript context")
    return
end

local playerGui = player:WaitForChild("PlayerGui")
local existing = playerGui:FindFirstChild("AtelierCosmetics")
if existing then existing:Destroy() end

local palette = {
    bg = Color3.fromRGB(17, 18, 23), side = Color3.fromRGB(21, 22, 29),
    pane = Color3.fromRGB(26, 27, 36), card = Color3.fromRGB(31, 33, 43),
    stroke = Color3.fromRGB(51, 54, 67), text = Color3.fromRGB(237, 239, 245),
    muted = Color3.fromRGB(151, 155, 171), accent = Color3.fromRGB(170, 149, 246),
}
local catalog = {
    {id="slate", name="Graphite", group="Finishes", tier="COMMON", color=Color3.fromRGB(73, 82, 95)},
    {id="aqua", name="Glacier", group="Finishes", tier="RARE", color=Color3.fromRGB(85, 175, 191)},
    {id="rose", name="Rose Quartz", group="Finishes", tier="RARE", color=Color3.fromRGB(208, 132, 160)},
    {id="amber", name="Amberglass", group="Finishes", tier="EPIC", color=Color3.fromRGB(223, 168, 92)},
    {id="violet", name="Night Orchid", group="Finishes", tier="EPIC", color=Color3.fromRGB(122, 103, 189)},
    {id="lime", name="Celadon", group="Finishes", tier="COMMON", color=Color3.fromRGB(130, 177, 137)},
    {id="pin", name="Pinpoint", group="Accents", tier="COMMON", color=Color3.fromRGB(190, 202, 214)},
    {id="orbit", name="Orbit", group="Accents", tier="RARE", color=Color3.fromRGB(103, 141, 223)},
    {id="prism", name="Prismatic", group="Accents", tier="EPIC", color=Color3.fromRGB(196, 110, 223)},
    {id="matte", name="Matte", group="Textures", tier="COMMON", color=Color3.fromRGB(101, 110, 123)},
    {id="copper", name="Brushed Copper", group="Textures", tier="RARE", color=Color3.fromRGB(191, 116, 83)},
    {id="pearl", name="Opaline", group="Textures", tier="EPIC", color=Color3.fromRGB(197, 209, 221)},
}
-- Finishes for local recoloring; not official RIVALS item skins.
for _, item in ipairs(catalog) do
    item.material = ({
        slate = Enum.Material.Metal, aqua = Enum.Material.SmoothPlastic,
        rose = Enum.Material.SmoothPlastic, amber = Enum.Material.Glass,
        violet = Enum.Material.Metal, lime = Enum.Material.SmoothPlastic,
        pin = Enum.Material.Metal, orbit = Enum.Material.Metal,
        prism = Enum.Material.Neon, matte = Enum.Material.SmoothPlastic,
        copper = Enum.Material.Metal, pearl = Enum.Material.SmoothPlastic,
    })[item.id]
    item.reflectance = (item.id == "amber" or item.id == "pearl") and 0.12 or 0.02
end
-- Unlock All is deliberately scoped to the 12 ORIGINAL ATELIER finishes.
-- It does not claim ownership of skins in RIVALS or any other game.
local starterFinishes = {slate = true, aqua = true, lime = true, matte = true}
local unlockAllLocal = false
local function isAvailable(item)
    return unlockAllLocal or starterFinishes[item.id] == true
end
local selected = catalog[1]
local activeGroup = "All"
local searchTerm = ""
local opened = true
local connections = {}

-- ATELIER appearance engine v0.3
-- Inlined into main.lua on release. Own-character / own-camera local cosmetics only.
local appearance = {
    applied = {}, -- [BasePart] = original snapshot
    targetMode = "Tool", -- Tool or Camera
    enabled = true,
    lastReport = "Not applied",
}

local function safeSet(instance, property, value)
    local ok = pcall(function() instance[property] = value end)
    return ok
end

local function equippedTool()
    local character = player.Character
    if not character then return nil end
    return character:FindFirstChildOfClass("Tool")
end

local function cameraModels()
    local camera = workspace.CurrentCamera
    if not camera then return {} end
    local result = {}
    for _, child in ipairs(camera:GetChildren()) do
        if child:IsA("Model") and not child:IsA("WorldModel") then
            table.insert(result, child)
        end
    end
    return result
end

local function rootsForMode()
    if appearance.targetMode == "Tool" then
        local tool = equippedTool()
        return tool and {tool} or {}, tool and tool.Name or "No tool equipped"
    end
    local matches = {}
    local tool = equippedTool()
    local name = tool and string.lower(tool.Name) or nil
    for _, model in ipairs(cameraModels()) do
        local modelName = string.lower(model.Name)
        local match = name and string.find(modelName, name, 1, true)
        if not match and name then
            for _, desc in ipairs(model:GetDescendants()) do
                if desc:IsA("Model") and string.lower(desc.Name) == name then
                    match = true
                    break
                end
            end
        end
        if match or (not name and (modelName == "viewmodel" or modelName == "view_model")) then
            table.insert(matches, model)
        end
    end
    if #matches == 0 then return {}, "No matching camera model" end
    return matches, "Camera model"
end

local function saveOriginal(part)
    if appearance.applied[part] then return end
    local snapshot = {
        color = part.Color,
        material = part.Material,
        reflectance = part.Reflectance,
        variant = part.MaterialVariant,
        texture = part:IsA("MeshPart") and part.TextureID or nil,
        special = {},
        surfaces = {},
    }
    for _, child in ipairs(part:GetChildren()) do
        if child:IsA("SurfaceAppearance") then
            table.insert(snapshot.surfaces, child)
        elseif child:IsA("SpecialMesh") then
            snapshot.special[child] = child.TextureId
        end
    end
    appearance.applied[part] = snapshot
end

local function restoreAll()
    local count = 0
    for part, original in pairs(appearance.applied) do
        if part and part.Parent then
            safeSet(part, "Color", original.color)
            safeSet(part, "Material", original.material)
            safeSet(part, "Reflectance", original.reflectance)
            safeSet(part, "MaterialVariant", original.variant)
            if original.texture ~= nil then safeSet(part, "TextureID", original.texture) end
            for mesh, texture in pairs(original.special) do
                if mesh.Parent then safeSet(mesh, "TextureId", texture) end
            end
            for _, surface in ipairs(original.surfaces) do
                if surface and surface.Parent == nil then pcall(function() surface.Parent = part end) end
            end
            count += 1
        end
        appearance.applied[part] = nil
    end
    return count
end

local function applyPart(part, finish)
    if not part:IsA("BasePart") then return false end
    local lower = string.lower(part.Name)
    if lower == "humanoidrootpart" or lower == "lefthand" or lower == "righthand"
        or lower == "leftarm" or lower == "rightarm" or lower == "leftlowerarm"
        or lower == "rightlowerarm" or lower == "leftupperarm" or lower == "rightupperarm"
        or lower == "head" then return false end
    saveOriginal(part)
    -- Hide UV textures ONLY for our original color/material finishes; originals are restored by Reset.
    if part:IsA("MeshPart") then safeSet(part, "TextureID", "") end
    for _, child in ipairs(part:GetChildren()) do
        if child:IsA("SpecialMesh") then safeSet(child, "TextureId", "") end
        if child:IsA("SurfaceAppearance") then pcall(function() child.Parent = nil end) end
    end
    local ok = safeSet(part, "Color", finish.color)
    safeSet(part, "Material", finish.material or Enum.Material.SmoothPlastic)
    safeSet(part, "MaterialVariant", "")
    safeSet(part, "Reflectance", finish.reflectance or 0)
    return ok
end

local function applyNow(finish)
    restoreAll()
    local roots, targetName = rootsForMode()
    if #roots == 0 then
        appearance.lastReport = targetName .. " — nothing changed"
        return false, appearance.lastReport
    end
    local count = 0
    for _, root in ipairs(roots) do
        for _, desc in ipairs(root:GetDescendants()) do
            if desc:IsA("BasePart") and applyPart(desc, finish) then count += 1 end
        end
        if root:IsA("BasePart") and applyPart(root, finish) then count += 1 end
    end
    if count == 0 then
        appearance.lastReport = "No compatible parts found — nothing changed"
        return false, appearance.lastReport
    end
    appearance.lastReport = ("Changed %d part(s) on %s (local)"):format(count, targetName)
    return true, appearance.lastReport
end

local function diagnosticTargets()
    local tool = equippedTool()
    local models = cameraModels()
    local names = {}
    for _, model in ipairs(models) do table.insert(names, model.Name) end
    local msg = ("Equipped tool: %s | Camera models: %s"):format(
        tool and tool.Name or "none", #names > 0 and table.concat(names, ", ") or "none")
    print("[ATELIER] " .. msg)
    return msg
end

local function make(className, props, parent)
    local object = Instance.new(className)
    for key, val in pairs(props or {}) do object[key] = val end
    object.Parent = parent
    return object
end
local function corner(parent, radius)
    make("UICorner", {CornerRadius=UDim.new(0, radius or 6)}, parent)
end
local function line(parent, col)
    make("UIStroke", {Color=col or palette.stroke, Transparency=0.15, Thickness=1}, parent)
end
local function label(parent, text, size, color, weight)
    return make("TextLabel", {
        BackgroundTransparency=1, Text=text, TextColor3=color or palette.text,
        Font=weight and Enum.Font.GothamBold or Enum.Font.Gotham,
        TextSize=size or 13, TextXAlignment=Enum.TextXAlignment.Left,
        TextYAlignment=Enum.TextYAlignment.Center,
    }, parent)
end
local function button(parent, text, bg, fg)
    local b = make("TextButton", {
        Text=text, Font=Enum.Font.GothamMedium, TextSize=12,
        TextColor3=fg or palette.text, BackgroundColor3=bg or palette.card,
        BorderSizePixel=0, AutoButtonColor=false,
    }, parent)
    corner(b, 5)
    return b
end

local gui = make("ScreenGui", {
    Name="AtelierCosmetics", ResetOnSpawn=false, IgnoreGuiInset=true,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
}, playerGui)
local shade = make("Frame", {
    Size=UDim2.fromScale(1,1), BackgroundColor3=Color3.new(0,0,0),
    BackgroundTransparency=.52, BorderSizePixel=0,
}, gui)
local window = make("Frame", {
    Name="Window", Size=UDim2.fromOffset(790, 570),
    AnchorPoint=Vector2.new(.5,.5), Position=UDim2.fromScale(.5,.5),
    BackgroundColor3=palette.bg, BorderSizePixel=0,
}, gui)
corner(window, 8); line(window)
local scale = make("UIScale", {Scale=1}, window)
local function updateScale()
    local camera = workspace.CurrentCamera
    if not camera then return end
    local s = camera.ViewportSize
    scale.Scale = math.min(1, (s.X - 24)/790, (s.Y - 24)/570)
end
updateScale()
if workspace.CurrentCamera then
    table.insert(connections, workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale))
end

local header = make("Frame", {Size=UDim2.new(1,0,0,63), BackgroundColor3=palette.side, BorderSizePixel=0}, window)
corner(header,8)
make("Frame", {Size=UDim2.new(1,0,0,8), Position=UDim2.new(0,0,1,-8), BackgroundColor3=palette.side, BorderSizePixel=0}, header)
local wordmark = label(header, "ATELIER", 20, palette.text, true)
wordmark.Position=UDim2.fromOffset(23,13); wordmark.Size=UDim2.fromOffset(220,24)
local subtitle = label(header, "C O S M E T I C   L A B  /  0.3", 9, palette.muted)
subtitle.Position=UDim2.fromOffset(24,38); subtitle.Size=UDim2.fromOffset(250,14)
local exit = button(header, "×", palette.pane, palette.muted)
exit.Position=UDim2.new(1,-49,0,16); exit.Size=UDim2.fromOffset(31,31)

local sidebar=make("Frame", {Position=UDim2.fromOffset(0,63), Size=UDim2.new(0,170,1,-63), BackgroundColor3=palette.side, BorderSizePixel=0}, window)
local sideTitle=label(sidebar,"BROWSE",10,palette.muted,true)
sideTitle.Position=UDim2.fromOffset(22,21); sideTitle.Size=UDim2.fromOffset(120,16)
local nav={}
for index, group in ipairs({"All","Finishes","Accents","Textures"}) do
    local b=button(sidebar,group,palette.side,palette.muted)
    b.Position=UDim2.fromOffset(13,49+(index-1)*44); b.Size=UDim2.fromOffset(145,36)
    b.TextXAlignment=Enum.TextXAlignment.Left
    b.Text="    "..group
    nav[group]=b
end
local unlockButton = button(sidebar, "UNLOCK ALL (LOCAL)", palette.card, palette.text)
unlockButton.Position = UDim2.fromOffset(13, 248)
unlockButton.Size = UDim2.fromOffset(145, 37)
line(unlockButton)
local unlockNote=label(sidebar,"4 / 12 finishes available",10,palette.muted)
unlockNote.Position=UDim2.fromOffset(19,294); unlockNote.Size=UDim2.fromOffset(145,24)
local demo=label(sidebar,"LOCAL VISUALS ONLY\nNo inventory unlocks",10,palette.muted)
demo.Position=UDim2.new(0,20,1,-67); demo.Size=UDim2.fromOffset(145,40)
demo.TextYAlignment=Enum.TextYAlignment.Top

local listPane=make("Frame", {Position=UDim2.fromOffset(170,63), Size=UDim2.new(0,386,1,-63), BackgroundTransparency=1}, window)
local search=make("TextBox", {
    Position=UDim2.fromOffset(18,17),Size=UDim2.fromOffset(350,34),
    BackgroundColor3=palette.pane, TextColor3=palette.text,
    PlaceholderColor3=palette.muted,PlaceholderText="Search cosmetics...",
    Text="",ClearTextOnFocus=false,Font=Enum.Font.Gotham,TextSize=12,
    TextXAlignment=Enum.TextXAlignment.Left,BorderSizePixel=0,
},listPane)
corner(search,5); line(search)
make("UIPadding",{PaddingLeft=UDim.new(0,13)},search)
local browseTitle=label(listPane,"ALL COSMETICS",11,palette.muted,true)
browseTitle.Position=UDim2.fromOffset(18,62);browseTitle.Size=UDim2.fromOffset(300,20)
local scroll=make("ScrollingFrame", {
    Position=UDim2.fromOffset(18,88),Size=UDim2.new(1,-36,1,-104),
    BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,
    ScrollBarImageColor3=palette.stroke,CanvasSize=UDim2.fromOffset(0,0),
},listPane)
local grid=make("UIGridLayout", {
    CellSize=UDim2.fromOffset(166,86),CellPadding=UDim2.fromOffset(10,10),
    SortOrder=Enum.SortOrder.LayoutOrder,
},scroll)
table.insert(connections,grid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize=UDim2.fromOffset(0,grid.AbsoluteContentSize.Y+4)
end))

local previewPane=make("Frame", {Position=UDim2.fromOffset(556,63),Size=UDim2.new(1,-556,1,-63),BackgroundColor3=palette.pane,BorderSizePixel=0},window)
local pvTitle=label(previewPane,"PREVIEW",10,palette.muted,true)
pvTitle.Position=UDim2.fromOffset(18,18);pvTitle.Size=UDim2.fromOffset(180,20)
local pvBox=make("Frame", {Position=UDim2.fromOffset(18,49),Size=UDim2.new(1,-36,0,188),BackgroundColor3=palette.card,BorderSizePixel=0},previewPane)
corner(pvBox,6);line(pvBox)
local swatch=make("Frame", {AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromOffset(110,110),BackgroundColor3=selected.color,BorderSizePixel=0,Rotation=-12},pvBox)
corner(swatch,16)
local swatchInner=make("Frame", {Position=UDim2.fromOffset(11,11),Size=UDim2.new(1,-22,1,-22),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=.85,BorderSizePixel=0},swatch)
corner(swatchInner,12)
local pvName=label(previewPane,selected.name,17,palette.text,true)
pvName.Position=UDim2.fromOffset(18,257);pvName.Size=UDim2.new(1,-36,0,30)
local pvTier=label(previewPane,selected.tier,10,palette.accent,true)
pvTier.Position=UDim2.fromOffset(19,290);pvTier.Size=UDim2.new(1,-36,0,15)
local note=label(previewPane,"Local finish only. Actual skin assets\nneed a game-specific adapter.",10,palette.muted)
note.Position=UDim2.fromOffset(18,306);note.Size=UDim2.new(1,-36,0,35)
note.TextWrapped=true;note.TextYAlignment=Enum.TextYAlignment.Top
local apply=button(previewPane,"APPLY FINISH",palette.accent,palette.bg)
apply.Position=UDim2.fromOffset(18,460);apply.Size=UDim2.new(1,-36,0,36)
local reset=button(previewPane,"RESET",palette.card,palette.text)
reset.Position=UDim2.fromOffset(18,416);reset.Size=UDim2.fromOffset(94,34)
local target=button(previewPane,"TARGET: TOOL",palette.card,palette.text)
target.Position=UDim2.fromOffset(122,416);target.Size=UDim2.new(1,-140,0,34)
local diagnostic=button(previewPane,"FIND MODELS",palette.card,palette.muted)
diagnostic.Position=UDim2.fromOffset(18,351);diagnostic.Size=UDim2.new(1,-36,0,27)
local autoOn = true
local autoButton=button(previewPane,"AUTO: ON",palette.card,palette.muted)
autoButton.Position=UDim2.fromOffset(18,382);autoButton.Size=UDim2.new(1,-36,0,27)
local status=label(listPane,"READY  •  RIGHT SHIFT TO TOGGLE",10,palette.muted)
status.Position=UDim2.fromOffset(18,0);status.AnchorPoint=Vector2.new(0,1)
status.Size=UDim2.new(1,-36,0,14);status.Position=UDim2.new(0,18,1,-8)

local function refreshNav()
    for group,b in pairs(nav) do
        b.BackgroundColor3=group==activeGroup and palette.card or palette.side
        b.TextColor3=group==activeGroup and palette.text or palette.muted
    end
end
local function selectItem(item)
    if not isAvailable(item) then
        status.Text = "FINISH LOCKED IN DEMO - CLICK UNLOCK ALL (LOCAL)"
        status.TextColor3 = palette.muted
        return
    end
    selected=item
    pvName.Text=item.name
    pvTier.Text=item.tier.."  /  "..string.upper(item.group)
    TweenService:Create(swatch,TweenInfo.new(.2,Enum.EasingStyle.Quad),{BackgroundColor3=item.color,Rotation=0}):Play()
    task.delay(.22,function() if swatch.Parent then TweenService:Create(swatch,TweenInfo.new(.24,Enum.EasingStyle.Quad),{Rotation=-12}):Play() end end)
end
local function refreshCards()
    for _,child in ipairs(scroll:GetChildren()) do
        if child:IsA("GuiObject") then child:Destroy() end
    end
    local count=0
    for _,item in ipairs(catalog) do
        if (activeGroup=="All" or item.group==activeGroup) and (searchTerm=="" or string.find(string.lower(item.name),searchTerm,1,true)) then
            count+=1
            local locked = not isAvailable(item)
            local card=button(scroll,"",palette.card,palette.text)
            card.LayoutOrder=count
            card.Text=""
            line(card)
            local sample=make("Frame",{Position=UDim2.fromOffset(10,11),Size=UDim2.fromOffset(49,62),BackgroundColor3=item.color,BorderSizePixel=0},card)
            corner(sample,5)
            if locked then
                sample.BackgroundTransparency = .64
            end
            local name=label(card,item.name,11,locked and palette.muted or palette.text,true)
            name.Position=UDim2.fromOffset(68,17);name.Size=UDim2.fromOffset(88,28);name.TextWrapped=true
            local tier=label(card,item.tier,9,palette.muted)
            tier.Text = locked and "LOCKED / " .. item.tier or item.tier
            tier.Position=UDim2.fromOffset(68,52);tier.Size=UDim2.fromOffset(96,15)
            card.MouseButton1Click:Connect(function() selectItem(item) end)
        end
    end
    browseTitle.Text=string.upper(activeGroup).."  /  "..count
end
unlockButton.MouseButton1Click:Connect(function()
    if unlockAllLocal then
        status.Text = "ALL 12 ATELIER FINISHES ALREADY AVAILABLE (LOCAL)"
        return
    end
    unlockAllLocal = true
    unlockButton.Text = "ALL FINISHES AVAILABLE"
    unlockButton.BackgroundColor3 = Color3.fromRGB(42, 78, 65)
    unlockButton.TextColor3 = Color3.fromRGB(216, 249, 232)
    unlockNote.Text = tostring(#catalog) .. " / " .. tostring(#catalog) .. " finishes available"
    status.Text = "UNLOCKED ALL LOCAL FINISH PREVIEWS - NO ACCOUNT CHANGES"
    status.TextColor3 = palette.muted
    refreshCards()
end)
for group,b in pairs(nav) do
    b.MouseButton1Click:Connect(function() activeGroup=group;refreshNav();refreshCards() end)
end
search:GetPropertyChangedSignal("Text"):Connect(function()
    searchTerm=string.lower(search.Text)
    refreshCards()
end)
local activeFinish = nil
local rememberTargets
local function showStatus(message)
    status.Text = message
    status.TextColor3 = palette.muted
end
apply.MouseButton1Click:Connect(function()
    if not isAvailable(selected) then
        showStatus("Selected finish is locked in this demo")
        return
    end
    local ok, result = applyNow(selected)
    activeFinish = ok and selected or nil
    if ok then rememberTargets() end
    showStatus(result)
end)
reset.MouseButton1Click:Connect(function()
    local count = restoreAll()
    activeFinish = nil
    showStatus(("Restored %d part(s)"):format(count))
end)
target.MouseButton1Click:Connect(function()
    restoreAll()
    activeFinish = nil
    appearance.targetMode = appearance.targetMode == "Tool" and "Camera" or "Tool"
    target.Text = appearance.targetMode == "Tool" and "TARGET: TOOL" or "TARGET: CAMERA"
    showStatus("Target changed. Select APPLY FINISH.")
end)
diagnostic.MouseButton1Click:Connect(function()
    showStatus(diagnosticTargets())
end)
autoButton.MouseButton1Click:Connect(function()
    autoOn = not autoOn
    autoButton.Text = autoOn and "AUTO: ON" or "AUTO: OFF"
    showStatus(autoOn and "Automatic reapply enabled" or "Automatic reapply disabled")
end)
-- On weapon equip / respawn, automatically reapply the chosen finish. No remote calls.
local lastTargets = {}
local lastCounts = {}
local function targetsHaveChanged()
    local roots = rootsForMode()
    if #roots ~= #lastTargets then return true end
    for i, root in ipairs(roots) do
        if lastTargets[i] ~= root or lastCounts[i] ~= #root:GetDescendants() then
            return true
        end
    end
    return false
end
rememberTargets = function()
    local roots = rootsForMode()
    table.clear(lastTargets)
    table.clear(lastCounts)
    for i, root in ipairs(roots) do
        lastTargets[i] = root
        lastCounts[i] = #root:GetDescendants()
    end
end
local alive = true
task.spawn(function()
    while alive and gui.Parent do
        task.wait(1)
        if autoOn and activeFinish then
            if targetsHaveChanged() then
                local ok = applyNow(activeFinish)
                if ok then rememberTargets() end
            end
        end
    end
end)
local function setOpen(nextOpen)
    opened=nextOpen
    window.Visible=opened
    shade.Visible=opened
end
exit.MouseButton1Click:Connect(function() setOpen(false) end)
table.insert(connections,UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode==Enum.KeyCode.RightShift then setOpen(not opened) end
end))
-- Drag using the title bar, while retaining the scale and its original anchor.
local dragging=false
local dragStart,positionStart
header.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        dragging=true;dragStart=input.Position;positionStart=window.Position
    end
end)
header.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end
end)
table.insert(connections,UIS.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
        local d=input.Position-dragStart
        window.Position=UDim2.new(positionStart.X.Scale,positionStart.X.Offset+d.X,positionStart.Y.Scale,positionStart.Y.Offset+d.Y)
    end
end))
gui.Destroying:Connect(function()
    alive = false
    restoreAll()
    for _, connection in ipairs(connections) do connection:Disconnect() end
end)
refreshNav()
refreshCards()
selectItem(selected)
print("ATELIER v0.3 loaded: local finish changer ready. Equip a Tool, then Apply Finish. Right Shift toggles the panel.")