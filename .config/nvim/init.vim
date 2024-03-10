let s:source = expand('~/dotfiles/.config/nvim/minideps.lua')
if filereadable(s:source)
  execute 'source' s:source
endif
