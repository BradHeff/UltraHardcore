function GetCurrentResourceType()
    local _, playerClass = UnitClass('player')
    local form = GetShapeshiftFormID()
    -- MoP Classic Form IDs:
    -- 1 for Cat Form
    -- 5 for Bear Form
    -- 3 for Travel Form
    -- 4 for Aquatic Form
    -- 29 for Flight Form
    -- 27 for Swift Flight Form
    -- 31-35 for Moonkin Form (varies by race)
    if playerClass == 'ROGUE' or (playerClass == 'DRUID' and form == 1) then
      return 'ENERGY'
    elseif playerClass == 'WARRIOR' or (playerClass == 'DRUID' and form == 5) then
      return 'RAGE'
    elseif playerClass == 'MONK' then
      return 'CHI' -- MoP added Monks with Chi resource
    elseif playerClass == 'HUNTER' then
      return 'FOCUS' -- Hunters use Focus in MoP
    elseif playerClass == 'DEATHKNIGHT' then
      return 'RUNIC_POWER' -- Death Knights use Runic Power
    end
    return 'MANA'
  end
  