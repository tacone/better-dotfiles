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

-- SUPER+N: toggle the notes scratchpad (special workspace "notes").
-- omawrite opens there as a floating right-side panel (see hyprland.lua).
-- If omawrite isn't running yet, launch it on ~/notes.md; then toggle the
-- special workspace to show/hide it.
o.bind("SUPER + N", "Notes", function()
  local running = false
  for _, w in ipairs(hl.get_windows()) do
    if w.class == "omawrite" then
      running = true
      break
    end
  end
  if not running then
    hl.dispatch(hl.dsp.exec_raw("uwsm-app -- omawrite ~/notes.md"))
  end
  hl.dispatch(hl.dsp.workspace.toggle_special("notes"))
end)

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")
