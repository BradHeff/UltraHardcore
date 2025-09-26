local frostDamageOverlayFrame = nil

function ShowFrostDamageOverlay()
    if not frostDamageOverlayFrame then
        local success, err = pcall(function()
            frostDamageOverlayFrame = CreateFrame("Frame", "FrostDamageOverlay", UIParent)
            if not frostDamageOverlayFrame then return end

            frostDamageOverlayFrame:SetFrameStrata("FULLSCREEN_DIALOG")
            frostDamageOverlayFrame:SetAllPoints(UIParent)

            frostDamageOverlayFrame.texture = frostDamageOverlayFrame:CreateTexture(nil, "ARTWORK")
            if not frostDamageOverlayFrame.texture then return end

            frostDamageOverlayFrame.texture:SetAllPoints()
            frostDamageOverlayFrame.texture:SetTexture("Interface\\AddOns\\UltraHardcore\\Textures\\frost-damage.png")
            frostDamageOverlayFrame:SetAlpha(0)
            frostDamageOverlayFrame:Hide()
        end)

        if not success then
            print("UltraHardcore: Error creating frost damage overlay frame:", err)
            return
        end
    end

    if not frostDamageOverlayFrame then return end

    frostDamageOverlayFrame:Show()
    UIFrameFadeIn(frostDamageOverlayFrame, 0.3, 0, 1)

    C_Timer.After(0.7, function()
        if frostDamageOverlayFrame and frostDamageOverlayFrame:IsShown() then
            UIFrameFadeOut(frostDamageOverlayFrame, 0.3, 1, 0)
        end
    end)
end