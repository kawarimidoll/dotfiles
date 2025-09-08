-- https://zenn.dev/mozumasu/articles/mozumasu-wezterm-customization
local wezterm = require('wezterm')
local act = wezterm.action
local io = require('io')
local os = require('os')

-- https://wezfurlong.org/wezterm/config/lua/wezterm/on.html#custom-events
wezterm.on('trigger-vim-with-visible-text', function(window, pane)
  local viewport_text = pane:get_lines_as_text(2000)

  local name = os.tmpname()
  local f = io.open(name, 'w+')
  if not f then
    return
  end

  f:write(viewport_text)
  f:flush()
  f:close()

  window:perform_action(
    act.SpawnCommandInNewTab({
      args = {
        '/Users/kawarimidoll/.nix-profile/bin/vim',
        '--noplugin',
        '-M',
        '+',
        name,
      },
    }),
    pane
  )

  wezterm.sleep_ms(1000)
  os.remove(name)
end)

wezterm.on('format-tab-title', function(tab, _tabs, _panes, _config, _hover, max_width)
  local background = '#5c6d74'
  local foreground = '#FFFFFF'
  local edge_background = 'none'
  if tab.is_active then
    background = '#8fecd9'
    foreground = '#5c6d74'
  end
  local edge_foreground = background

  local function icon_from_process_name(pname)
    local icon_table = {
      vim = wezterm.nerdfonts.custom_vim,
      nvim = wezterm.nerdfonts.linux_neovim,
      docker = wezterm.nerdfonts.md_docker,
    }
    local icon = icon_table[pname:gsub('.+/', '')]
    return icon and icon .. ' ' or ''
  end
  local icon = icon_from_process_name(tab.active_pane.foreground_process_name)
  -- local title = tab.active_pane.title
  --     :gsub('^~/ghq/github.com/[^/]+/', '★')
  --     :gsub('^~/dotfiles', '☆dotfiles')
  local title = tab.active_pane.title
      :gsub('~/ghq/github.com/[^/]+/', wezterm.nerdfonts.md_github .. ' ')
      :gsub('~/.config/', wezterm.nerdfonts.md_folder_cog .. ' ')
      :gsub('~/dotfiles/?', wezterm.nerdfonts.md_folder_cog .. ' ')

  local result = {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = wezterm.nerdfonts.ple_lower_right_triangle },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = ' ' },
    { Text = icon },
    { Text = wezterm.truncate_right(title, max_width - 1) },
    { Text = ' ' },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = wezterm.nerdfonts.ple_upper_left_triangle },
  }

  if tab.is_active then
    table.insert(result, 2, { Text = wezterm.nerdfonts.ple_upper_left_triangle })
    table.insert(result, 2, { Text = wezterm.nerdfonts.ple_lower_right_triangle })
    table.insert(result, 2, { Foreground = { Color = '#e68be7' } })
  end

  return result
end)

wezterm.on('window-config-reloaded', function(window, _pane)
  -- light scheme 'Papercolor Light (Gogh)', 'tokyonight-day'
  local overrides = window:get_config_overrides() or {}
  local scheme_light = 'tokyonight-day'
  local scheme_dark = 'Catppuccin Mocha'
  local scheme = window:get_appearance():find('Dark') and scheme_dark or scheme_light
  if overrides.color_scheme ~= scheme then
    overrides.color_scheme = scheme
    window:set_config_overrides(overrides)
  end
end)

