function SetCustomBuffFrame(hideBuffFrame)
  if hideBuffFrame then
    HideBuffFrame()
  else
    ShowBuffFrame()
  end
end

function HideBuffFrame()
  -- Hide the default buff frame
  ForceHideFrame(BuffFrame)

  -- Hide ElvUI buffs/debuffs if ElvUI is loaded
  if UltraHardcore_ElvUI then
    UltraHardcore_ElvUI.HideElvUIBuffs()
  end
end

function ShowBuffFrame()
  -- Show the default buff frame and make it draggable
  RestoreAndShowFrame(BuffFrame)
  SetBuffFrame()

  -- Show ElvUI buffs/debuffs if ElvUI is loaded
  if UltraHardcore_ElvUI then
    UltraHardcore_ElvUI.ShowElvUIBuffs()
  end
end

function SetBuffFrame()
  -- Make the buff frame draggable
  BuffFrame:SetMovable(true)
  BuffFrame:EnableMouse(true)
  BuffFrame:RegisterForDrag('LeftButton')
  BuffFrame:SetScript('OnDragStart', function(self)
    self:StartMoving()
  end)
  BuffFrame:SetScript('OnDragStop', function(self)
    self:StopMovingOrSizing()
  end)

  BuffFrame:ClearAllPoints()
  BuffFrame:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -175, 90)
end
