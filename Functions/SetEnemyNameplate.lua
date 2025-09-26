-- Prevent infinite recursion with CVar setting
local isSettingNameplateCVars = false

-- Store original nameplate settings to restore them later
local originalNameplateSettings = {
    enemies = nil,
    friends = nil,
    minAlpha = nil,
    maxAlpha = nil
}

function SetEnemyNameplateDisplay(hideNameplates)
    -- Prevent recursive CVar setting
    if isSettingNameplateCVars then
        return
    end
    isSettingNameplateCVars = true

    if hideNameplates then
        -- Store original settings before hiding
        if originalNameplateSettings.enemies == nil then
            originalNameplateSettings.enemies = GetCVar('nameplateShowEnemies')
            originalNameplateSettings.friends = GetCVar('nameplateShowFriends')
            originalNameplateSettings.minAlpha = GetCVar('nameplateMinAlpha')
            originalNameplateSettings.maxAlpha = GetCVar('nameplateMaxAlpha')
        end

        -- Hide ALL nameplates (enemies, friends, and make them transparent)
        SetCVar('nameplateShowEnemies', 0)
        SetCVar('nameplateShowFriends', 0)
        SetCVar('nameplateShowEnemyMinions', 0)
        SetCVar('nameplateMinAlpha', 0)
        SetCVar('nameplateMaxAlpha', 0)

        -- Hide ElvUI nameplates if ElvUI is loaded
        if UltraHardcore_ElvUI then
            UltraHardcore_ElvUI.HideElvUINameplates()
        end

        -- Force immediate nameplate refresh
        C_NamePlate.SetNamePlateEnemySize(1, 1) -- Trigger system refresh
    else
        -- Restore original nameplate settings
        if originalNameplateSettings.enemies ~= nil then
            SetCVar('nameplateShowEnemies', originalNameplateSettings.enemies)
            SetCVar('nameplateShowFriends', originalNameplateSettings.friends)
            SetCVar('nameplateMinAlpha', originalNameplateSettings.minAlpha)
            SetCVar('nameplateMaxAlpha', originalNameplateSettings.maxAlpha)
            SetCVar('nameplateShowEnemyMinions', 1) -- Usually enabled by default
        else
            -- Fallback to reasonable defaults if we don't have original settings
            SetCVar('nameplateShowEnemies', 1)
            SetCVar('nameplateShowFriends', 0) -- Usually disabled by default
            SetCVar('nameplateShowEnemyMinions', 1)
            SetCVar('nameplateMinAlpha', 0.5)
            SetCVar('nameplateMaxAlpha', 1.0)
        end

        -- Show ElvUI nameplates if ElvUI is loaded
        if UltraHardcore_ElvUI then
            UltraHardcore_ElvUI.ShowElvUINameplates()
        end

        -- Force immediate nameplate refresh
        C_NamePlate.SetNamePlateEnemySize(1, 1) -- Trigger system refresh
    end

    isSettingNameplateCVars = false
end

local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_ENTERING_WORLD')
frame:RegisterEvent('CVAR_UPDATE')

frame:SetScript('OnEvent', function(self, event, cvar)
    -- Only respond if we're not already setting CVars
    if isSettingNameplateCVars then
        return
    end

    if event == 'PLAYER_ENTERING_WORLD' or
        (event == 'CVAR_UPDATE' and (cvar == 'nameplateShowEnemies' or cvar == 'nameplateShowFriends')) then
        SetEnemyNameplateDisplay(GLOBAL_SETTINGS.hideEnemyNameplates)
    end
end)
