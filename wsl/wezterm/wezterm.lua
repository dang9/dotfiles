-- These are the basic's for using wezterm.
-- Mux is the mutliplexes for windows etc inside of the terminal
-- Action is to perform actions on the terminal
local wezterm = require 'wezterm'
local mux = wezterm.mux
local act = wezterm.action

local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")


-- These are vars to put things in later (i dont use em all yet)
local config = {}
local keys = {}
local mouse_bindings = {}
local launch_menu = {}

-- This is for newer wezterm vertions to use the config builder 
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Default config settings
-- These are the default config settins needed to use Wezterm
-- Just add this and return config and that's all the basics you need

-- Color scheme, Wezterm has 100s of them you can see here:
-- https://wezfurlong.org/wezterm/colorschemes/index.html

config.adjust_window_size_when_changing_font_size = false
config.automatically_reload_config = true
config.color_scheme = 'Oceanic Next (Gogh)'
-- This is my chosen font, we will get into installing fonts on windows later
config.font = wezterm.font('Hack Nerd Font')
config.font_size = 11
config.launch_menu = launch_menu
-- makes my cursor blink 
config.default_cursor_style = 'BlinkingBar'
config.disable_default_key_bindings = true
-- this adds the ability to use ctrl+v to paste the system clipboard 
config.keys = {{ key = 'V', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },}
config.mouse_bindings = mouse_bindings

config.font_size = 12.0
config.hide_tab_bar_if_only_one_tab = true
config.scroll_to_bottom_on_input = false
config.pane_focus_follows_mouse = true
config.scrollback_lines = 5000
config.use_dead_keys = false
config.warn_about_missing_glyphs = false
config.window_decorations = 'RESIZE'
config.macos_window_background_blur = 30
config.window_close_confirmation = 'NeverPrompt'
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

-- There are mouse binding to mimc Windows Terminal and let you copy
-- To copy just highlight something and right click. Simple

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 }

mouse_bindings = {
  {
    event = { Down = { streak = 3, button = 'Left' } },
    action = wezterm.action.SelectTextAtMouseCursor 'SemanticZone',
    mods = 'NONE',
  },
 {
  event = { Down = { streak = 1, button = "Right" } },
  mods = "NONE",
  action = wezterm.action_callback(function(window, pane)
   local has_selection = window:get_selection_text_for_pane(pane) ~= ""
   if has_selection then
    window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
    window:perform_action(act.ClearSelection, pane)
   else
    window:perform_action(act({ PasteFrom = "Clipboard" }), pane)
   end
  end),
 },
}

-- This is used to make my foreground (text, etc) brighter than my background
config.foreground_text_hsb = {
  hue = 1.0,
  saturation = 1.2,
  brightness = 1.5,
}

-- IMPORTANT: Sets WSL2 UBUNTU-24.04 as the defualt when opening Wezterm
config.default_domain = 'WSL:Ubuntu-24.04'

-- Tab bar
config.enable_tab_bar = true
config.tab_bar_at_bottom = true
config.switch_to_last_active_tab_when_closing_tab = true
config.tab_max_width = 32
config.colors = {
    tab_bar = {
        active_tab = {
            fg_color = '#073642',
            bg_color = '#2aa198',
        }
    }
}

bar.apply_to_config(config)
return config