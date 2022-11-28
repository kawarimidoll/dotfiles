local wezterm = require 'wezterm'
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
    act.SpawnCommandInNewTab {
      args = {
        -- '/opt/homebrew/bin/vim',
        'vim',
        '--noplugin',
        '-M',
        '+',
        name
      },
    },
    pane
  )

  wezterm.sleep_ms(1000)
  os.remove(name)
end)

return {
  check_for_updates = false,

  font = wezterm.font 'UDEV Gothic 35JPDOC',
  font_size = 18.0,
  color_scheme = 'Catppuccin Mocha',
  hide_tab_bar_if_only_one_tab = true,

  window_frame = {
    font = wezterm.font 'UDEV Gothic 35JPDOC',
    -- The size of the font in the tab bar.
    font_size = 16.0,
  },

  keys = {
    { key = 'E', mods = 'CTRL', action = act.EmitEvent 'trigger-vim-with-visible-text' },
    { key = 'Q', mods = 'CTRL', action = act.QuickSelect },
  },

  key_tables = {
    -- https://wezfurlong.org/wezterm/copymode.html#configurable-key-assignments
    -- wezterm show-keys --lua --key-table copy_mode
    -- There isn't a way to override portions of the key table, only to replace the entire table.
    copy_mode = {
      { key = 'Tab', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
      { key = 'Tab', mods = 'SHIFT', action = act.CopyMode 'MoveBackwardWord' },
      { key = 'Enter', mods = 'NONE', action = act.CopyMode 'MoveToStartOfNextLine' },
      { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
      { key = 'Space', mods = 'NONE', action = act.CopyMode { SetSelectionMode = 'Cell' } },
      { key = 'L', mods = 'NONE', action = act.CopyMode 'MoveToEndOfLineContent' },
      { key = 'L', mods = 'SHIFT', action = act.CopyMode 'MoveToEndOfLineContent' },
      { key = '0', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
      { key = 'G', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackBottom' },
      { key = 'G', mods = 'SHIFT', action = act.CopyMode 'MoveToScrollbackBottom' },
      -- { key = 'H', mods = 'NONE', action = act.CopyMode 'MoveToViewportTop' },
      -- { key = 'H', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportTop' },
      -- { key = 'L', mods = 'NONE', action = act.CopyMode 'MoveToViewportBottom' },
      -- { key = 'L', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportBottom' },
      { key = 'M', mods = 'NONE', action = act.CopyMode 'MoveToViewportMiddle' },
      { key = 'M', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportMiddle' },
      { key = 'O', mods = 'NONE', action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },
      { key = 'O', mods = 'SHIFT', action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },
      { key = 'V', mods = 'NONE', action = act.CopyMode { SetSelectionMode = 'Line' } },
      { key = 'V', mods = 'SHIFT', action = act.CopyMode { SetSelectionMode = 'Line' } },
      { key = 'H', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLineContent' },
      { key = 'H', mods = 'SHIFT', action = act.CopyMode 'MoveToStartOfLineContent' },
      { key = 'b', mods = 'NONE', action = act.CopyMode 'MoveBackwardWord' },
      { key = 'b', mods = 'ALT', action = act.CopyMode 'MoveBackwardWord' },
      { key = 'b', mods = 'CTRL', action = act.CopyMode 'PageUp' },
      { key = 'c', mods = 'CTRL', action = act.CopyMode 'Close' },
      { key = 'f', mods = 'ALT', action = act.CopyMode 'MoveForwardWord' },
      { key = 'f', mods = 'CTRL', action = act.CopyMode 'PageDown' },
      { key = 'g', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackTop' },
      { key = 'g', mods = 'CTRL', action = act.CopyMode 'Close' },
      { key = 'h', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
      { key = 'j', mods = 'NONE', action = act.CopyMode 'MoveDown' },
      { key = 'k', mods = 'NONE', action = act.CopyMode 'MoveUp' },
      { key = 'l', mods = 'NONE', action = act.CopyMode 'MoveRight' },
      { key = 'm', mods = 'ALT', action = act.CopyMode 'MoveToStartOfLineContent' },
      { key = 'o', mods = 'NONE', action = act.CopyMode 'MoveToSelectionOtherEnd' },
      { key = 'q', mods = 'NONE', action = act.CopyMode 'Close' },
      { key = 'v', mods = 'NONE', action = act.CopyMode { SetSelectionMode = 'Cell' } },
      { key = 'v', mods = 'CTRL', action = act.CopyMode { SetSelectionMode = 'Block' } },
      { key = 'w', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
      { key = 'y', mods = 'NONE',
        action = act.Multiple { { CopyTo = 'ClipboardAndPrimarySelection' }, { CopyMode = 'Close' } } },
      { key = 'PageUp', mods = 'NONE', action = act.CopyMode 'PageUp' },
      { key = 'PageDown', mods = 'NONE', action = act.CopyMode 'PageDown' },
      { key = 'LeftArrow', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
      { key = 'LeftArrow', mods = 'ALT', action = act.CopyMode 'MoveBackwardWord' },
      { key = 'RightArrow', mods = 'NONE', action = act.CopyMode 'MoveRight' },
      { key = 'RightArrow', mods = 'ALT', action = act.CopyMode 'MoveForwardWord' },
      { key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'MoveUp' },
      { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'MoveDown' },
    },
  },
}
