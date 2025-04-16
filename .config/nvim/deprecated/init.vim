try
  source ~/dotfiles/.config/nvim/minideps.lua
catch
  echomsg v:exception
  echomsg 'nvim setting file is not found!'
endtry
