require("scrollbar").setup({
  handle = {
    color = "#292e42",
  },
  marks = {
    Search = { highlight = "MoreMsg", },
  },
})

local hlslens_exists, hlslens_config = pcall(require, 'hlslens.config')
if hlslens_exists then
  require("scrollbar.handlers.search").setup(hlslens_config)
end
