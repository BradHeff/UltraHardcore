function SetPlayerFrameDisplay(value)
    if value then
        HidePlayerFrame()
    else
        ShowPlayerFrame()
    end

    -- Update the global setting for other modules to reference
    GLOBAL_SETTINGS.hidePlayerFrame = value

    -- Sync ElvUI DataTexts if integration is available
    if _G.UltraHardcore_SyncElvUIDataTexts then
        _G.UltraHardcore_SyncElvUIDataTexts()
    end
end

function HidePlayerFrame()
    ForceHideFrame(PlayerFrame)
    ForceHideFrame(TargetFrameToT)

    -- Hide ElvUI player frame and datapanels if ElvUI is loaded
    if UltraHardcore_ElvUI then
        UltraHardcore_ElvUI.HideElvUIPlayerFrame()
        UltraHardcore_ElvUI.HideElvUIDatapanels()
        UltraHardcore_ElvUI.HideElvUIMicrobar()
    end -- Use enhanced ElvUI integration if available
    if _G.UltraHardcore_ElvUIPlayerFrameToggle then
        _G.UltraHardcore_ElvUIPlayerFrameToggle(false)
    end
end

function ShowPlayerFrame()
    RestoreAndShowFrame(PlayerFrame)
    RestoreAndShowFrame(TargetFrameToT)

    -- Show ElvUI player frame and datapanels if ElvUI is loaded
    if UltraHardcore_ElvUI then
        UltraHardcore_ElvUI.ShowElvUIPlayerFrame()
        UltraHardcore_ElvUI.ShowElvUIDatapanels()
        UltraHardcore_ElvUI.ShowElvUIMicrobar()
    end -- Use enhanced ElvUI integration if available
    if _G.UltraHardcore_ElvUIPlayerFrameToggle then
        _G.UltraHardcore_ElvUIPlayerFrameToggle(true)
    end
end
