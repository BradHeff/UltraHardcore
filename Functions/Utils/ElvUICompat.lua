-- ElvUI Compatibility Module
-- This module provides functions to detect and hide ElvUI elements when UltraHardcore hides corresponding Blizzard UI elements
-- Track which ElvUI frames have been hidden to prevent repeated hiding
local elvUIFramesHidden = {}

-- Check if ElvUI is loaded
local function IsElvUILoaded()
    return ElvUI ~= nil
end

-- Check if ElvUI_mMediaTag is loaded
local function IsmMediaTagLoaded()
    return IsAddOnLoaded("ElvUI_mMediaTag")
end

-- Check if ElvUI_HoffUI is loaded
local function IsHoffUILoaded()
    return IsAddOnLoaded("ElvUI_HoffUI")
end

-- Check if ElvUI_EltreumUI is loaded
local function IsEltreumUILoaded()
    return IsAddOnLoaded("ElvUI_EltreumUI")
end

-- Generic function to safely hide ElvUI frames
local function SafeHideElvUIFrame(frameName)
    if not IsElvUILoaded() then
        return false
    end

    local frame = _G[frameName]
    if frame and frame.Hide then
        frame:Hide()
        return true
    end
    return false
end

-- Generic function to safely show ElvUI frames
local function SafeShowElvUIFrame(frameName)
    if not IsElvUILoaded() then
        return false
    end

    local frame = _G[frameName]
    if frame and frame.Show then
        frame:Show()
        return true
    end
    return false
end

-- Hide ElvUI Player Frame
function HideElvUIPlayerFrame()
    if not IsElvUILoaded() then
        return
    end
    if elvUIFramesHidden.player then
        return
    end -- Already hidden

    -- Try common ElvUI player frame names
    local playerFrames = {"ElvUI_Player", "ElvUF_Player", "ElvUI_PlayerFrame"}

    for _, frameName in ipairs(playerFrames) do
        local frame = _G[frameName]
        if frame then
            -- Override the Show function to prevent it from ever showing
            if not frame.originalShow then
                frame.originalShow = frame.Show
                frame.Show = function()
                end -- Block showing
            end
            frame:Hide()
            elvUIFramesHidden.player = frameName
            break
        end
    end

    -- Also try to hide via ElvUI API if available
    if ElvUI and ElvUI[1] and ElvUI[1].unitFrames then
        local UF = ElvUI[1].unitFrames
        if UF.units and UF.units.player then
            if not UF.units.player.originalShow then
                UF.units.player.originalShow = UF.units.player.Show
                UF.units.player.Show = function()
                end -- Block showing
            end
            UF.units.player:Hide()
            if not elvUIFramesHidden.player then
                elvUIFramesHidden.player = "API"
            end
        end
    end
end

-- Show ElvUI Player Frame
function ShowElvUIPlayerFrame()
    if not IsElvUILoaded() then
        return
    end
    if not elvUIFramesHidden.player then
        return
    end -- Not hidden by us

    -- Restore original Show functions and show the frames
    local playerFrames = {"ElvUI_Player", "ElvUF_Player", "ElvUI_PlayerFrame"}

    for _, frameName in ipairs(playerFrames) do
        local frame = _G[frameName]
        if frame and frame.originalShow then
            frame.Show = frame.originalShow
            frame.originalShow = nil
            frame:Show()
        end
    end

    -- Also try to restore via ElvUI API if available
    if ElvUI and ElvUI[1] and ElvUI[1].unitFrames then
        local UF = ElvUI[1].unitFrames
        if UF.units and UF.units.player and UF.units.player.originalShow then
            UF.units.player.Show = UF.units.player.originalShow
            UF.units.player.originalShow = nil
            UF.units.player:Show()
        end
    end

    elvUIFramesHidden.player = nil -- Mark as not hidden
end

-- Hide ElvUI Target Frame (and related frames)
function HideElvUITargetFrame()
    if not IsElvUILoaded() then
        return
    end
    if elvUIFramesHidden.target then
        return
    end -- Already hidden

    -- Try common ElvUI target frame names (including focus and target-of-target)
    local targetFrames = {"ElvUI_Target", "ElvUF_Target", "ElvUI_TargetFrame", "ElvUI_Focus", "ElvUF_Focus",
                          "ElvUI_FocusFrame", "ElvUI_TargetTarget", "ElvUF_TargetTarget", "ElvUI_TargetTargetFrame",
                          "ElvUI_TargetTargetTarget", "ElvUF_TargetTargetTarget"}

    local hiddenFrames = {}
    for _, frameName in ipairs(targetFrames) do
        local frame = _G[frameName]
        if frame then
            -- Override the Show function to prevent it from ever showing
            if not frame.originalShow then
                frame.originalShow = frame.Show
                frame.Show = function()
                end -- Block showing
            end
            frame:Hide()
            table.insert(hiddenFrames, frameName)
        end
    end

    -- Also try to hide via ElvUI API if available
    if ElvUI and ElvUI[1] and ElvUI[1].unitFrames then
        local UF = ElvUI[1].unitFrames
        local unitTypes = {"target", "focus", "targettarget", "targettargettarget"}

        for _, unitType in ipairs(unitTypes) do
            if UF.units and UF.units[unitType] then
                if not UF.units[unitType].originalShow then
                    UF.units[unitType].originalShow = UF.units[unitType].Show
                    UF.units[unitType].Show = function()
                    end -- Block showing
                end
                UF.units[unitType]:Hide()
                table.insert(hiddenFrames, "API:" .. unitType)
            end
        end
    end

    if #hiddenFrames > 0 then
        elvUIFramesHidden.target = hiddenFrames
    end
