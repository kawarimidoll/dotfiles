vim.b.minisurround_config = vim.tbl_deep_extend('force', vim.b.minisurround_config or {}, {
  custom_surroundings = {
    s = {
      input = { '%[%[().-()%]%]' },
      output = { left = '[[', right = ']]' },
    },
  },
})

vim.b.miniai_config = vim.tbl_deep_extend('force', vim.b.miniai_config or {}, {
  custom_textobjects = {
    s = { '%[%[().-()%]%]' },
  },
})
