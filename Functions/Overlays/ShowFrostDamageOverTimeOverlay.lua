local frostDamageOverTimeOverlayFrame = nil

function ShowFrostDamageOverTimeOverlay()
    if not frostDamageOverTimeOverlayFrame then
        local success, err = pcall(function()
            frostDamageOverTimeOverlayFrame = CreateFrame("Frame", "FrostDamageOverTimeOverlay", UIParent)
            if not frostDamageOverTimeOverlayFrame then return end

            frostDamageOverTimeOverlayFrame:SetFrameStrata("FULLSCREEN_DIALOG")
            frostDamageOverTimeOverlayFrame:SetAllPoints(UIParent)

            frostDamageOverTimeOverlayFrame.texture = frostDamageOverTimeOverlayFrame:CreateTexture(nil, "ARTWORK")
            if not frostDamageOverTimeOverlayFrame.texture then return end

            frostDamageOverTimeOverlayFrame.texture:SetAllPoints()
            frostDamageOverTimeOverlayFrame.texture:SetTexture("Interface\\AddOns\\UltraHardcore\\Textures\\frost-damage.png")
            frostDamageOverTimeOverlayFrame:SetAlpha(0)
            frostDamageOverTimeOverlayFrame:Hide()
        end)

        if not success then
            print("UltraHardcore: Error creating frost damage over time overlay frame:", err)
            return
        end
    end

    if not frostDamageOverTimeOverlayFrame then return end

    frostDamageOverTimeOverlayFrame:Show()
    UIFrameFadeIn(frostDamageOverTimeOverlayFrame, 0.2, 0, 0.7)

    C_Timer.After(1.5, function()
        if frostDamageOverTimeOverlayFrame and frostDamageOverTimeOverlayFrame:IsShown() then
            UIFrameFadeOut(frostDamageOverTimeOverlayFrame, 0.5, 0.7, 0)
        end
    end)
end