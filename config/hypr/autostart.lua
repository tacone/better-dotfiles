-- Extra autostart processes.
-- o.launch_on_start("my-service")

-- Persist clipboard contents across window closures.
o.exec_on_start("wl-clip-persist --clipboard regular --all-mime-type-regex '(?i)^(?!image/x-inkscape-svg).+'")

-- User-level lid close monitor - suspends even when docked.
o.exec_on_start("~/.config/omarchy/lid-monitor.sh")
