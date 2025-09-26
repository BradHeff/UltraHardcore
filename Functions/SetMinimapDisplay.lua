function SetMinimapDisplay(hideMinimap)
  if hideMinimap then
    HideMinimap()
  else
    ShowMinimap()
  end
end

function HideMinimap()
  Minimap:Hide()
  -- Hide the zone text
  MinimapZoneText:Hide()
  -- Hide the background bar behind the zone text
  MinimapZoneTextButton:Hide()
  -- Hide the close/minimap tracking button (the button that shows tracking options)
  MiniMapTracking:Hide()
  -- Hide the day/night indicator (moon/sun icon)
  GameTimeFrame:Hide()
  -- Hide the minimap cluster (including the "Toggle minimap" button)
  MinimapCluster:Hide()

  -- Hide ElvUI minimap if ElvUI is loaded
  if UltraHardcore_ElvUI then
    UltraHardcore_ElvUI.HideElvUIMinimap()
  end
end

function ShowMinimap()
  Minimap:Show()
  -- Show the zone text
  MinimapZoneText:Show()
  -- Show the background bar behind the zone text
  MinimapZoneTextButton:Show()
  -- Show the close/minimap tracking button (the button that shows tracking options)
  MiniMapTracking:Show()
  -- Show the day/night indicator (moon/sun icon)
  GameTimeFrame:Show()
  -- Show the minimap cluster (including the "Toggle minimap" button)
  MinimapCluster:Show()

  -- Show ElvUI minimap if ElvUI is loaded
  if UltraHardcore_ElvUI then
    UltraHardcore_ElvUI.ShowElvUIMinimap()
  end
end
