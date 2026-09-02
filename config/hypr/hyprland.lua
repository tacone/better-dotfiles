-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Omarchy's bootstrap keeps path setup out of this user config.
dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

-- Disable all Omarchy default bindings. Add your own in hypr/bindings.lua.
-- omarchy_default_bindings = false
--
-- Or disable only bindings for Omarchy's preinstalled apps/web apps while
-- keeping core window-manager bindings:
-- omarchy_preinstalled_bindings = false

-- Load Omarchy defaults.
require("default.hypr.omarchy")

-- Put your personal overrides in these files. They're loaded after Omarchy's
-- defaults so package updates can improve the defaults without rewriting your
-- ~/.config/hypr files.
require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

-- Toggle config flags dynamically.
require("default.hypr.toggles")

-- Add any other personal Hyprland configuration below.
-- o.window("qemu", { workspace = "5" })

-- ============================================================================
-- Workspace naming with Chinese numerals (carried over from the old config).
-- ============================================================================
-- Workspace naming with Chinese numerals (carried over from the old config).
-- Note: not persistent — empty workspaces are destroyed by Hyprland when you
-- switch away, so the bar only shows workspaces that currently exist.
hl.workspace_rule({ workspace = "1", default_name = "一", default = true })
hl.workspace_rule({ workspace = "2", default_name = "二" })
hl.workspace_rule({ workspace = "3", default_name = "三" })
hl.workspace_rule({ workspace = "4", default_name = "四" })
hl.workspace_rule({ workspace = "5", default_name = "五" })
hl.workspace_rule({ workspace = "6", default_name = "六" })
hl.workspace_rule({ workspace = "7", default_name = "七" })
hl.workspace_rule({ workspace = "8", default_name = "八" })
hl.workspace_rule({ workspace = "9", default_name = "九" })
hl.workspace_rule({ workspace = "10", default_name = "十" })
hl.workspace_rule({ workspace = "11", default_name = "十一" })
hl.workspace_rule({ workspace = "aaa", default_name = "aaa" })
hl.workspace_rule({ workspace = "12", default_name = "十二" })
hl.workspace_rule({ workspace = "13", default_name = "十三" })
hl.workspace_rule({ workspace = "14", default_name = "十四" })
hl.workspace_rule({ workspace = "15", default_name = "十五" })
hl.workspace_rule({ workspace = "16", default_name = "十六" })
hl.workspace_rule({ workspace = "17", default_name = "十七" })
hl.workspace_rule({ workspace = "18", default_name = "十八" })
hl.workspace_rule({ workspace = "19", default_name = "十九" })
hl.workspace_rule({ workspace = "20", default_name = "二十" })

-- ============================================================================
-- Apps customization (carried over from the old config).
-- ============================================================================

-- Prime Video: tag as a video site, remove browser opacity.
o.window("chrome-www.primevideo.com__-Default", { tag = "+video-site" })
o.window({ tag = "video-site" }, { tag = "-chromium-based-browser" })
o.window({ tag = "video-site" }, { tag = "-default-opacity" })
o.window({ tag = "video-site" }, { opacity = "1.0 1.0" })

-- Zen Browser file upload/save dialogs float.
o.window(
  { class = "^(xdg-desktop-portal-gtk)$", title = "^(Upload File.*|File Upload.*)" },
  { tag = "+floating-window" }
)

-- ============================================================================
-- Notes scratchpad (special workspace "notes").
-- omawrite opens as a floating 600px-wide panel along the right border, with
-- 100px top/bottom margins. Toggled with SUPER+N (see bindings.lua).
-- ============================================================================
o.window("omawrite", {
  float = true,
  workspace = "special:notes silent",
  size = { 600, "monitor_h - 200" },
  move = { "monitor_w - window_w", "100" },
})