end

-- Show ElvUI Target Frame (and related frames)
function ShowElvUITargetFrame()
    if not IsElvUILoaded() then
        return
    end
    if not elvUIFramesHidden.target then
        return
    end -- Not hidden by us

    -- Restore frames that were hidden by name
    if type(elvUIFramesHidden.target) == "table" then
        for _, frameName in ipairs(elvUIFramesHidden.target) do
            if string.sub(frameName, 1, 4) == "API:" then
                -- Handle API-based frames
                local unitType = string.sub(frameName, 5)
                if ElvUI and ElvUI[1] and ElvUI[1].unitFrames then
                    local UF = ElvUI[1].unitFrames
                    if UF.units and UF.units[unitType] and UF.units[unitType].originalShow then
                        UF.units[unitType].Show = UF.units[unitType].originalShow
                        UF.units[unitType].originalShow = nil
                        UF.units[unitType]:Show()
                    end
                end
            else
                -- Handle direct frame references
                local frame = _G[frameName]
                if frame and frame.originalShow then
                    frame.Show = frame.originalShow
                    frame.originalShow = nil
                    frame:Show()
                end
            end
        end
    end

    elvUIFramesHidden.target = nil -- Mark as not hidden
end

-- Hide ElvUI Minimap
function HideElvUIMinimap()
    if not IsElvUILoaded() then
        return
    end

    -- Try common ElvUI minimap frame names
    local minimapFrames = {"ElvUI_MinimapHolder", "ElvUI_Minimap", "ElvUF_Minimap"}

    for _, frameName in ipairs(minimapFrames) do
        if SafeHideElvUIFrame(frameName) then
            break
        end
    end
end

-- Show ElvUI Minimap
function ShowElvUIMinimap()
    if not IsElvUILoaded() then
        return
    end

    -- Try common ElvUI minimap frame names
    local minimapFrames = {"ElvUI_MinimapHolder", "ElvUI_Minimap", "ElvUF_Minimap"}

    for _, frameName in ipairs(minimapFrames) do
        if SafeShowElvUIFrame(frameName) then
            break
        end
    end
end

-- Hide ElvUI Action Bars
function HideElvUIActionBars()
    if not IsElvUILoaded() then
        return
    end

    -- Try common ElvUI action bar frame names
    local actionBarFrames = {"ElvUI_Bar1", "ElvUI_Bar2", "ElvUI_Bar3", "ElvUI_Bar4", "ElvUI_Bar5", "ElvUI_Bar6",
                             "ElvUI_BarPet", "ElvUI_BarShapeShift"}

    for _, frameName in ipairs(actionBarFrames) do
        SafeHideElvUIFrame(frameName)
    end

end

-- Show ElvUI Action Bars
function ShowElvUIActionBars()
    if not IsElvUILoaded() then
        return
    end

    -- Try common ElvUI action bar frame names
    local actionBarFrames = {"ElvUI_Bar1", "ElvUI_Bar2", "ElvUI_Bar3", "ElvUI_Bar4", "ElvUI_Bar5", "ElvUI_Bar6",
                             "ElvUI_BarPet", "ElvUI_BarShapeShift"}

    for _, frameName in ipairs(actionBarFrames) do
        SafeShowElvUIFrame(frameName)
    end

end

-- Hide ElvUI Buffs and Debuffs
function HideElvUIBuffs()
    if not IsElvUILoaded() then
        return
    end

    -- Try common ElvUI aura frame names
    local auraFrames = {"ElvUI_PlayerBuffs", "ElvUI_PlayerDebuffs", "ElvUI_Player_Auras", "ElvUI_Auras"}

    for _, frameName in ipairs(auraFrames) do
        SafeHideElvUIFrame(frameName)
    end

    -- Try to hide via ElvUI API if available
    if ElvUI and ElvUI[1] and ElvUI[1].unitFrames then
        local UF = ElvUI[1].unitFrames
        if UF.units and UF.units.player and UF.units.player.Buffs then
            UF.units.player.Buffs:Hide()
        end
        if UF.units and UF.units.player and UF.units.player.Debuffs then
            UF.units.player.Debuffs:Hide()
        end
    end

end

-- Show ElvUI Buffs and Debuffs
function ShowElvUIBuffs()
    if not IsElvUILoaded() then
        return
    end

    -- Try common ElvUI aura frame names
    local auraFrames = {"ElvUI_PlayerBuffs", "ElvUI_PlayerDebuffs", "ElvUI_Player_Auras", "ElvUI_Auras"}

    for _, frameName in ipairs(auraFrames) do
        SafeShowElvUIFrame(frameName)
    end

    -- Try to show via ElvUI API if available
    if ElvUI and ElvUI[1] and ElvUI[1].unitFrames then
        local UF = ElvUI[1].unitFrames
        if UF.units and UF.units.player and UF.units.player.Buffs then
            UF.units.player.Buffs:Show()
        end
        if UF.units and UF.units.player and UF.units.player.Debuffs then
            UF.units.player.Debuffs:Show()
        end
    end

