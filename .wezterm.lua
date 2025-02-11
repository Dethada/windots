local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.launch_menu = {
    {
        args = { 'top '},
    },
}

-- Performance
config.max_fps = 144
-- How many lines of scrollback to retain per tab
config.scrollback_lines = 5000

-- Appearance
config.color_scheme = 'Catppuccin Macchiato'
config.font = wezterm.font('Hack Nerd Font', { weight = 'Medium' })
config.font_size = 12
config.default_domain = 'WSL:Arch'
config.window_decorations = 'RESIZE'

-- Inactive panes
config.inactive_pane_hsb = {
    saturation = 0.7,
    brightness = 0.5,
}

-- tab bar
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = true

-- tmux status
wezterm.on('update-status', function(window, _)
    local SOLID_LEFT_ARROW = ''
    local ARROW_FOREGROUND = { Foreground = { Color = '#c6a0f6' } }
    local prefix = ''

    if window:leader_is_active() then
        prefix = ' ' .. utf8.char(0x1f30a) -- ocean wave
        SOLID_LEFT_ARROW = utf8.char(0xe0b2)
    end

    if window:active_tab():tab_id() ~= 0 then
        ARROW_FOREGROUND = { Foreground = { Color = '#1e2030' } }
    end -- arrow color based on if tab is first pane

    window:set_left_status(wezterm.format {
        { Background = { Color = '#b7bdf8' } },
        { Text = prefix },
        ARROW_FOREGROUND,
        { Text = SOLID_LEFT_ARROW },
    })
end)

wezterm.on('update-right-status', function(window, _)
    local workspace_name = window:active_workspace()
    window:set_right_status(wezterm.format {
        { Attribute = { Intensity = 'Bold' } },
        { Text = workspace_name },
    })
end)

wezterm.on('format-tab-title', function(tab)
  local pane = tab.active_pane
  local cwd = pane:get_current_working_dir()

  -- Extract the last element of the directory path
  local last_element = cwd:match('([^/]+)/?$')

  -- Set the tab title to the last element
  return last_element or 'Unknown'
end)

-- keybinds
config.disable_default_key_bindings = true
config.use_dead_keys = false
config.debug_key_events = true

local act = wezterm.action

-- tmux
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 5000 }
config.keys = {
    {
        key = 'c',
        mods = 'LEADER',
        action = act.SpawnTab 'CurrentPaneDomain',
    },
    {
        key = 'x',
        mods = 'LEADER',
        action = act.CloseCurrentPane { confirm = true }
    },
    {
        key = ',',
        mods = 'LEADER',
        action = act.PromptInputLine {
            description = wezterm.format {
                { Attribute = { Intensity = 'Bold' } },
                { Foreground = { AnsiColor = 'Blue' } },
                { Text =  'Enter new name for tab' },
            },
            action = wezterm.action_callback(function(window, pane, line)
                -- line will be `nil` if they hit escape without entering anything
                -- An empty string if they just hit enter
                -- Or the actual line of text they wrote
                if line then
                    window:active_tab():set_title(line)
                end
            end),
        },
    },
    {
        key = '[',
        mods = 'LEADER',
        action = act.ActivateCopyMode,
    },
    {
        key = '|',
        mods = 'LEADER|SHIFT',
        action = act.SplitHorizontal { domain = 'CurrentPaneDomain' }
    },
    {
        key = '-',
        mods = 'LEADER',
        action = act.SplitVertical { domain = 'CurrentPaneDomain' }
    },
    {
        key = 'h',
        mods = 'LEADER',
        action = act.ActivatePaneDirection 'Left'
    },
    {
        key = 'j',
        mods = 'LEADER',
        action = act.ActivatePaneDirection 'Down'
    },
    {
        key = 'k',
        mods = 'LEADER',
        action = act.ActivatePaneDirection 'Up'
    },
    {
        key = 'l',
        mods = 'LEADER',
        action = act.ActivatePaneDirection 'Right'
    },
    {
        key = 'LeftArrow',
        mods = 'LEADER',
        action = act.AdjustPaneSize { 'Left', 5 }
    },
    {
        key = 'RightArrow',
        mods = 'LEADER',
        action = act.AdjustPaneSize { 'Right', 5 }
    },
    {
        key = 'DownArrow',
        mods = 'LEADER',
        action = act.AdjustPaneSize { 'Down', 5 }
    },
    {
        key = 'UpArrow',
        mods = 'LEADER',
        action = act.AdjustPaneSize { 'Up', 5 }
    },
    -- others
    {
        key = 'o',
        mods = 'LEADER',
        action = act.ShowLauncher,
    },
    {
        key = 'v',
        mods = 'CTRL|SHIFT',
        action = act.PasteFrom 'Clipboard'
    },
    {
        key = 'c',
        mods = 'CTRL|SHIFT',
        action = act.CopyTo 'Clipboard'
    },
    {
        key = 'f',
        mods = 'LEADER',
        action = act.Search 'CurrentSelectionOrEmptyString'
    },
    { key = 'L', mods = 'SHIFT|CTRL', action = act.ShowDebugOverlay },
    -- Ctr + + and Ctrl + - to increase and decrease font size
    { key = '+', mods = 'SHIFT|CTRL', action = act.IncreaseFontSize },
    { key = '-', mods = 'CTRL',       action = act.DecreaseFontSize },
    -- prompt for workspace name then create and switch to it
    {
        key = 'w',
        mods = 'LEADER',
        action = act.PromptInputLine {
            description = wezterm.format {
                { Attribute = { Intensity = 'Bold' } },
                { Foreground = { AnsiColor = 'Fuchsia' } },
                { Text = 'Enter name for new workspace' },
            },
            action = wezterm.action_callback(function(window, pane, line)
                -- line will be `nil` if they hit escape without entering anything
                -- An empty string if they just hit enter
                -- Or the actual line of text they wrote
                if line then
                    window:perform_action(
                        act.SwitchToWorkspace {
                            name = line,
                        },
                        pane
                    )
                end
            end),
        },
    }
}

for i = 0, 9 do
    -- leader + number to activate that tab
    table.insert(config.keys, {
        key = tostring(i),
        mods = 'LEADER',
        action = act.ActivateTab(i),
    })
end

return config
