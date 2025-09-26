-- UltraHardcore ElvUI Integration Module
-- This module provides better integration with ElvUI components beyond basic compatibility
local UltraHardcore_ElvUIIntegration = CreateFrame("Frame")

-- Check if ElvUI is loaded
local function IsElvUILoaded()
    return ElvUI ~= nil
end

-- Enhanced ElvUI Player Frame Integration
local function IntegrateWithElvUIPlayerFrame()
    if not IsElvUILoaded() then
        return
    end

    local E = ElvUI[1]
    if not E then
        return
    end

    -- Hook into ElvUI's unit frame toggle functions if they exist
    local UF = E:GetModule('UnitFrames', true)
    if UF then
        -- Create a custom function to handle UltraHardcore's player frame hiding
        local function UHCPlayerFrameToggle(show)
            if show then
                -- When showing, respect UltraHardcore's hidePlayerFrame setting
                if GLOBAL_SETTINGS and not GLOBAL_SETTINGS.hidePlayerFrame then
                    -- Only show if UltraHardcore allows it
                    if UF.units and UF.units.player then
                        UF.units.player:Show()
                    end
                    -- Also show DataText panels if they should be visible
                    if UltraHardcore_ElvUI and UltraHardcore_ElvUI.ShowElvUIDatapanels then
                        UltraHardcore_ElvUI.ShowElvUIDatapanels()
                    end
                end
            else
                -- When hiding, hide both player frame and related components
                if UF.units and UF.units.player then
                    UF.units.player:Hide()
                end
                -- Hide DataText panels as well
                if UltraHardcore_ElvUI and UltraHardcore_ElvUI.HideElvUIDatapanels then
                    UltraHardcore_ElvUI.HideElvUIDatapanels()
                end
            end
        end

        -- Store the function globally so it can be called from other modules
        _G.UltraHardcore_ElvUIPlayerFrameToggle = UHCPlayerFrameToggle
    end
end

-- Enhanced DataText Panel Integration
local function IntegrateWithElvUIDataTexts()
    if not IsElvUILoaded() then
        return
    end

    local E = ElvUI[1]
    if not E then
        return
    end

    local DT = E:GetModule('DataTexts', true)
    if DT then
        -- Hook into DataText panel creation to track them
        if DT.RegisterPanel then
            local originalRegisterPanel = DT.RegisterPanel
            DT.RegisterPanel = function(self, panel, numPoints, anchor, xOff, yOff, vertical)
                -- Call original function
                local result = originalRegisterPanel(self, panel, numPoints, anchor, xOff, yOff, vertical)

                -- If UltraHardcore has hidden player frame, hide this panel too
                if GLOBAL_SETTINGS and GLOBAL_SETTINGS.hidePlayerFrame then
                    if panel and panel.Hide then
                        panel:Hide()
                    end
                end

                return result
            end
        end

        -- Create a function to sync DataText visibility with player frame setting
        local function SyncDataTextVisibility()
            if not DT.RegisteredPanels then
                return
            end

            for panelName, panel in pairs(DT.RegisteredPanels) do
                if panel then
                    if GLOBAL_SETTINGS and GLOBAL_SETTINGS.hidePlayerFrame then
                        if panel.Hide then
                            panel:Hide()
                        end
                    else
                        if panel.Show then
                            panel:Show()
                        end
                    end
                end
            end
        end

        -- Store the sync function globally
        _G.UltraHardcore_SyncElvUIDataTexts = SyncDataTextVisibility
    end
end

-- Initialize integration when ElvUI is ready
local function InitializeElvUIIntegration()
    if not IsElvUILoaded() then
        return
    end

    -- Wait for ElvUI to be fully loaded
    local E = ElvUI[1]
    if not E or not E.initialized then
        -- If ElvUI isn't ready yet, wait a bit and try again
        local timer = CreateFrame("Frame")
        timer:SetScript("OnUpdate", function(self, elapsed)
            self.elapsed = (self.elapsed or 0) + elapsed
            if self.elapsed >= 0.5 then
                self:SetScript("OnUpdate", nil)
                InitializeElvUIIntegration()
            end
        end)
        return
    end

    -- Initialize all integration components
    IntegrateWithElvUIPlayerFrame()
    IntegrateWithElvUIDataTexts()

    -- Hook into UltraHardcore's settings changes
    if GLOBAL_SETTINGS then
        -- Create a monitoring frame for settings changes
        local settingsMonitor = CreateFrame("Frame")
        settingsMonitor:SetScript("OnUpdate", function(self)
            -- This will run periodically to check for settings changes
            -- In a real implementation, you'd want event-driven updates
            if _G.UltraHardcore_LastPlayerFrameSetting ~= GLOBAL_SETTINGS.hidePlayerFrame then
                _G.UltraHardcore_LastPlayerFrameSetting = GLOBAL_SETTINGS.hidePlayerFrame

                -- Sync DataText visibility when player frame setting changes
                if _G.UltraHardcore_SyncElvUIDataTexts then
                    _G.UltraHardcore_SyncElvUIDataTexts()
                end
            end
        end)

        -- Set initial state
        _G.UltraHardcore_LastPlayerFrameSetting = GLOBAL_SETTINGS.hidePlayerFrame
    end
end

-- Event handling
UltraHardcore_ElvUIIntegration:RegisterEvent("ADDON_LOADED")
UltraHardcore_ElvUIIntegration:RegisterEvent("PLAYER_ENTERING_WORLD")
UltraHardcore_ElvUIIntegration:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" then
        if addonName == "ElvUI" or addonName == "UltraHardcore" then
            -- Initialize when either ElvUI or UltraHardcore loads
            InitializeElvUIIntegration()
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
        -- Ensure integration is set up when entering world
        InitializeElvUIIntegration()
    end
end)

-- Expose initialization function globally
_G.UltraHardcore_InitializeElvUIIntegration = InitializeElvUIIntegration