end

-- Hide ElvUI Microbar specifically
function HideElvUIMicrobar()
    if not IsElvUILoaded() then
        return
    end

    local microBar = _G.ElvUI_MicroBar
    if microBar then
        if not microBar.originalShow then
            microBar.originalShow = microBar.Show
            microBar.Show = function()
            end
        end
        microBar:Hide()
        return true
    end
    return false
end

-- Show ElvUI Microbar specifically  
function ShowElvUIMicrobar()
    if not IsElvUILoaded() then
        return
    end

    local microBar = _G.ElvUI_MicroBar
    if microBar and microBar.originalShow then
        microBar.Show = microBar.originalShow
        microBar.originalShow = nil
        microBar:Show()
        return true
    end
    return false
end

-- Hide ElvUI Datapanels and Datatexts
function HideElvUIDatapanels()
    if not IsElvUILoaded() then
        return
    end
    if elvUIFramesHidden.datapanels then
        -- Reset to force a fresh hiding attempt
        elvUIFramesHidden.datapanels = nil
        elvUIFramesHidden.originalDataTextConfig = nil
    end

    local hiddenFrames = {}
    local E = ElvUI[1] -- Get ElvUI instance

    -- Always hide the microbar when hiding player frame
    if HideElvUIMicrobar() then
        table.insert(hiddenFrames, "ElvUI_MicroBar")
    end

    -- The correct ElvUI datapanel frame names from Layout.lua analysis
    local datapanelFrames = { -- Core ElvUI DataText panels
    "LeftChatDataPanel", -- Created in Layout.lua line 324
    "RightChatDataPanel", -- Created in Layout.lua line 373
    "ElvUI_MicroBar", -- ElvUI Microbar (Menu Bar) that should be hidden with player frame
    -- Common ElvUI DataText panel variations
    "ElvUI_DataTextPanel", "ElvUI_DataTextBar", "ElvUI_DataTextContainer", "LeftDataPanel", "RightDataPanel",
    "TopDataPanel", "BottomDataPanel", "ElvUI_LeftDataPanel", "ElvUI_RightDataPanel", "ElvUI_TopDataPanel",
    "ElvUI_BottomDataPanel", -- Bottom panel specific variations (commonly problematic)
    "ElvUI_BottomPanel", "Bottom_Panel", "BottomChatDataPanel", "ElvUI_Chat_BottomPanel", "ChatBottomDataPanel",
    "ElvUI_DataText_Bottom", "DataText_Bottom_Panel", -- MaUI addon frames (commonly visible)
    "MaUI_BottomPanel", "MaUI_TopPanel", "MaUI_LeftPanel", "MaUI_RightPanel", "MaUI_DataTextPanel", "MaUI_DataText1",
    "MaUI_DataText2", "MaUI_DataText3", "MaUI_DataText4", "MaUI_Panel1", "MaUI_Panel2",
    -- ElvUI addon-specific panels that might be missed
    "ElvUI_Panel1", "ElvUI_Panel2", "ElvUI_Panel3", "ElvUI_Panel4", "DataTextPanel1", "DataTextPanel2",
    "DataTextPanel3", "DataTextPanel4"}

    -- Add ElvUI addon DataText panels if loaded
    if IsmMediaTagLoaded() then
        local mMediaTagFrames = {"mMT_DataText1", "mMT_DataText2", "mMT_DataText3", "mMT_DataText4", "mMT_DataText5",
                                 "mMT_DataText6", "ElvUI_mMediaTag_DataText_Panel1", "ElvUI_mMediaTag_DataText_Panel2",
                                 "ElvUI_mMediaTag_DataText_Panel3", "mMediaTag_TopDataPanel",
                                 "mMediaTag_BottomDataPanel", "mMediaTag_LeftDataPanel", "mMediaTag_RightDataPanel"}
        for _, frameName in ipairs(mMediaTagFrames) do
            table.insert(datapanelFrames, frameName)
        end
    end

    if IsHoffUILoaded() then
        -- Enhanced HoffUI frame detection - covers more possible naming patterns
        local hoffUIFrames = { -- Direct HoffUI DataText frames
        "HoffUI_DataText1", "HoffUI_DataText2", "HoffUI_DataText3", "HoffUI_DataText4", "HoffUI_DataText5",
        "HoffUI_DataText6", "HoffUI_DataText7", "HoffUI_DataText8", -- HoffUI Panel frames
        "ElvUI_HoffUI_DataText_Panel1", "ElvUI_HoffUI_DataText_Panel2", "ElvUI_HoffUI_DataText_Panel3",
        "HoffUI_TopDataPanel", "HoffUI_BottomDataPanel", "HoffUI_LeftDataPanel", "HoffUI_RightDataPanel",
        -- Additional possible HoffUI frames
        "HoffUI_MainPanel", "HoffUI_DataTextPanel", "ElvUI_HoffUI_MainPanel",
        -- ElvUI DataText frames that might be created by HoffUI
        "ElvUI_HoffUIPanel1", "ElvUI_HoffUIPanel2", "ElvUI_HoffUIPanel3"}
        for _, frameName in ipairs(hoffUIFrames) do
            table.insert(datapanelFrames, frameName)
        end

        -- Also try to dynamically find HoffUI panels through ElvUI's registered panels
        if E and E.DataTexts and E.DataTexts.RegisteredPanels then
            for panelName, panel in pairs(E.DataTexts.RegisteredPanels) do
                local lowerName = string.lower(panelName)
                if string.find(lowerName, "hoff") then
                    table.insert(datapanelFrames, panelName)
                end
            end
        end
    end

    if IsEltreumUILoaded() then
        local eltreumUIFrames = { -- Direct EltreumUI DataText frames
        "EltreumUI_DataText1", "EltreumUI_DataText2", "EltreumUI_DataText3", "EltreumUI_DataText4",
        "EltreumUI_DataText5", "EltreumUI_DataText6", "EltreumUI_DataText7", "EltreumUI_DataText8",
        -- EltreumUI Panel frames
        "ElvUI_EltreumUI_DataText_Panel1", "ElvUI_EltreumUI_DataText_Panel2", "ElvUI_EltreumUI_DataText_Panel3",
        "EltreumUI_TopDataPanel", "EltreumUI_BottomDataPanel", "EltreumUI_LeftDataPanel", "EltreumUI_RightDataPanel",
        -- Additional possible EltreumUI frames
        "EltreumUI_MainPanel", "EltreumUI_DataTextPanel", "ElvUI_EltreumUI_MainPanel", "ElvUI_EltreumUIPanel1",
        "ElvUI_EltreumUIPanel2", "ElvUI_EltreumUIPanel3"}
        for _, frameName in ipairs(eltreumUIFrames) do
            table.insert(datapanelFrames, frameName)
        end

        -- Also try to dynamically find EltreumUI panels through ElvUI's registered panels
        if E and E.DataTexts and E.DataTexts.RegisteredPanels then
            for panelName, panel in pairs(E.DataTexts.RegisteredPanels) do
                local lowerName = string.lower(panelName)
                if string.find(lowerName, "eltreum") or string.find(lowerName, "eltrum") then
                    table.insert(datapanelFrames, panelName)
                end
            end
        end
    end

    -- Scan for any additional HoffUI or addon-created DataText panels
    if IsHoffUILoaded() then
        -- Scan global namespace for potential HoffUI frames
        for frameName, frame in pairs(_G) do
            if type(frame) == "table" and frame.GetObjectType then
                -- Safely call GetObjectType to avoid errors
                local success, objectType = pcall(frame.GetObjectType, frame)
                if success and objectType == "Frame" then
                    local lowerName = string.lower(frameName)
                    if (string.find(lowerName, "hoffui") or string.find(lowerName, "hoff")) and
                        (string.find(lowerName, "datatext") or string.find(lowerName, "panel")) then
                        table.insert(datapanelFrames, frameName)
                    end
                end
            end
        end
    end

    -- Scan global namespace for MaUI frames (based on ElvUI Movers analysis)
    for frameName, frame in pairs(_G) do
        if type(frame) == "table" and frame.GetObjectType then
            -- Safely call GetObjectType to avoid errors
            local success, objectType = pcall(frame.GetObjectType, frame)
            if success and objectType == "Frame" then
                local lowerName = string.lower(frameName)
                if string.find(lowerName, "maui") and
                    (string.find(lowerName, "datatext") or string.find(lowerName, "panel") or
                        string.find(lowerName, "dock")) then
                    table.insert(datapanelFrames, frameName)
                end
            end
        end
    end

    -- Comprehensive scan for any DataText-related frames (aggressive detection)
    for frameName, frame in pairs(_G) do
        if type(frame) == "table" and frame.Hide and frame.Show then
            local lowerName = string.lower(frameName)
            -- Look for any frame that might be a DataText panel
            if (string.find(lowerName, "datatext") or string.find(lowerName, "datapanel") or
                (string.find(lowerName, "elvui") and string.find(lowerName, "panel")) or string.find(lowerName, "maui") or -- Add MaUI detection
                (string.find(lowerName, "mmt") and string.find(lowerName, "panel"))) and
                not string.find(lowerName, "tooltip") and not string.find(lowerName, "button") then

                -- Avoid duplicates
                local isDuplicate = false
                for _, existingFrame in ipairs(datapanelFrames) do
                    if existingFrame == frameName then
                        isDuplicate = true
                        break
                    end
                end

                if not isDuplicate then
                    table.insert(datapanelFrames, frameName)
                end
            end
        end
    end

    -- Hide the actual datapanel frames
    for _, frameName in ipairs(datapanelFrames) do
        local frame = _G[frameName]
        if frame then
            -- Override the Show function to prevent it from ever showing
            if not frame.originalShow then
                frame.originalShow = frame.Show
                frame.Show = function()
                end -- Block showing
            end
            frame:Hide()
            table.insert(hiddenFrames, frameName)
        end
    end

    -- Hide DataText panels through ElvUI's proper API
    if E and E.DataTexts then
        local DT = E:GetModule('DataTexts')
        if DT and DT.RegisteredPanels then
            -- Hide all registered DataText panels
            for panelName, panel in pairs(DT.RegisteredPanels) do
                if panel and panel.Hide then
                    if not panel.originalShow then
                        panel.originalShow = panel.Show
                        panel.Show = function()
                        end -- Block showing
                    end
                    panel:Hide()
                    table.insert(hiddenFrames, "DTPANEL:" .. panelName)
                end
            end
        end
    end

    -- Also disable via ElvUI config to prevent them from re-enabling
    if E and E.db and E.db.datatexts and E.db.datatexts.panels then
        local panelsToDisable = {"LeftChatDataPanel", "RightChatDataPanel"}

        -- Add addon-specific panels if available
        local addonPanels = {}
        for panelName, _ in pairs(E.db.datatexts.panels) do
            local lowerName = string.lower(panelName)
            if (IsmMediaTagLoaded() and (string.find(lowerName, "mmediatag") or string.find(lowerName, "mmt"))) or
                (IsHoffUILoaded() and string.find(lowerName, "hoffui")) or
                (IsEltreumUILoaded() and string.find(lowerName, "eltreum")) or string.find(lowerName, "dock") or
                string.find(lowerName, "maui") then -- Add MaUI detection
                table.insert(addonPanels, panelName)
            end
        end

        for _, panelName in ipairs(addonPanels) do
            table.insert(panelsToDisable, panelName)
        end

        for _, panelName in ipairs(panelsToDisable) do
            local panelConfig = E.db.datatexts.panels[panelName]
            if panelConfig and panelConfig.enable ~= nil then
                if not elvUIFramesHidden.originalDataTextConfig then
                    elvUIFramesHidden.originalDataTextConfig = {}
                end
                elvUIFramesHidden.originalDataTextConfig[panelName] = panelConfig.enable
                panelConfig.enable = false
                table.insert(hiddenFrames, "CONFIG:" .. panelName)
            end
        end

        -- Force ElvUI to update the panel visibility (only if layout is fully initialized)
        local LO = E:GetModule('Layout')
        if LO and LO.RepositionChatDataPanels and _G.LeftChatDataPanel and _G.RightChatDataPanel then
            -- Use pcall to safely call the function
            local success, err = pcall(function()
                LO:RepositionChatDataPanels()
            end)
            -- Silently handle success/failure
        end
    end

    -- Handle addon-specific API hiding
    if IsmMediaTagLoaded() then
        if _G.mMT and _G.mMT.Dock then
            local dock = _G.mMT.Dock
            if dock.TopPanel then
                if not dock.TopPanel.originalShow then
                    dock.TopPanel.originalShow = dock.TopPanel.Show
                    dock.TopPanel.Show = function()
                    end
                end
                dock.TopPanel:Hide()
                table.insert(hiddenFrames, "mMT_TopPanel")
            end
            if dock.BottomPanel then
                if not dock.BottomPanel.originalShow then
                    dock.BottomPanel.originalShow = dock.BottomPanel.Show
                    dock.BottomPanel.Show = function()
                    end
                end
                dock.BottomPanel:Hide()
                table.insert(hiddenFrames, "mMT_BottomPanel")
            end
        end
        if _G.mMediaTag and _G.mMediaTag.datatexts and _G.mMediaTag.datatexts.panels then
            for panelName, panel in pairs(_G.mMediaTag.datatexts.panels) do
                if panel and panel.Hide then
                    if not panel.originalShow then
                        panel.originalShow = panel.Show
                        panel.Show = function()
                        end
                    end
                    panel:Hide()
                    table.insert(hiddenFrames, "mMediaTag_" .. panelName)
                end
            end
        end
    end

    if IsHoffUILoaded() then
        if _G.HoffUI and _G.HoffUI.datatexts and _G.HoffUI.datatexts.panels then
            for panelName, panel in pairs(_G.HoffUI.datatexts.panels) do
                if panel and panel.Hide then
                    if not panel.originalShow then
                        panel.originalShow = panel.Show
                        panel.Show = function()
                        end
                    end
                    panel:Hide()
                    table.insert(hiddenFrames, "HoffUI_" .. panelName)
                end
            end
        end
    end

    if IsEltreumUILoaded() then
        if _G.EltreumUI and _G.EltreumUI.datatexts and _G.EltreumUI.datatexts.panels then
            for panelName, panel in pairs(_G.EltreumUI.datatexts.panels) do
                if panel and panel.Hide then
                    if not panel.originalShow then
                        panel.originalShow = panel.Show
                        panel.Show = function()
                        end
                    end
                    panel:Hide()
                    table.insert(hiddenFrames, "EltreumUI_" .. panelName)
                end
            end
        end
    end

    if #hiddenFrames > 0 then
        elvUIFramesHidden.datapanels = hiddenFrames
    end
