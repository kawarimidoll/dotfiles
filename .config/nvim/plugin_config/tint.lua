require("tint").setup({
  -- tint = -45,  -- Darken colors, use a positive value to brighten
  -- saturation = 0.6,  -- Saturation to preserve
  -- transforms = require("tint").transforms.SATURATE_TINT,  -- Showing default behavior, but value here can be predefined set of transforms
  -- tint_background_colors = true,  -- Tint background portions of highlight groups
  highlight_ignore_patterns = { "WinSeparator", "Status.*" },
  window_ignore_function = function(winid)
    local buf_id = vim.api.nvim_win_get_buf(winid)
    local buftype = vim.api.nvim_buf_get_option(buf_id, "buftype")
    local floating = vim.api.nvim_win_get_config(winid).relative ~= ""

    return buftype == "terminal" or floating
  end
})
