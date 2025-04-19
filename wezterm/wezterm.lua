local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- Enable automatic config reloading
config.automatically_reload_config = true

-- Set the color scheme to Catppuccin Mocha
config.color_scheme = "Catppuccin Mocha"

-- Font configuration
config.font = wezterm.font("JetBrains Mono", {
    weight = "Bold",
})
config.font_size = 13

-- Window configuration
config.window_background_opacity = 0.97
-- config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"

-- Minimal padding
config.window_padding = {
    left = 5,
    right = 5,
    top = 5,
    bottom = 5,
}

-- Set initial window size and position
config.initial_cols = 110
config.initial_rows = 38

-- Enable Wayland and cursor settings
config.enable_wayland = true
config.force_reverse_video_cursor = true

-- Tab bar configuration
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.tab_max_width = 30
config.use_fancy_tab_bar = true

-- Enable scroll back
config.scrollback_lines = 10000

-- Better copy/paste
config.enable_kitty_keyboard = true
config.enable_csi_u_key_encoding = true

-- Quick select mode for URLs and paths
config.quick_select_patterns = {
    -- URLs
    [[\b\w+://[\w.-]+\.[a-z]{2,15}/?[\w_.~%!*&;:=+@#$,()/\-\[\]?]*]],
    -- Paths
    [[[a-zA-Z0-9_-]+/[a-zA-Z0-9_-]+(/[a-zA-Z0-9_-]+)*]],
    -- IPs
    [[\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b]],
}

-- Cursor configuration
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 750

-- Custom status bar
local function get_current_working_dir(tab)
    local current_dir = tab.active_pane.current_working_dir
    local HOME_DIR = string.format("file://%s", os.getenv("HOME"))
    return current_dir == HOME_DIR and "~"
        or string.gsub(current_dir, "(.*[\\/])(.*)", "%2")
end

local function get_current_git_branch(tab)
    local git_cmd = "git -C " .. tab.active_pane.current_working_dir .. " branch --show-current 2>/dev/null"
    local handle = io.popen(git_cmd)
    if handle then
        local result = handle:read("*a")
        handle:close()
        return result ~= "" and "  " .. result:gsub("^%s*(.-)%s*$", "%1") or ""
    end
    return ""
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local bg = "#1e1e2e"
    local fg = "#cdd6f4"
    local git_branch = get_current_git_branch(tab)
    local title = get_current_working_dir(tab) .. git_branch

    if tab.is_active then
        bg = "#313244"
        fg = "#89b4fa"
    elseif hover then
        bg = "#282838"
        fg = "#89b4fa"
    end

    return {
        { Background = { Color = bg } },
        { Foreground = { Color = fg } },
        { Text = " " .. title .. " " },
    }
end)

-- Key bindings
config.keys = {
    -- Split panes
    {
        key = "\\",
        mods = "CTRL|ALT",
        action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
        key = "|",
        mods = "CTRL|ALT",
        action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
    },
    -- Navigate between panes
    {
        key = "h",
        mods = "CTRL|ALT",
        action = act.ActivatePaneDirection("Left"),
    },
    {
        key = "l",
        mods = "CTRL|ALT",
        action = act.ActivatePaneDirection("Right"),
    },
    {
        key = "k",
        mods = "CTRL|ALT",
        action = act.ActivatePaneDirection("Up"),
    },
    {
        key = "j",
        mods = "CTRL|ALT",
        action = act.ActivatePaneDirection("Down"),
    },
    -- Switch to specific tab
    {
        key = "1",
        mods = "CTRL",
        action = act.ActivateTab(0),
    },
    {
        key = "2",
        mods = "CTRL",
        action = act.ActivateTab(1),
    },
    {
        key = "3",
        mods = "CTRL",
        action = act.ActivateTab(2),
    },
    {
        key = "4",
        mods = "CTRL",
        action = act.ActivateTab(3),
    },
    {
        key = "5",
        mods = "CTRL",
        action = act.ActivateTab(4),
    },
    -- Close current pane
    {
        key = "w",
        mods = "CTRL|ALT",
        action = act.CloseCurrentPane({ confirm = true }),
    },
    -- Quick AI access (opens in browser)
    {
        key = "b",
        mods = "CTRL|SHIFT",
        action = act.SpawnCommandInNewTab({
            args = { "xdg-open", "https://bard.google.com" },
        }),
    },
    {
        key = "g",
        mods = "CTRL|SHIFT",
        action = act.SpawnCommandInNewTab({
            args = { "xdg-open", "https://chat.openai.com" },
        }),
    },
    -- Quick select mode
    {
        key = "Space",
        mods = "SHIFT|CTRL",
        action = act.QuickSelect,
    },
    -- Copy/Paste
    {
        key = "c",
        mods = "CTRL|SHIFT",
        action = act.CopyTo("Clipboard"),
    },
    {
        key = "v",
        mods = "CTRL|SHIFT",
        action = act.PasteFrom("Clipboard"),
    },
    -- Search
    {
        key = "f",
        mods = "CTRL|SHIFT",
        action = act.Search("CurrentSelectionOrEmptyString"),
    },
}

-- Mouse bindings
config.mouse_bindings = {
    -- Right click paste
    {
        event = { Down = { streak = 1, button = "Right" } },
        mods = "NONE",
        action = act.PasteFrom("Clipboard"),
    },
    -- Triple-click selects line
    {
        event = { Down = { streak = 3, button = "Left" } },
        action = act.SelectTextAtMouseCursor("Line"),
    },
}

return config