end

-- Show ElvUI Datapanels and Datatexts
function ShowElvUIDatapanels()
    if not IsElvUILoaded() then
        return
    end
    if not elvUIFramesHidden.datapanels then
        return
    end -- Not hidden by us

    local E = ElvUI[1] -- Get ElvUI instance

    -- Always show the microbar when showing player frame
    ShowElvUIMicrobar()

    -- Restore frames that were hidden
    if type(elvUIFramesHidden.datapanels) == "table" then
        for _, frameName in ipairs(elvUIFramesHidden.datapanels) do
            if string.sub(frameName, 1, 9) == "DTPANEL:" then
                -- Restore DataText panel
                local panelName = string.sub(frameName, 10)
                if E and E.DataTexts then
                    local DT = E:GetModule('DataTexts')
                    if DT and DT.RegisteredPanels and DT.RegisteredPanels[panelName] then
                        local panel = DT.RegisteredPanels[panelName]
                        if panel.originalShow then
                            panel.Show = panel.originalShow
                            panel.originalShow = nil
                            panel:Show()
                        end
                    end
                end
            elseif string.sub(frameName, 1, 7) == "CONFIG:" then
                -- Handle config-based datapanel restoration
                local panelName = string.sub(frameName, 8)
                if ElvUI and ElvUI[1] and ElvUI[1].db and ElvUI[1].db.datatexts and ElvUI[1].db.datatexts.panels then
                    local E = ElvUI[1]
                    local panelConfig = E.db.datatexts.panels[panelName]
                    if panelConfig and elvUIFramesHidden.originalDataTextConfig and
                        elvUIFramesHidden.originalDataTextConfig[panelName] ~= nil then
                        panelConfig.enable = elvUIFramesHidden.originalDataTextConfig[panelName]
                    end
                end
            elseif string.sub(frameName, 1, 4) == "mMT_" then
                local panelType = string.sub(frameName, 5)
                if _G.mMT and _G.mMT.Dock then
                    local panel = _G.mMT.Dock[panelType]
                    if panel and panel.originalShow then
                        panel.Show = panel.originalShow
                        panel.originalShow = nil
                        panel:Show()
                    end
                end
            elseif string.sub(frameName, 1, 11) == "mMediaTag_" then
                local panelName = string.sub(frameName, 12)
                if _G.mMediaTag and _G.mMediaTag.datatexts and _G.mMediaTag.datatexts.panels then
                    local panel = _G.mMediaTag.datatexts.panels[panelName]
                    if panel and panel.originalShow then
                        panel.Show = panel.originalShow
                        panel.originalShow = nil
                        panel:Show()
                    end
                end
            elseif string.sub(frameName, 1, 8) == "HoffUI_" then
                local panelName = string.sub(frameName, 9)
                if _G.HoffUI and _G.HoffUI.datatexts and _G.HoffUI.datatexts.panels then
                    local panel = _G.HoffUI.datatexts.panels[panelName]
                    if panel and panel.originalShow then
                        panel.Show = panel.originalShow
                        panel.originalShow = nil
                        panel:Show()
                    end
                end
            elseif string.sub(frameName, 1, 10) == "EltreumUI_" then
                local panelName = string.sub(frameName, 11)
                if _G.EltreumUI and _G.EltreumUI.datatexts and _G.EltreumUI.datatexts.panels then
                    local panel = _G.EltreumUI.datatexts.panels[panelName]
                    if panel and panel.originalShow then
                        panel.Show = panel.originalShow
                        panel.originalShow = nil
                        panel:Show()
                    end
                end
            elseif string.sub(frameName, 1, 5) == "MaUI_" then
                -- Handle MaUI frames restoration
                local frame = _G[frameName]
                if frame and frame.originalShow then
                    frame.Show = frame.originalShow
                    frame.originalShow = nil
                    frame:Show()
                end
            else
                local frame = _G[frameName]
                if frame and frame.originalShow then
                    frame.Show = frame.originalShow
                    frame.originalShow = nil
                    frame:Show()
                end
            end
        end

        -- Force ElvUI to update the panel visibility after restoration (only if layout is fully initialized)
        if ElvUI and ElvUI[1] then
            local E = ElvUI[1]
            local LO = E:GetModule('Layout')
            if LO and LO.RepositionChatDataPanels and _G.LeftChatDataPanel and _G.RightChatDataPanel then
                -- Use pcall to safely call the function
                pcall(function()
                    LO:RepositionChatDataPanels()
                end)
            end
        end
    end

    -- Clear the stored original config
    elvUIFramesHidden.originalDataTextConfig = nil
    elvUIFramesHidden.datapanels = nil
