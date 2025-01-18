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
config.enable_scroll_bar = false
config.enable_wayland = true
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


-- Custom key bindings
config.keys = {
  -- -- Disable Alt-Enter combination (already used in tmux to split pane)
  -- {
  --     key = 'Enter',
  --     mods = 'ALT',
  --     action = act.DisableDefaultAssignment,
  -- },

  -- Copy mode
  {
      key = '[',
      mods = 'LEADER',
      action = act.ActivateCopyMode,
  },

  -- ----------------------------------------------------------------
  -- TABS
  --
  -- Where possible, I'm using the same combinations as I would in tmux
  -- ----------------------------------------------------------------

  -- Show tab navigator; similar to listing panes in tmux
  {
      key = 'w',
      mods = 'LEADER',
      action = act.ShowTabNavigator,
  },
  -- Create a tab (alternative to Ctrl-Shift-Tab)
  {
      key = 'c',
      mods = 'LEADER',
      action = act.SpawnTab 'CurrentPaneDomain',
  },
  -- Rename current tab; analagous to command in tmux
  {
      key = ',',
      mods = 'LEADER',
      action = act.PromptInputLine {
          description = 'Enter new name for tab',
          action = wezterm.action_callback(
              function(window, pane, line)
                  if line then
                      window:active_tab():set_title(line)
                  end
              end
          ),
      },
  },
  -- Move to next/previous TAB
  {
      key = 'n',
      mods = 'LEADER',
      action = act.ActivateTabRelative(1),
  },
  {
      key = 'p',
      mods = 'LEADER',
      action = act.ActivateTabRelative(-1),
  },
  -- Close tab
  {
      key = '&',
      mods = 'LEADER|SHIFT',
      action = act.CloseCurrentTab{ confirm = true },
  },

  -- ----------------------------------------------------------------
  -- PANES
  --
  -- These are great and get me most of the way to replacing tmux
  -- entirely, particularly as you can use "wezterm ssh" to ssh to another
  -- server, and still retain Wezterm as your terminal there.
  -- ----------------------------------------------------------------

  -- -- Vertical split
  {
      -- |
      key = '|',
      mods = 'LEADER|SHIFT',
      action = act.SplitPane {
          direction = 'Right',
          size = { Percent = 50 },
      },
  },
  -- Horizontal split
  {
      -- -
      key = '-',
      mods = 'LEADER',
      action = act.SplitPane {
          direction = 'Down',
          size = { Percent = 50 },
      },
  },
  -- CTRL + (h,j,k,l) to move between panes
  {
      key = 'h',
      mods = 'CTRL',
      action = act({ EmitEvent = "move-left" }),
  },
  {
      key = 'j',
      mods = 'CTRL',
      action = act({ EmitEvent = "move-down" }),
  },
  {
      key = 'k',
      mods = 'CTRL',
      action = act({ EmitEvent = "move-up" }),
  },
  {
      key = 'l',
      mods = 'CTRL',
      action = act({ EmitEvent = "move-right" }),
  },
  -- ALT + (h,j,k,l) to resize panes
  {
      key = 'h',
      mods = 'ALT',
      action = act({ EmitEvent = "resize-left" }),
  },
  {
      key = 'j',
      mods = 'ALT',
      action = act({ EmitEvent = "resize-down" }),
  },
  {
      key = 'k',
      mods = 'ALT',
      action = act({ EmitEvent = "resize-up" }),
  },
  {
      key = 'l',
      mods = 'ALT',
      action = act({ EmitEvent = "resize-right" }),
  },
  -- Close/kill active pane
  {
      key = 'x',
      mods = 'LEADER',
      action = act.CloseCurrentPane { confirm = true },
  },
  -- Swap active pane with another one
  {
      key = '{',
      mods = 'LEADER|SHIFT',
      action = act.PaneSelect { mode = "SwapWithActiveKeepFocus" },
  },
  -- Zoom current pane (toggle)
  {
      key = 'z',
      mods = 'LEADER',
      action = act.TogglePaneZoomState,
  },
  {
      key = 'f',
      mods = 'ALT',
      action = act.TogglePaneZoomState,
  },
  -- Move to next/previous pane
  {
      key = ';',
      mods = 'LEADER',
      action = act.ActivatePaneDirection('Prev'),
  },
  {
      key = 'o',
      mods = 'LEADER',
      action = act.ActivatePaneDirection('Next'),
  },

  -- ----------------------------------------------------------------
  -- Workspaces
  --
  -- These are roughly equivalent to tmux sessions.
  -- ----------------------------------------------------------------

  -- Attach to muxer
  {
      key = 'a',
      mods = 'LEADER',
      action = act.AttachDomain 'unix',
  },

  -- Detach from muxer
  {
      key = 'd',
      mods = 'LEADER',
      action = act.DetachDomain { DomainName = 'unix' },
  },

  -- Show list of workspaces
  {
      key = 's',
      mods = 'LEADER',
      action = act.ShowLauncherArgs { flags = 'WORKSPACES' },
  },
  -- Rename current session; analagous to command in tmux
  {
      key = '$',
      mods = 'LEADER|SHIFT',
      action = act.PromptInputLine {
          description = 'Enter new name for session',
          action = wezterm.action_callback(
              function(window, pane, line)
                  if line then
                      mux.rename_workspace(
                          window:mux_window():get_workspace(),
                          line
                      )
                  end
              end
          ),
      },
  },

  -- Session manager bindings
  -- {
  --     key = 's',
  --     mods = 'LEADER|SHIFT',
  --     action = act({ EmitEvent = "save_session" }),
  -- },
  -- {
  --     key = 'L',
  --     mods = 'LEADER|SHIFT',
  --     action = act({ EmitEvent = "load_session" }),
  -- },
  -- {
  --     key = 'R',
  --     mods = 'LEADER|SHIFT',
  --     action = act({ EmitEvent = "restore_session" }),
  -- },
}

bar.apply_to_config(config)
return config