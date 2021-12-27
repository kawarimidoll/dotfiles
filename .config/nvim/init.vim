let s:source = expand('~/dotfiles/.config/nvim/lsp-cmp.vim')
if filereadable(s:source)
  execute 'source' s:source
endif
