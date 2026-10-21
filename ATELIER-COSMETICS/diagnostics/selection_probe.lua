-- ATELIER / RIVALS Cosmetic Selection Diagnostic v0.1
-- READ-ONLY. Captures public cosmetic-menu GUI information under your cursor.
-- No purchases, equip calls, server remotes, memory access, hooks, or unlock attempts.
-- Use in a client LocalScript in a Roblox Studio experience you control.
-- External execution environments have not been tested.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local player = Players.LocalPlayer
if not player then warn("[ATELIER PROBE] Requires a client context") return end
local playerGui = player:WaitForChild("PlayerGui", 10)
if not playerGui then warn("[ATELIER PROBE] PlayerGui unavailable") return end

-- Running the probe again disconnects the previous instance, if any.
if type(_G.__ATELIER_SELECTION_PROBE_STOP) == "function" then
    pcall(_G.__ATELIER_SELECTION_PROBE_STOP)
end

local reports = {}
local live = true
local inputConnection
local maximumLinesPerCapture = 75
local function safeProp(obj, key)
    local ok, value = pcall(function() return obj[key] end)
    if not ok then return "n/a" end
    if type(value) == "boolean" then return tostring(value) end
    if typeof(value) == "Vector2" then return string.format("%.0f,%.0f", value.X, value.Y) end
    if typeof(value) == "UDim2" then return tostring(value) end
    return tostring(value)
end
local function clean(s, limit)
    s = tostring(s or ""):gsub("[%c]", " ")
    return s:sub(1, limit or 80)
end
local function trimText(s)
    s = clean(s, 50)
    -- We collect text only around the hovered cosmetic card. Review logs
    -- before sharing; redact any player names that appear in your GUI.
    return s
end
local function relativePath(obj)
    local parts = {}
    local node = obj
    for _ = 1, 6 do
        if not node or node == playerGui then break end
        table.insert(parts, 1, clean(node.Name, 32))
        node = node.Parent
    end
    return "PlayerGui/" .. table.concat(parts, "/")
end
local function objLine(obj)
    if not obj or not obj.Parent then return "<deleted>" end
    local fields = {
        clean(obj.ClassName, 35) .. " " .. relativePath(obj),
        "visible=" .. safeProp(obj,"Visible"),
        "active=" .. safeProp(obj,"Active"),
        "interactable=" .. safeProp(obj,"Interactable"),
        "selectable=" .. safeProp(obj,"Selectable"),
        "z=" .. safeProp(obj,"ZIndex"),
    }
    if obj:IsA("TextLabel") or obj:IsA("TextButton") then
        table.insert(fields,"text='" .. trimText(safeProp(obj,"Text")) .. "'")
    elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
        table.insert(fields,"image=" .. clean(safeProp(obj,"Image"),56))
        table.insert(fields,"sprite=" .. safeProp(obj,"ImageRectOffset") .. "|" .. safeProp(obj,"ImageRectSize"))
    end
    return table.concat(fields," | ")
end
local function underCursor()
    local p = UserInputService:GetMouseLocation()
    local inset = Vector2.new(0,0)
    pcall(function() inset = GuiService:GetGuiInset() end)
    local locations = {p-inset, p}
    local result, seen = {}, {}
    for _, at in ipairs(locations) do
        local ok, list = pcall(function()
            return playerGui:GetGuiObjectsAtPosition(math.floor(at.X),math.floor(at.Y))
        end)
        if ok and type(list)=="table" then
            for _, obj in ipairs(list) do
                if not seen[obj] then
                    seen[obj]=true
                    table.insert(result,obj)
                end
            end
        end
    end
    return result, p
end
local function likelyCard(objects)
    for _, obj in ipairs(objects) do
        local node = obj
        for _ = 1,7 do
            if not node or node==playerGui then break end
            if node:IsA("GuiObject") then
                local sz = node.AbsoluteSize
                if sz.X>=54 and sz.Y>=54 and sz.X<=310 and sz.Y<=310 then
                    return node
                end
            end
            node=node.Parent
        end
    end
    return nil
end
local function knownFlagSummary(obj)
    local names = {"Locked","Lock","Owned","Unlocked","Equipped","Selected","Selectable","Available","Purchased"}
    local parts={}
    for _, key in ipairs(names) do
        local ok, v=pcall(function() return obj:GetAttribute(key) end)
        if ok and v ~= nil and (type(v)=="boolean" or type(v)=="number") then
            table.insert(parts,key.."="..tostring(v))
        end
    end
    return #parts>0 and table.concat(parts,", ") or "(none of the known boolean/numeric flags)"