return {
  check_for_updates = false,
  front_end = 'WebGpu',

  -- window_background_opacity = 0.85,
  -- macos_window_background_blur = 20,

  font = wezterm.font_with_fallback({
    'UDEV Gothic 35NF',
    'Symbols Nerd Font Mono',
  }),
  font_size = 18.0,
  -- color_schemeはon:window-config-reloadedで変更する

  window_decorations = 'INTEGRATED_BUTTONS|RESIZE',
  -- hide_tab_bar_if_only_one_tab = true,
  show_new_tab_button_in_tab_bar = false,
  show_close_tab_button_in_tabs = false,

  window_frame = {
    inactive_titlebar_bg = 'none',
    active_titlebar_bg = 'none',
    font = wezterm.font('UDEV Gothic 35NF'),
    -- The size of the font in the tab bar.
    font_size = 16.0,
  },
  window_background_gradient = {
    orientation = 'Vertical',
    colors = {
      '#e1e2e7',
      '#e0ebee',
      -- '#e0e0fb',
    },
  },
  -- window_background_gradient = {
  --   colors = { '#000000' },
  -- },
  -- background = {
  --   {
  --     source = {
  --       -- must be absolute path
  --       File = '/Users/kawarimidoll/dotfiles/wallpapers/pixel_night.png',
  --     },
  --     opacity = 0.05,
  --   },
  -- },

  colors = {
    tab_bar = {
      inactive_tab_edge = 'none',
    },
  },

  -- https://zenn.dev/yuys13/articles/wezterm-settings-trivia
  use_ime = true,
  macos_forward_to_ime_modifier_mask = 'SHIFT|CTRL',

  keys = {
    { key = 'S', mods = 'CTRL', action = act.ActivateCopyMode },
    { key = 'E', mods = 'CTRL', action = act.EmitEvent('trigger-vim-with-visible-text') },
    { key = 'Q', mods = 'CTRL', action = act.QuickSelect },

    -- https://zenn.dev/yuys13/articles/wezterm-settings-trivia
    -- https://github.com/wez/wezterm/issues/2630#issuecomment-1323626076
    { key = 'q', mods = 'CTRL', action = wezterm.action({ SendString = '\x11' }) },
  },

  key_tables = {
    -- https://wezfurlong.org/wezterm/copymode.html#configurable-key-assignments
    -- wezterm show-keys --lua --key-table copy_mode
    -- There isn't a way to override portions of the key table, only to replace the entire table.
    copy_mode = {
      { key = 'Tab',        mods = 'NONE',  action = act.CopyMode('MoveForwardWord') },
      { key = 'Tab',        mods = 'SHIFT', action = act.CopyMode('MoveBackwardWord') },
      { key = 'Enter',      mods = 'NONE',  action = act.CopyMode('MoveToStartOfNextLine') },
      { key = 'Escape',     mods = 'NONE',  action = act.CopyMode('Close') },
      { key = 'Space',      mods = 'NONE',  action = act.CopyMode({ SetSelectionMode = 'Cell' }) },
      { key = 'L',          mods = 'NONE',  action = act.CopyMode('MoveToEndOfLineContent') },
      { key = 'L',          mods = 'SHIFT', action = act.CopyMode('MoveToEndOfLineContent') },
      { key = '0',          mods = 'NONE',  action = act.CopyMode('MoveToStartOfLine') },
      { key = 'G',          mods = 'NONE',  action = act.CopyMode('MoveToScrollbackBottom') },
      { key = 'G',          mods = 'SHIFT', action = act.CopyMode('MoveToScrollbackBottom') },
      -- { key = 'H', mods = 'NONE', action = act.CopyMode 'MoveToViewportTop' },
      -- { key = 'H', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportTop' },
      -- { key = 'L', mods = 'NONE', action = act.CopyMode 'MoveToViewportBottom' },
      -- { key = 'L', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportBottom' },
      { key = 'M',          mods = 'NONE',  action = act.CopyMode('MoveToViewportMiddle') },
      { key = 'M',          mods = 'SHIFT', action = act.CopyMode('MoveToViewportMiddle') },
      { key = 'O',          mods = 'NONE',  action = act.CopyMode('MoveToSelectionOtherEndHoriz') },
      { key = 'O',          mods = 'SHIFT', action = act.CopyMode('MoveToSelectionOtherEndHoriz') },
      { key = 'V',          mods = 'NONE',  action = act.CopyMode({ SetSelectionMode = 'Line' }) },
      { key = 'V',          mods = 'SHIFT', action = act.CopyMode({ SetSelectionMode = 'Line' }) },
      { key = 'H',          mods = 'NONE',  action = act.CopyMode('MoveToStartOfLineContent') },
      { key = 'H',          mods = 'SHIFT', action = act.CopyMode('MoveToStartOfLineContent') },
      { key = 'b',          mods = 'NONE',  action = act.CopyMode('MoveBackwardWord') },
      { key = 'b',          mods = 'ALT',   action = act.CopyMode('MoveBackwardWord') },
      { key = 'b',          mods = 'CTRL',  action = act.CopyMode('PageUp') },
      { key = 'c',          mods = 'CTRL',  action = act.CopyMode('Close') },
      { key = 'f',          mods = 'ALT',   action = act.CopyMode('MoveForwardWord') },
      { key = 'f',          mods = 'CTRL',  action = act.CopyMode('PageDown') },
      { key = 'g',          mods = 'NONE',  action = act.CopyMode('MoveToScrollbackTop') },
      { key = 'g',          mods = 'CTRL',  action = act.CopyMode('Close') },
      { key = 'h',          mods = 'NONE',  action = act.CopyMode('MoveLeft') },
      { key = 'j',          mods = 'NONE',  action = act.CopyMode('MoveDown') },
      { key = 'k',          mods = 'NONE',  action = act.CopyMode('MoveUp') },
      { key = 'l',          mods = 'NONE',  action = act.CopyMode('MoveRight') },
      { key = 'm',          mods = 'ALT',   action = act.CopyMode('MoveToStartOfLineContent') },
      { key = 'o',          mods = 'NONE',  action = act.CopyMode('MoveToSelectionOtherEnd') },
      { key = 'q',          mods = 'NONE',  action = act.CopyMode('Close') },
      { key = 'v',          mods = 'NONE',  action = act.CopyMode({ SetSelectionMode = 'Cell' }) },
      { key = 'v',          mods = 'CTRL',  action = act.CopyMode({ SetSelectionMode = 'Block' }) },
      { key = 'w',          mods = 'NONE',  action = act.CopyMode('MoveForwardWord') },
      { key = 'y',          mods = 'NONE',  action = act.Multiple({ { CopyTo = 'ClipboardAndPrimarySelection' }, { CopyMode = 'Close' }, }), },
      { key = 'PageUp',     mods = 'NONE',  action = act.CopyMode('PageUp') },
      { key = 'PageDown',   mods = 'NONE',  action = act.CopyMode('PageDown') },
      { key = 'LeftArrow',  mods = 'NONE',  action = act.CopyMode('MoveLeft') },
      { key = 'LeftArrow',  mods = 'ALT',   action = act.CopyMode('MoveBackwardWord') },
      { key = 'RightArrow', mods = 'NONE',  action = act.CopyMode('MoveRight') },
      { key = 'RightArrow', mods = 'ALT',   action = act.CopyMode('MoveForwardWord') },
      { key = 'UpArrow',    mods = 'NONE',  action = act.CopyMode('MoveUp') },
      { key = 'DownArrow',  mods = 'NONE',  action = act.CopyMode('MoveDown') },
    },
  },
}
