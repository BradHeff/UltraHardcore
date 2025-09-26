-- UltraHardcore Game Menu Button
-- Positions the UltraHardcore menu button in the game menu similar to ElvUI_EltreumUI
local UltraHardcore_GameMenu = CreateFrame("Frame")
local UltraHardcoreMenuButton = nil
local isMenuExpanded = false

-- Check if ElvUI is loaded
local function IsElvUILoaded()
    return ElvUI ~= nil
end

-- Function to create and position the UltraHardcore menu button
local function CreateUltraHardcoreMenuButton()
    if not UltraHardcoreMenuButton and not isMenuExpanded then
        -- Create the menu button using GameMenuButtonTemplate
        UltraHardcoreMenuButton = CreateFrame('Button', 'UltraHardcoreMenuButton', GameMenuFrame,
            'GameMenuButtonTemplate')
        UltraHardcoreMenuButton:SetText(
            "|TInterface\\AddOns\\UltraHardcore\\Textures\\skull1.png:16:16:0:0:64:64|t UltraHardcore")

        -- Size it to match other game menu buttons
        local x, y = _G["GameMenuButtonLogout"]:GetSize()
        UltraHardcoreMenuButton:SetSize(x, y)

        -- Set up the click handler
        UltraHardcoreMenuButton:SetScript("OnClick", function()
            if not InCombatLockdown() then
                -- Open UltraHardcore settings using the existing function
                if ToggleSettings then
                    ToggleSettings()
                else
                    print("|cff1784d1UltraHardcore|r: Use /uhc to open settings")
                end
                HideUIPanel(_G["GameMenuFrame"])
            end
        end)

        -- Style the button if ElvUI is loaded
        if IsElvUILoaded() and ElvUI[1] then
            local S = ElvUI[1]:GetModule('Skins')
            if S and S.HandleButton then
                S:HandleButton(UltraHardcoreMenuButton)
            end
        end

        -- Hook into the game menu update function to position our button
        hooksecurefunc('GameMenuFrame_UpdateVisibleButtons', function()
            -- Position the button intelligently based on what other addon buttons exist
            local anchorButton = nil
            local anchorPoint = "BOTTOM"

            -- Check for ElvUI button first (highest priority)
            if GameMenuFrame.ElvUI then
                anchorButton = GameMenuFrame.ElvUI
                -- Check for other common addon buttons in order of priority
            elseif _G["EltruismMenuButton"] then
                anchorButton = _G["EltruismMenuButton"]
            elseif _G["GameMenu_SLEConfig"] then
                anchorButton = _G["GameMenu_SLEConfig"]
            elseif _G["GameMenuReloadUI"] then
                anchorButton = _G["GameMenuReloadUI"]
            elseif _G.TXUI_GAME_BUTTON then
                anchorButton = _G.TXUI_GAME_BUTTON
            elseif _G["GameMenuFrame"].GameMenu_TXUI then
                anchorButton = _G["GameMenuFrame"].GameMenu_TXUI
            else
                -- Default to positioning below Addons button
                anchorButton = _G.GameMenuButtonAddons
            end

            if anchorButton then
                UltraHardcoreMenuButton:ClearAllPoints()
                UltraHardcoreMenuButton:SetPoint("TOP", anchorButton, anchorPoint, 0, -1)
            end
        end)

        -- Hook the GameMenuFrame OnShow to adjust layout
        _G["GameMenuFrame"]:HookScript("OnShow", function()
            if UltraHardcoreMenuButton and UltraHardcoreMenuButton:IsShown() then
                -- Move the Logout button down to make room
                _G["GameMenuButtonLogout"]:ClearAllPoints()
                _G["GameMenuButtonLogout"]:SetPoint("TOP", UltraHardcoreMenuButton, "BOTTOM", 0, -1)

                -- Expand the GameMenuFrame height to accommodate our button
                local currentHeight = _G["GameMenuFrame"]:GetHeight()
                _G["GameMenuFrame"]:SetHeight(currentHeight + y + 1)
            end
        end)

        isMenuExpanded = true
    end
end

-- Event handler for addon loading
UltraHardcore_GameMenu:RegisterEvent("ADDON_LOADED")
UltraHardcore_GameMenu:RegisterEvent("PLAYER_ENTERING_WORLD")
UltraHardcore_GameMenu:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" and addonName == addonName then
        -- Create the button once the addon is loaded
        CreateUltraHardcoreMenuButton()
    elseif event == "PLAYER_ENTERING_WORLD" then
        -- Ensure button is created when entering world
        CreateUltraHardcoreMenuButton()
    end
end)

-- Expose the button creation function globally
_G.UltraHardcore_CreateMenuButton = CreateUltraHardcoreMenuButton
