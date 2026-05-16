-- Noctalia theming user template.
-- Valid standalone, or as a base for your own templates.
-- See: https://docs.noctalia.dev/v4/theming/user-templates/
--
-- Note: Noctalia already supports Hyprland out of the box,
-- but for the moment only produces the legacy .conf format.
-- This template targets the new .lua format.
--
-- Example configuration (in ~/.config/noctalia/user-templates.toml):
-- 
-- [templates.Hyprland]
-- input_path = "~/.config/hypr/noctalia/template.lua"
-- output_path = "~/.config/hypr/noctalia/theme.lua"
-- post_hook = "hyprctl reload config-only"
--

local primary = "{{ colors.primary.default.rgba  }}"
local surface = "{{ colors.surface.default.rgba }}"
local secondary = "{{ colors.secondary.default.rgba }}"
local error = "{{ colors.error.default.rgba }}"
local tertiary = "{{ colors.tertiary.default.rgba }}"

hl.config({
  general = {
    col = {
      active_border = primary,
      inactive_border = surface,
    }
  },
  group = {
    col = {
      border_active = secondary,
      border_inactive = surface,
      border_locked_active = error,
      border_locked_inactive = surface,
    },
    groupbar = {
      col = {
        active = secondary,
        inactive = surface,
        locked_active = error,
        locked_inactive = surface,
      },
    },
  },
})
