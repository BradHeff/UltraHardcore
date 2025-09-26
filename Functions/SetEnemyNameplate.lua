-- Prevent infinite recursion with CVar setting
local isSettingNameplateCVars = false

function SetEnemyNameplateDisplay(hideNameplates)
  -- Prevent recursive CVar setting
  if isSettingNameplateCVars then return end
  isSettingNameplateCVars = true

  if hideNameplates then
    -- Hide Blizzard nameplates
    SetCVar('nameplateShowEnemies', 0)
    SetCVar('nameplateShowFriends', 0)

    -- Hide ElvUI nameplates if ElvUI is loaded
    if UltraHardcore_ElvUI then
      UltraHardcore_ElvUI.HideElvUINameplates()
    end
  else
    -- Show Blizzard nameplates
    SetCVar('nameplateShowEnemies', 1)

    -- Show ElvUI nameplates if ElvUI is loaded
    if UltraHardcore_ElvUI then
      UltraHardcore_ElvUI.ShowElvUINameplates()
    end
  end

  isSettingNameplateCVars = false
end

local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_ENTERING_WORLD')
frame:RegisterEvent('CVAR_UPDATE')

frame:SetScript('OnEvent', function(self, event, cvar)
  -- Only respond if we're not already setting CVars
  if isSettingNameplateCVars then return end

  if event == 'PLAYER_ENTERING_WORLD' or (event == 'CVAR_UPDATE' and (cvar == 'nameplateShowEnemies' or cvar == 'nameplateShowFriends')) then
    SetEnemyNameplateDisplay(GLOBAL_SETTINGS.hideEnemyNameplates)
  end
end)
