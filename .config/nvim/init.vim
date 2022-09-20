let s:source = expand('~/dotfiles/.config/nvim/plugs.vim')
if filereadable(s:source)
  execute 'source' s:source
endif