end
local function sceneLine()
    local viewmodels=workspace:FindFirstChild("ViewModels")
    local first=viewmodels and viewmodels:FindFirstChild("FirstPerson")
    local children={}
    if first then
        for _, obj in ipairs(first:GetChildren()) do
            table.insert(children, clean(obj.Name,40).." ["..obj.ClassName.."]")
            if #children>=8 then break end
        end
    end
    local cam=workspace.CurrentCamera
    local cams={}
    if cam then
        for _,obj in ipairs(cam:GetChildren()) do
            if obj:IsA("Model") then table.insert(cams,clean(obj.Name,40)) end
            if #cams>=8 then break end
        end
    end
    return "FIRST-PERSON DISPLAY: "..(#children>0 and table.concat(children,", ") or "none")
        .." | CAMERA MODELS: "..(#cams>0 and table.concat(cams,", ") or "none")
end
local function snapshot(label)
    local hover,pos = underCursor()
    local log = {}
    local function add(s)
        if #log < maximumLinesPerCapture then table.insert(log,s) end
    end
    add("== "..label.." ==")
    add("Cursor "..math.floor(pos.X)..","..math.floor(pos.Y).."; GUI objects under cursor: "..#hover)
    for i=1,math.min(9,#hover) do add("HOVER["..i.."] "..objLine(hover[i])) end
    local card=likelyCard(hover)
    if card then
        add("POSSIBLE CARD: "..objLine(card))
        add("CARD FLAGS: "..knownFlagSummary(card))
        local count=0
        for _, child in ipairs(card:GetDescendants()) do
            if child:IsA("GuiObject") and count<18 then
                if child:IsA("TextLabel") or child:IsA("TextButton")
                    or child:IsA("ImageLabel") or child:IsA("ImageButton") then
                    count+=1
                    add("CHILD["..count.."] "..objLine(child))
                    local flags=knownFlagSummary(child)
                    if flags:sub(1,5) ~= "(none" then add("FLAGS "..flags) end
                end
            end
        end
    else add("POSSIBLE CARD: none (keep cursor over a single cosmetic card)") end
    add(sceneLine())
    local text = table.concat(log,"\n")
    table.insert(reports,text)
    print("[ATELIER PROBE] "..text:gsub("\n","\n[ATELIER PROBE] "))
    return text
end
local function exportReport()
    if #reports==0 then print("[ATELIER PROBE] No captures yet") return end
    local out="ATELIER COSMETIC UI COMPARISON (READ-ONLY)\n"..table.concat(reports,"\n\n")
    print("[ATELIER PROBE] FULL REPORT:\n"..out)
    if type(setclipboard)=="function" then
        local ok=pcall(setclipboard,out)
        print(ok and "[ATELIER PROBE] Copied report to clipboard; review before sharing."
            or "[ATELIER PROBE] Clipboard failed; use output instead.")
    else
        print("[ATELIER PROBE] No clipboard function; copy the FULL REPORT from output.")
    end
end
inputConnection=UserInputService.InputBegan:Connect(function(input)
    if not live or UserInputService:GetFocusedTextBox() then return end
    if input.KeyCode==Enum.KeyCode.F6 then snapshot("AVAILABLE / BEFORE CLICK")
    elseif input.KeyCode==Enum.KeyCode.F7 then snapshot("AVAILABLE / AFTER CLICK")
    elseif input.KeyCode==Enum.KeyCode.F8 then snapshot("LOCKED / BEFORE CLICK")
    elseif input.KeyCode==Enum.KeyCode.F9 then snapshot("LOCKED / AFTER CLICK")
    elseif input.KeyCode==Enum.KeyCode.F10 then exportReport() end
end)
_G.__ATELIER_SELECTION_PROBE_STOP=function()
    live=false
    if inputConnection then inputConnection:Disconnect() inputConnection=nil end
    if _G.__ATELIER_SELECTION_PROBE_STOP then _G.__ATELIER_SELECTION_PROBE_STOP=nil end
end
print("[ATELIER PROBE] Ready. Hover a cosmetic card and press F6 (available BEFORE), click it then F7 (AFTER).")
print("[ATELIER PROBE] Hover a locked card and press F8 (BEFORE), click it then F9 (AFTER). Press F10 for full report.")
print("[ATELIER PROBE] No changes or remote calls. Review logs for player names before sharing.")