end

-- Hide ElvUI Nameplates
function HideElvUINameplates()
    if not IsElvUILoaded() then
        return
    end
    if elvUIFramesHidden.nameplates then
        return
    end -- Already hidden

    -- Try common ElvUI nameplate frame names
    local nameplateFrames = {"ElvUI_NamePlates", "ElvUI_NamePlateContainer", "ElvUF_NamePlates"}

    local hiddenFrames = {}
    for _, frameName in ipairs(nameplateFrames) do
        local frame = _G[frameName]
        if frame then
            -- Override the Show function to prevent it from ever showing
            if not frame.originalShow then
                frame.originalShow = frame.Show
                frame.Show = function()
                end -- Block showing
            end
            frame:Hide()
            table.insert(hiddenFrames, frameName)
        end
    end

    -- Store original ElvUI nameplate settings
    if not elvUIFramesHidden.originalNameplateConfig then
        elvUIFramesHidden.originalNameplateConfig = {}
    end

    -- Comprehensive ElvUI nameplate hiding via API
    if ElvUI and ElvUI[1] then
        local E = ElvUI[1]

        -- Hide nameplates module if available
        if E.NamePlates then
            -- Store and disable ElvUI nameplates completely
            if E.private and E.private.nameplates then
                elvUIFramesHidden.originalNameplateConfig.enable = E.private.nameplates.enable
                E.private.nameplates.enable = false
                table.insert(hiddenFrames, "API:nameplates.enable")
            end

            -- Disable ElvUI nameplate database settings
            if E.db and E.db.nameplates then
                elvUIFramesHidden.originalNameplateConfig.dbEnable = E.db.nameplates.enable
                E.db.nameplates.enable = false
                table.insert(hiddenFrames, "API:db.nameplates.enable")
            end

            -- Force hide the nameplate module
            if E.NamePlates.DisableBlizzard then
                pcall(E.NamePlates.DisableBlizzard, E.NamePlates)
            end

            -- Hide nameplate frames if available
            if E.NamePlates.frame then
                if not E.NamePlates.frame.originalShow then
                    E.NamePlates.frame.originalShow = E.NamePlates.frame.Show
                    E.NamePlates.frame.Show = function()
                    end
                end
                E.NamePlates.frame:Hide()
                table.insert(hiddenFrames, "API:NamePlates.frame")
            end

            -- Hide any active nameplate units
            if E.NamePlates.CreatedPlates then
                for plate, _ in pairs(E.NamePlates.CreatedPlates) do
                    if plate and plate.Hide then
                        if not plate.originalShow then
                            plate.originalShow = plate.Show
                            plate.Show = function()
                            end
                        end
                        plate:Hide()
                    end
                end
                table.insert(hiddenFrames, "API:CreatedPlates")
            end
        end

        -- Also hide via Layout module if available
        if E.Layout and E.Layout.ToggleNameplates then
            pcall(E.Layout.ToggleNameplates, E.Layout, false)
            table.insert(hiddenFrames, "API:Layout.ToggleNameplates")
        end
    end

    -- Scan for any remaining nameplate frames globally
    for frameName, frame in pairs(_G) do
        if type(frame) == "table" and frame.Hide then
            local lowerName = string.lower(frameName)
            if (string.find(lowerName, "nameplate") or
                (string.find(lowerName, "elvui") and string.find(lowerName, "plate"))) and
                not string.find(lowerName, "tooltip") and not string.find(lowerName, "button") then

                -- Check if we haven't already processed this frame
                local alreadyHidden = false
                for _, existingFrame in ipairs(hiddenFrames) do
                    if existingFrame == frameName then
                        alreadyHidden = true
                        break
                    end
                end

                if not alreadyHidden then
                    if not frame.originalShow and frame.Show then
                        frame.originalShow = frame.Show
                        frame.Show = function()
                        end
                    end
                    if frame.Hide then
                        frame:Hide()
                        table.insert(hiddenFrames, frameName)
                    end
                end
            end
        end
    end

    if #hiddenFrames > 0 then
        elvUIFramesHidden.nameplates = hiddenFrames
    end
