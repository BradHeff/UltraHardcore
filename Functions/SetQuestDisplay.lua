function SetQuestDisplay(hideQuestFrame)
  if hideQuestFrame then
    -- In MoP Classic, quest tracking uses ObjectiveTrackerFrame
    if ObjectiveTrackerFrame then
      ForceHideFrame(ObjectiveTrackerFrame)
    elseif QuestWatchFrame then
      -- Fallback for older versions
      ForceHideFrame(QuestWatchFrame)
    end
  else
    -- Show quest tracker
    if ObjectiveTrackerFrame then
      RestoreAndShowFrame(ObjectiveTrackerFrame)
    elseif QuestWatchFrame then
      -- Fallback for older versions
      RestoreAndShowFrame(QuestWatchFrame)
    end
  end
end
