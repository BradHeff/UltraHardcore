-- Create the button
local button = CreateFrame("Button", "GameMenuButtonUltraHardcore", GameMenuFrame, "GameMenuButtonTemplate")
button:SetText("Ultra Hardcore")

-- Set initial position
button:SetPoint("TOP", GameMenuFrame, "TOP", 0, 0)

-- Set the click handler
button:SetScript("OnClick", function()
    -- Hide the game menu
    HideUIPanel(GameMenuFrame)
    -- Toggle settings using the existing function
    ToggleSettings()
end)

-- Function to find the best position for our button
local function PositionUltraHardcoreButton()
    -- Clear any existing positioning
    button:ClearAllPoints()

    -- Debug: List all GameMenu buttons (uncomment for debugging)
    --[[
    print("UltraHardcore: Searching for menu buttons...")
    for name, frame in pairs(_G) do
        if type(frame) == "table" and frame.GetObjectType then
            -- Safely call GetObjectType with pcall to prevent errors
            local success, objectType = pcall(frame.GetObjectType, frame)
            if success and objectType == "Button" and
               string.find(name, "GameMenu") and frame.GetParent and
               pcall(frame.GetParent, frame) and frame:GetParent() == GameMenuFrame then
                local visible = frame:IsVisible() and "visible" or "hidden"
                print("  Found: " .. name .. " (" .. visible .. ")")
            end
        end
    end
    --]]

    -- Try to find ElvUI button first (try multiple possible names)
    local elvUIButtonNames = {
        "GameMenuButtonElvUI",
        "ElvUIGameMenuButton",
        "GameMenuElvUI",
        "GameMenuButtonConfig"
    }

    for _, buttonName in ipairs(elvUIButtonNames) do
        local elvUIButton = _G[buttonName]
        if elvUIButton and elvUIButton:IsVisible() then
            -- Position below ElvUI button with proper spacing
            button:SetPoint("TOP", elvUIButton, "BOTTOM", 0, -16)
            print("UltraHardcore: Positioned button below ElvUI button (" .. buttonName .. ")")
            return
        end
    end

    -- Try to find Addons button as fallback
    local addonsButton = _G["GameMenuButtonAddons"]
    if addonsButton and addonsButton:IsVisible() then
        -- Position below Addons button with proper spacing
        button:SetPoint("TOP", addonsButton, "BOTTOM", 0, -16)
        print("UltraHardcore: Positioned button below Addons button")
        return
    end

    -- Default position if neither ElvUI nor Addons button found
    button:SetPoint("TOP", GameMenuFrame, "TOP", 0, -135)
    print("UltraHardcore: Using default button position")
end

-- Hook into the GameMenuFrame's OnShow event to adjust positioning
GameMenuFrame:HookScript("OnShow", function(self)
    -- Delay to ensure all other addons have created their buttons
    C_Timer.After(0.25, function()
        -- Position our button relative to existing buttons
        PositionUltraHardcoreButton()

        -- Adjust frame height if needed
        local currentHeight = self:GetHeight()
        local buttonHeight = 21 -- Standard GameMenuButton height
        local spacing = 1

        -- Only adjust height if we're adding to existing buttons
        -- The frame height is usually already adjusted by other addons
        local needsHeightIncrease = true

        -- Check if ElvUI or Addons already adjusted the height
        if (_G["GameMenuButtonElvUI"] and _G["GameMenuButtonElvUI"]:IsVisible()) or
           (_G["GameMenuButtonAddons"] and _G["GameMenuButtonAddons"]:IsVisible()) then
            needsHeightIncrease = false -- Height likely already adjusted
        end

        if needsHeightIncrease then
            local neededHeight = currentHeight + buttonHeight + spacing
            self:SetHeight(neededHeight)
        end

        -- Ensure our button is visible
        button:Show()
    end)
end) 