end

-- Show ElvUI Nameplates
function ShowElvUINameplates()
    if not IsElvUILoaded() then
        return
    end
    if not elvUIFramesHidden.nameplates then
        return
    end -- Not hidden by us

    -- Restore original ElvUI nameplate configurations
    if elvUIFramesHidden.originalNameplateConfig then
        local E = ElvUI[1]
        if E then
            -- Restore private settings
            if elvUIFramesHidden.originalNameplateConfig.enable ~= nil and E.private and E.private.nameplates then
                E.private.nameplates.enable = elvUIFramesHidden.originalNameplateConfig.enable
            end

            -- Restore database settings
            if elvUIFramesHidden.originalNameplateConfig.dbEnable ~= nil and E.db and E.db.nameplates then
                E.db.nameplates.enable = elvUIFramesHidden.originalNameplateConfig.dbEnable
            end
        end
    end

    -- Restore frames that were hidden
    if type(elvUIFramesHidden.nameplates) == "table" then
        for _, frameName in ipairs(elvUIFramesHidden.nameplates) do
            if frameName == "API:nameplates.enable" then
                -- Already handled above in originalNameplateConfig restoration
            elseif frameName == "API:db.nameplates.enable" then
                -- Already handled above in originalNameplateConfig restoration
            elseif frameName == "API:NamePlates.frame" then
                -- Restore nameplate frame
                if ElvUI and ElvUI[1] and ElvUI[1].NamePlates and ElvUI[1].NamePlates.frame then
                    local frame = ElvUI[1].NamePlates.frame
                    if frame.originalShow then
                        frame.Show = frame.originalShow
                        frame.originalShow = nil
                        frame:Show()
                    end
                end
            elseif frameName == "API:CreatedPlates" then
                -- Restore created nameplate units
                if ElvUI and ElvUI[1] and ElvUI[1].NamePlates and ElvUI[1].NamePlates.CreatedPlates then
                    for plate, _ in pairs(ElvUI[1].NamePlates.CreatedPlates) do
                        if plate and plate.originalShow then
                            plate.Show = plate.originalShow
                            plate.originalShow = nil
                            plate:Show()
                        end
                    end
                end
            elseif frameName == "API:Layout.ToggleNameplates" then
                -- Re-enable nameplates via Layout module
                if ElvUI and ElvUI[1] and ElvUI[1].Layout and ElvUI[1].Layout.ToggleNameplates then
                    pcall(ElvUI[1].Layout.ToggleNameplates, ElvUI[1].Layout, true)
                end
            else
                -- Handle direct frame references
                local frame = _G[frameName]
                if frame and frame.originalShow then
                    frame.Show = frame.originalShow
                    frame.originalShow = nil
                    frame:Show()
                end
            end
        end
    end

    -- Force a nameplate refresh to ensure changes take effect
    if ElvUI and ElvUI[1] and ElvUI[1].NamePlates then
        local NP = ElvUI[1].NamePlates
        if NP.UpdateAllPlates then
            pcall(NP.UpdateAllPlates, NP)
        elseif NP.ConfigureAll then
            pcall(NP.ConfigureAll, NP)
        end
    end

    -- Clear the stored original config
    elvUIFramesHidden.originalNameplateConfig = nil
    elvUIFramesHidden.nameplates = nil -- Mark as not hidden
