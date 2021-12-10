if filereadable(expand('~/dotfiles/.config/nvim/min-edit.vim'))
  source ~/dotfiles/.config/nvim/min-edit.vim
endif

call plug#begin(stdpath('config') . '/plugged')
Plug 'vim-denops/denops.vim'
Plug 'vim-skk/denops-skkeleton.vim'
Plug 'Shougo/ddc.vim'
Plug 'delphinus/skkeleton_indicator.nvim'
call plug#end()

lua require('skkeleton_indicator').setup({ alwaysShown = false, fadeOutMs = 30000 })

" <TAB>/<S-TAB> completion.
inoremap <silent><expr> <TAB>
  \ pumvisible() ? '<C-n>' :
  \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
  \ '<TAB>' : ddc#map#manual_complete()
inoremap <expr><S-TAB>  pumvisible() ? '<C-p>' : '<C-h>'

imap <C-j> <Plug>(skkeleton-enable)
cmap <C-j> <Plug>(skkeleton-enable)

let s:jisyoPath = '~/.cache/nvim/SKK-JISYO.L'
if !filereadable(expand(s:jisyoPath))
  echo "SSK Jisyo does not exists! '" .
        \ s:jisyoPath . "' is required!"
  let s:jisyoDir = fnamemodify(s:jisyoPath, ':h')
  let s:cmds = [
    \ "curl -OL http://openlab.jp/skk/dic/SKK-JISYO.L.gz",
    \ "gunzip SKK-JISYO.L.gz",
    \ "mkdir -p " . s:jisyoDir,
    \ "mv ./SKK-JISYO.L " . s:jisyoDir,
    \ ]
  echo "To get Jisyo, run:"
  for cmd in s:cmds
    echo cmd
  endfor

  let s:choice = confirm("Run automatically?", "y\nN")
  if s:choice == 1
    echo "Running..."
    for cmd in s:cmds
      call system(cmd)
    endfor
    echo "Done."
  endif
endif

call ddc#custom#patch_global('sources', ['skkeleton'])
call ddc#custom#patch_global('sourceOptions', #{
  \   skkeleton: #{
  \     mark: 'skkeleton',
  \     matchers: ['skkeleton'],
  \     minAutoCompleteLength: 1,
  \   },
  \ })
call skkeleton#config(#{
  \   eggLikeNewline: v:true,
  \   acceptIllegalResult: v:true,
  \   globalJisyo: expand(s:jisyoPath),
  \   showCandidatesCount: 1,
  \   immediatelyCancel: v:false,
  \   keepState: v:true,
  \ })

call ddc#enable()
