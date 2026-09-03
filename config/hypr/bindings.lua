-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Omarchy v4 changed SUPER+SHIFT+M from the YouTube Music webapp to the
-- native Spotify app. Restore the YouTube Music webapp binding.
hl.unbind("SUPER + SHIFT + M")
o.bind("SUPER + SHIFT + M", "Music", { webapp = "https://music.youtube.com/", focus = true })

-- Personal overrides carried over from the old bindings.conf (Omarchy v4's
-- Lua config no longer sources bindings.conf, so these are re-applied here).

-- SUPER+O: toggle floating and center the window (replaces default "Pop window out").
hl.unbind("SUPER + O")
o.bind("SUPER + O", "Toggle float & center", function()
  hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
  hl.dispatch(hl.dsp.window.center())
end)

-- SUPER+M: toggle the bar.
o.bind("SUPER + M", "Bar toggle", "omarchy-toggle-bar")

-- SUPER+SHIFT+P: Prime Video webapp (replaces default Google Photos).
hl.unbind("SUPER + SHIFT + P")
o.bind("SUPER + SHIFT + P", "Prime Video", { webapp = "https://www.primevideo.com/", focus = true })

-- SUPER+ALT+P: Preflight webapp (replaces default Power).
hl.unbind("SUPER + ALT + P")
o.bind("SUPER + ALT + P", "Preflight", { webapp = "https://preflight.traefik.me/app/operations", focus = true })

-- SUPER+ALT+A: Claude webapp.
o.bind("SUPER + ALT + A", "Claude", { webapp = "https://claude.ai/new" })

-- Scrolling layout column width cycling (presets in looknfeel.lua).
-- Columns are centered in view only at the widest preset (0.98); at other
-- widths the default "fit" behavior is used.

local function column_widths()
  local widths = {}
  for w in (hl.get_config("scrolling.explicit_column_widths") or ""):gmatch("[%d.]+") do
    widths[#widths + 1] = tonumber(w)
  end
  return widths
end

local function apply_column_width(width, widths)
  local widest = 0
  for _, w in ipairs(widths) do
    widest = math.max(widest, w)
  end
  hl.config({ scrolling = { focus_fit_method = (width == widest) and 0 or 1 } })
end

-- SUPER+R: cycle ALL columns through the preset widths.
local all_index = 0
o.bind("SUPER + R", "Resize all columns", function()
  local widths = column_widths()
  all_index = all_index % #widths + 1
  local width = widths[all_index]
  apply_column_width(width, widths) -- set center/fit mode first
  hl.dispatch(hl.dsp.layout("colresize all " .. width))
  -- colresize all doesn't move the view; bring the current column into view
  -- per the mode just set (centered at the widest preset, fitted otherwise).
  hl.dispatch(hl.dsp.layout("fit_into_view"))
end)

-- SUPER+SHIFT+R: cycle the CURRENT column through the preset widths.
local single_index = 0
o.bind("SUPER + SHIFT + R", "Resize column", function()
  local widths = column_widths()
  single_index = single_index % #widths + 1
  local width = widths[single_index]
  apply_column_width(width, widths) -- set center/fit mode first
  -- colresize auto-centers/fits the column using the mode just set.
  hl.dispatch(hl.dsp.layout("colresize " .. width))
end)

-- SUPER+ALT+1-0: switch to workspaces 11-20 (restored from bindings.conf).
-- The default SUPER+ALT+1-0 "Switch to group window" bindings collide with
-- these keys, so unbind them first.
for index = 1, 10 do
  hl.unbind("SUPER + ALT + code:" .. tostring(index + 9))
end
for workspace = 11, 20 do
  local key = "code:" .. tostring(workspace - 1)
  o.bind("SUPER + ALT + " .. key, "Switch to workspace " .. workspace, hl.dsp.focus({ workspace = tostring(workspace) }))
end

-- SUPER+N: toggle the notes scratchpad.
-- omawrite opens as a floating right-side panel (see hyprland.lua).
-- First press launches it on the primary monitor's active workspace; later
-- presses toggle it by moving it to/from a hidden special workspace (never
-- displayed, only used to hide the app when toggled off).
local NOTES_MONITOR = "eDP-1"
local NOTES_HIDDEN = "special:notes-hidden"
o.bind("SUPER + N", "Notes", function()
  local win = nil
  for _, w in ipairs(hl.get_windows()) do
    if w.class == "omawrite" then
      win = w
      break
    end
  end

  if not win then
    -- Not running: launch it floating on the primary monitor's active workspace.
    hl.dispatch(hl.dsp.focus({ monitor = NOTES_MONITOR }))
    hl.dispatch(hl.dsp.exec_raw("uwsm-app -- omawrite ~/notes.md"))
    return
  end

  -- Running: toggle between the hidden special workspace and the primary
  -- monitor's active workspace.
  local wsName = win.workspace and win.workspace.name or ""
  if wsName == NOTES_HIDDEN then
    -- Hidden: move back to the primary monitor's active workspace.
    hl.dispatch(hl.dsp.window.move({
      workspace = hl.get_active_workspace(NOTES_MONITOR),
      window = win,
    }))
  else
    -- Visible: move to the hidden special workspace. follow=false keeps the
    -- special workspace hidden (otherwise moving the window into it would
    -- display the special workspace as an overlay).
    hl.dispatch(hl.dsp.window.move({
      workspace = NOTES_HIDDEN,
      window = win,
      follow = false,
    }))
  end
end)

-- SUPER+S: toggle the scratchpad on the primary monitor (eDP-1).
-- The default binding uses toggle_special which acts on the focused monitor;
-- focus eDP-1 first so the scratchpad always appears there.
--
-- When the scratchpad special workspace is missing or empty, launch a fresh
-- default terminal into it (via exec_cmd's workspace rule) before showing it.
-- Closing the terminal empties the workspace, which Hyprland removes
-- automatically (misc.close_special_on_empty), so the next toggle creates a
-- fresh terminal again.
hl.unbind("SUPER + S")
o.bind("SUPER + S", "Toggle scratchpad", function()
  -- Always appear on the primary monitor.
  hl.dispatch(hl.dsp.focus({ monitor = "eDP-1" }))

  local ws = hl.get_workspace("special:scratchpad")
  if ws == nil or ws.is_empty then
    -- Missing or empty: launch a fresh default terminal into the scratchpad,
    -- then show it.
    hl.exec_cmd("omarchy-launch-terminal", { workspace = "special:scratchpad" })
  end
  hl.dispatch(hl.dsp.workspace.toggle_special("scratchpad"))
end)

-- SUPER+A: ChatGPT scratchpad on the primary monitor (eDP-1), same behavior as
-- the terminal scratchpad. When the special:chatgpt workspace is missing or
-- empty, launch the ChatGPT webapp into it before showing it. Closing it
-- empties the workspace, which Hyprland removes automatically, so the next
-- toggle creates a fresh ChatGPT again. (SUPER+SHIFT+A is left untouched.)
o.bind("SUPER + A", "ChatGPT scratchpad", function()
  -- Always appear on the primary monitor.
  hl.dispatch(hl.dsp.focus({ monitor = "eDP-1" }))

  local ws = hl.get_workspace("special:chatgpt")
  if ws == nil or ws.is_empty then
    -- Missing or empty: launch the ChatGPT webapp into the scratchpad.
    hl.exec_cmd("omarchy-launch-webapp https://chatgpt.com", { workspace = "special:chatgpt" })
  end
  hl.dispatch(hl.dsp.workspace.toggle_special("chatgpt"))
end)

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")