end

-- Hide ElvUI Tooltips
function HideElvUITooltips()
    if not IsElvUILoaded() then
        return
    end
    if elvUIFramesHidden.tooltips then
        return
    end -- Already hidden

    local hiddenFrames = {}

    -- Try to hide via ElvUI API if available
    if ElvUI and ElvUI[1] then
        local E = ElvUI[1]

        -- Disable ElvUI tooltip modifications
        if E.Tooltip then
            -- Store original state and disable
            if E.db and E.db.tooltip and E.db.tooltip.enable then
                elvUIFramesHidden.originalTooltipState = E.db.tooltip.enable
                E.db.tooltip.enable = false
                table.insert(hiddenFrames, "API:tooltip.enable")
            end
        end

        -- Hide specific tooltip frames
        local tooltipFrames = {"ElvUI_Tooltip", "ElvUI_TooltipContainer"}

        for _, frameName in ipairs(tooltipFrames) do
            local frame = _G[frameName]
            if frame then
                if not frame.originalShow then
                    frame.originalShow = frame.Show
                    frame.Show = function()
                    end
                end
                frame:Hide()
                table.insert(hiddenFrames, frameName)
            end
        end
    end

    if #hiddenFrames > 0 then
        elvUIFramesHidden.tooltips = hiddenFrames
    end
