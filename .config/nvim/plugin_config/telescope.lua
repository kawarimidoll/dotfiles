-- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#dont-preview-binaries
local previewers = require("telescope.previewers")
local Job = require("plenary.job")
local preview_except_binaries = function(filepath, bufnr, opts)
  filepath = vim.fn.expand(filepath, _, _)
  Job:new({
    command = "file",
    args = { "--mime-type", "-b", filepath },
    on_exit = function(j)
      local mime_type = vim.split(j:result()[1], "/")[1]
      local file_type = vim.split(j:result()[1], "/")[2]
      if mime_type == "text" or file_type == "json" then
        previewers.buffer_previewer_maker(filepath, bufnr, opts)
      else
        -- maybe we want to write something to the buffer here
        vim.schedule(function()
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
        end)
      end
    end
  }):sync()
end

-- https://github.com/nvim-telescope/telescope.nvim/issues/1048#issuecomment-993956937
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local telescope_custom_actions = {}
function telescope_custom_actions._multiopen(prompt_bufnr, open_cmd)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local num_selections = #picker:get_multi_selection()
  if not num_selections or num_selections <= 1 then
    actions.add_selection(prompt_bufnr)
  end
  actions.send_selected_to_qflist(prompt_bufnr)
  vim.cmd("cfdo " .. open_cmd)
end
function telescope_custom_actions.multi_selection_open_vsplit(prompt_bufnr)
  telescope_custom_actions._multiopen(prompt_bufnr, "vsplit")
end
function telescope_custom_actions.multi_selection_open_split(prompt_bufnr)
  telescope_custom_actions._multiopen(prompt_bufnr, "split")
end
function telescope_custom_actions.multi_selection_open_tab(prompt_bufnr)
  telescope_custom_actions._multiopen(prompt_bufnr, "tabe")
end
function telescope_custom_actions.multi_selection_open(prompt_bufnr)
  telescope_custom_actions._multiopen(prompt_bufnr, "edit")
end

local map_multiopen = {
  ["<CR>"] = telescope_custom_actions.multi_selection_open,
  ["<C-v>"] = telescope_custom_actions.multi_selection_open_vsplit,
  ["<C-s>"] = telescope_custom_actions.multi_selection_open_split,
  ["<C-t>"] = telescope_custom_actions.multi_selection_open_tab,
}

local action_layout = require("telescope.actions.layout")
require("telescope").setup({
  defaults = {
    generic_sorter = require('mini.fuzzy').get_telescope_sorter,
    buffer_previewer_maker = preview_except_binaries,
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<esc>"] = actions.close,
        ["<C-x>"] = action_layout.toggle_preview,
        ["<C-/>"] = actions.which_key,
      },
    },

    layout_strategy = 'vertical',
    layout_config = { height = 0.95 },
  },
  pickers = {
    find_files = {
      find_command = { 'find_for_vim' },
      mappings = { i = map_multiopen, },
    },
    oldfiles = {
      mappings = { i = map_multiopen, },
    },
    live_grep = {
      mappings = { i = map_multiopen, },
    },
  }
})
