-- See https://wiki.hypr.land/Configuring/Basics/Binds/

local terminal        = "kitty"
local fileManager     = "dolphin"
local internetBrowser = "zen-browser"
local systemMonitor   = "plasma-systemmonitor"

local mainMod         = "SUPER"

hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + CONTROL + escape",
  hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(internetBrowser))
hl.bind(mainMod .. " + backspace", hl.dsp.exec_cmd(systemMonitor))

-- Layout
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + bracketright", hl.dsp.layout("togglesplit")) -- dwindle
hl.bind(mainMod .. " + bracketleft", hl.dsp.layout("swapsplit"))    -- dwindle

-- Tab grouping
hl.bind(mainMod .. " + backslash", hl.dsp.group.toggle())
hl.bind(mainMod .. " + SHIFT + backslash", hl.dsp.group.next())

-- Toggle fullscreen
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())

-- Navigate/move windows with mainMod (+ SHIFT) + arrows
for _, d in pairs({ "left", "right", "up", "down" }) do
  hl.bind(mainMod .. " + " .. d, hl.dsp.focus({ direction = d }))
  hl.bind(mainMod .. " + SHIFT + " .. d, hl.dsp.window.move({ direction = d }))
end

-- Switch/move to workspaces with mainMod (+ SHIFT) + [0-9]
for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Navigate through existing workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

for k, w in pairs({ period = "e+1", comma = "e-1", N = "empty" }) do
  hl.bind(mainMod .. " + " .. k, hl.dsp.focus({ workspace = w }))
  hl.bind(mainMod .. " + SHIFT + " .. k, hl.dsp.window.move({ workspace = w }))
end

-- Navigate through apps
hl.bind("ALT + TAB", hl.dsp.focus({ last = true }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Resize windows in regular increments
hl.bind(mainMod .. " + equal", hl.dsp.window.resize({ x = 100, y = 0, relative = true }))
hl.bind(mainMod .. " + minus", hl.dsp.window.resize({ x = -100, y = 0, relative = true }))
hl.bind(mainMod .. " + SHIFT + equal", hl.dsp.window.resize({ x = 0, y = 100, relative = true }))
hl.bind(mainMod .. " + SHIFT + minus", hl.dsp.window.resize({ x = 0, y = -100, relative = true }))

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
  { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
  { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
  { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Screenshotting using grimblast
hl.bind("print", hl.dsp.exec_cmd("GRIMBLAST_EDITOR=gwenview grimblast --freeze edit area"))
hl.bind("SHIFT + print", hl.dsp.exec_cmd("grimblast --notify --openparentdir copysave screen"))
hl.bind("SHIFT + CONTROL + print", hl.dsp.exec_cmd("grimblast --notify --openparentdir copysave active"))

-- Noctalia
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("qs -c noctalia-shell ipc call launcher toggle"))
hl.bind(mainMod .. " + TAB", hl.dsp.exec_cmd("qs -c noctalia-shell ipc call launcher windows"))
hl.bind(mainMod .. " + GRAVE", hl.dsp.exec_cmd("qs -c noctalia-shell ipc call lockScreen lock"))
hl.bind(mainMod .. " + SHIFT + F5", hl.dsp.exec_cmd("qs -c noctalia-shell ipc call brightness decrease"))
hl.bind(mainMod .. " + SHIFT + F6", hl.dsp.exec_cmd("qs -c noctalia-shell ipc call brightness increase"))