end

-- Show ElvUI Tooltips
function ShowElvUITooltips()
    if not IsElvUILoaded() then
        return
    end
    if not elvUIFramesHidden.tooltips then
        return
    end -- Not hidden by us

    -- Restore frames that were hidden
    if type(elvUIFramesHidden.tooltips) == "table" then
        for _, frameName in ipairs(elvUIFramesHidden.tooltips) do
            if frameName == "API:tooltip.enable" then
                -- Re-enable ElvUI tooltips
                if ElvUI and ElvUI[1] and ElvUI[1].db and ElvUI[1].db.tooltip then
                    ElvUI[1].db.tooltip.enable = elvUIFramesHidden.originalTooltipState or true
                    elvUIFramesHidden.originalTooltipState = nil
                end
            else
                -- Handle direct frame references
                local frame = _G[frameName]
                if frame and frame.originalShow then
                    frame.Show = frame.originalShow
                    frame.originalShow = nil
                    frame:Show()
                end
            end
        end
    end

    elvUIFramesHidden.tooltips = nil -- Mark as not hidden
end

-- Export functions
_G.UltraHardcore_ElvUI = {
    IsElvUILoaded = IsElvUILoaded,
    IsmMediaTagLoaded = IsmMediaTagLoaded,
    IsHoffUILoaded = IsHoffUILoaded,
    IsEltreumUILoaded = IsEltreumUILoaded,
    HideElvUIPlayerFrame = HideElvUIPlayerFrame,
    ShowElvUIPlayerFrame = ShowElvUIPlayerFrame,
    HideElvUITargetFrame = HideElvUITargetFrame,
    ShowElvUITargetFrame = ShowElvUITargetFrame,
    HideElvUIMinimap = HideElvUIMinimap,
    ShowElvUIMinimap = ShowElvUIMinimap,
    HideElvUIActionBars = HideElvUIActionBars,
    ShowElvUIActionBars = ShowElvUIActionBars,
    HideElvUIBuffs = HideElvUIBuffs,
    ShowElvUIBuffs = ShowElvUIBuffs,
    HideElvUIDatapanels = HideElvUIDatapanels,
    ShowElvUIDatapanels = ShowElvUIDatapanels,
    HideElvUIMicrobar = HideElvUIMicrobar,
    ShowElvUIMicrobar = ShowElvUIMicrobar,
    HideElvUINameplates = HideElvUINameplates,
    ShowElvUINameplates = ShowElvUINameplates,
    HideElvUITooltips = HideElvUITooltips,
    ShowElvUITooltips = ShowElvUITooltips
}
