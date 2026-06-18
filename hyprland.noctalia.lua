-------------------------------------------------------------------------------
--                     Core configration | Hyprland 0.55                     --
-------------------------------------------------------------------------------

-- Refer to the wiki for more information:
-- https://wiki.hyprland.org/Configuring/


------------------
---- MONITORS ----
------------------

-- Base monitor settings.
-- Use local overrides for adjustments!
hl.monitor({
  output   = "",
  mode     = "preferred",
  position = "auto",
  scale    = "auto",
})

hl.config({
  -- Don't scale X11 apps
  xwayland = {
    force_zero_scaling = true,
  },

  render = {
    cm_auto_hdr = 1, -- Color passthrough for fullscreen HDR apps
  },
})


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hyprland.org/Configuring/Environment-variables/
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto") -- advises Chromium apps to use Wayland
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
  hl.exec_cmd("systemctl --user start hyprpolkitagent")

  -- Fixes broken file association in Dolphin. See: https://bbs.archlinux.org/viewtopic.php?pid=2167377
  -- The fix often fails to persist between sessions, which is why it was added to the boot sequence.
  -- Not completely free. Adds something around 90ms to the boot time. Irksome.
  hl.exec_cmd("XDG_MENU_PREFIX=arch- kbuildsycoca6")

  -- Overwrite Plasma's icon theme for the duration of the session only.
  -- This is regrettably a shared setting, so a startup/shutdown hook is the only way to achieve separation.
  hl.exec_cmd(os.getenv("HOME") .. "/.config/hypr/override-kde-globals.bb Tela") -- Selective overwrite. Requires Babashka!

  -- Restore GTK settings established via nwg-look.
  -- This is necessary because Plasma will overwrite them every time it launches.
  hl.exec_cmd("nwg-look -a") -- restore gsettings

  -- Start Noctalia
  -- hl.exec_cmd("qs -c noctalia-shell") -- Manual start.
  -- With systemd. Recommended, but you need to create a service file yourself.
  -- See: https://docs.noctalia.dev/getting-started/running-the-shell/
  hl.exec_cmd("systemctl --user start noctalia")
end)


------------------
---- SHUTDOWN ----
------------------

hl.on("hyprland.shutdown", function()
  -- Restore Plasma's icon theme at the end of the session.
  -- This is regrettably a shared setting, so a startup/shutdown hook is the only way to achieve separation.
  hl.exec_cmd(os.getenv("HOME") .. "/.config/hypr/override-kde-globals.bb Greeze")
end)


-------------------
--- KEYBINDINGS ---
-------------------

require("keybindings")


-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hyprland.org/Configuring/Variables/
hl.config({
  general = {
    gaps_in = 5,
    gaps_out = 10,

    border_size = 1,

    -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
    resize_on_border = false,

    -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
    allow_tearing = false,

    layout = "dwindle",
  },

  decoration = {
    rounding         = 10,
    rounding_power   = 4,

    -- Change transparency of focused and unfocused windows
    active_opacity   = 1.0,
    inactive_opacity = 1.0,

    shadow           = {
      enabled = true,
      range = 4,
      render_power = 3,
      color = 0xee1a1a1a,
    },

    blur             = {
      enabled = true,
      size = 3,
      passes = 1,
      vibrancy = 0.1696,
    },
  },

  animations = {
    enabled = true,
  },

  dwindle = {
    preserve_split = true,
  },

  master = {
    new_status = "master",
    drop_at_cursor = true,
  },

  misc = {
    force_default_wallpaper = -1,    -- Set to 0 or 1 to disable the anime mascot wallpapers
    disable_hyprland_logo   = false, -- If true disables the random hyprland logo / anime girl background. :(
    disable_autoreload      = 1,
  },

  scrolling = {
    fullscreen_on_one_column = true,
  },

  input = {
    kb_layout = "pl",
    follow_mouse = 1,
    sensitivity = -0.6,

    touchpad = {
      natural_scroll = false,
    },
  },
})

hl.layer_rule({
  name         = "noctalia",
  match        = { namespace = "noctalia-background-.*$" },
  ignore_alpha = 0.5,
  blur         = true,
  blur_popups  = true,
})

require("animations")


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

hl.window_rule({
  -- Ignore maximize requests from all apps. You'll probably like this.
  name           = "suppress-maximize-events",
  match          = { class = ".*" },

  suppress_event = "maximize",
})

hl.window_rule({
  -- Fix some dragging issues with XWayland
  name     = "fix-xwayland-drags",
  match    = {
    class      = "^$",
    title      = "^$",
    xwayland   = true,
    float      = true,
    fullscreen = false,
    pin        = false,
  },

  no_focus = true,
})

-- Certain apps to be spawned in the scratchpad workspace.
hl.window_rule({
  name      = "discord",
  workspace = "special:magic",
  match     = { initial_class = "discord|vesktop" },
})

hl.window_rule({
  name      = "spotify",
  workspace = "special:magic",
  match     = { initial_class = "[Ss]potify" },
})

hl.window_rule({
  name    = "equinox",
  match   = { initial_title = "Equinox" },
  float   = true,
  opacity = 0.95,
  size    = "monitor_w*0.25, monitor_h*0.25",
  move    = "monitor_w-window_w*1.5 40",
})

hl.window_rule({
  name   = "gnome-calendar",
  match  = { initial_class = "org.gnome.Calendar" },
  float  = true,
  size   = "monitor_w*0.5 monitor_h*0.5",
  center = true,
})

hl.window_rule({
  name   = "mpv",
  match  = { initial_class = "mpv" },
  float  = true,
  center = true,
  size   = "monitor_w*0.5 monitor_h*0.5",
})

hl.window_rule({
  name  = "plasma-systemmonitor",
  match = { initial_class = "org.kde.plasma-systemmonitor" },
  float = true,
})


-------------
--- THEME ---
-------------

require("noctalia.theme")


-----------------------
--- LOCAL OVERRIDES ---
-----------------------

--  * Loaded last to ensure that they take precedence over defaults.
--  * Loaded in alphabetical order.

local overridePath = os.getenv("HOME") .. "/.config/hypr/local/"
local f = io.popen("find " .. overridePath .. " -type f -name '*.lua' -exec basename {} \\; 2>/dev/null | sort")
if f then
  local ff = f:read("*line")
  while ff do
    require("local." .. ff:sub(0, -5))
    ff = f:read("*line")
  end
  f:close()
end
