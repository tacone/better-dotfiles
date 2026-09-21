-- Immediate MRU Alt+Tab for Hyprland: cycle the windows on the current
-- workspace, most recently used first. Each TAB tap switches focus immediately;
-- no panel.
--
-- Fork of omarchy-altswitch (Pablo Merino, MIT) with the preview panel and
-- release-to-commit removed, and the window list scoped to the active
-- workspace. The list is snapshotted when the switch starts and frozen, so the
-- order cannot shuffle underneath you while tabbing.

local altswitch = { windows = {}, index = 1, active = false }

-- Single-quote a string for the shell.
local function shell_quote(value)
  return "'" .. tostring(value):gsub("'", "'\\''") .. "'"
end

-- Focus is dispatched out of process on purpose. Focusing directly from inside
-- the key callback updates Hyprland's idea of the active window but does not
-- settle until the next input event, so the switch looks like it did nothing
-- until you tap a key again. Going through hyprctl runs the same dispatcher
-- from outside the input callback, where it takes effect at once.
local function altswitch_focus(address)
  if not address then return end
  local focus = string.format('hl.dsp.focus({ window = "address:%s" })', address)
  hl.exec_cmd("hyprctl dispatch " .. shell_quote(focus))
end

local function altswitch_teardown()
  altswitch.active = false
  altswitch.windows = {}
end

local function altswitch_snapshot()
  -- Scope to the active window's workspace, not hl.get_active_workspace():
  -- inside a special workspace the latter still reports the normal workspace
  -- underneath, which would make Alt+Tab jump out of the special workspace.
  local active = hl.get_active_window()
  local scope = active and active.workspace or hl.get_active_workspace()
  local windows = {}
  for _, window in ipairs(hl.get_windows()) do
    local workspace = window.workspace
    if window.mapped and workspace and workspace.id == scope.id then
      windows[#windows + 1] = window
    end
  end

  table.sort(windows, function(a, b) return a.focus_history_id < b.focus_history_id end)
  return windows
end

local function altswitch_step(delta)
  -- Already switching: just move the cursor, wrapping at both ends.
  if altswitch.active then
    altswitch.index = (altswitch.index - 1 + delta) % #altswitch.windows + 1
    altswitch_focus(altswitch.windows[altswitch.index].address)
    return
  end

  altswitch.windows = altswitch_snapshot()
  if #altswitch.windows < 2 then
    return
  end

  -- Entry 1 is the window you are already on, so one tap has to land on entry 2
  -- and one back-tap has to wrap to the oldest.
  altswitch.index = delta % #altswitch.windows + 1
  altswitch.active = true
  altswitch_focus(altswitch.windows[altswitch.index].address)
end

-- Omarchy binds ALT+TAB four times by default (cyclenext and bring_to_top, in
-- both directions), so both chords are cleared before rebinding.
hl.unbind("ALT + TAB")
hl.unbind("ALT + SHIFT + TAB")
hl.bind("ALT + TAB", function() altswitch_step(1) end, { description = "Switch window (MRU)" })
hl.bind("ALT + SHIFT + TAB", function() altswitch_step(-1) end, { description = "Switch window (MRU, reverse)" })

-- Reset the frozen snapshot when ALT is released. The switch already happened
-- on the last TAB tap, so there is nothing to commit.
--
-- 64 is Alt_L and 108 is Alt_R. This runs for every keystroke on the system, so
-- it stays down to two integer compares and a boolean unless a switch is up.
local ALT_KEYCODES = { [64] = true, [108] = true }

hl.on("input.keyboard.key", function(keycode, _, state)
  if state == 0 and altswitch.active and ALT_KEYCODES[keycode] then
    altswitch_teardown()
  end
end)