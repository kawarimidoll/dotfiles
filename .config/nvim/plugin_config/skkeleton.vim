Keymap ic <C-j> <Plug>(skkeleton-enable)

let s:jisyo_dir = stdpath('config')
let s:jisyo_name = 'SKK-JISYO.L'
let s:jisyo_path = expand(s:jisyo_dir . '/' . s:jisyo_name)
function! s:skkeleton_init() abort
  if !filereadable(s:jisyo_path)
    echo "SSK Jisyo does not exists! '" . s:jisyo_path . "' is required!"
    let s:skk_setup_cmds = [
      \   "curl -OL https://skk-dev.github.io/dict/SKK-JISYO.L.gz",
      \   "gunzip SKK-JISYO.L.gz",
      \   "mkdir -p " . s:jisyo_dir,
      \   "mv -f ./SKK-JISYO.L " . s:jisyo_dir,
      \ ]
    echo (["To get Jisyo, run:"] + s:skk_setup_cmds + [""])->join("\n")

    if confirm("Run automatically?", "y\nN") == 1
      echo "Running..."
      call system(s:skk_setup_cmds->join(" && "))
      echo "Done."
    endif
  endif

  let l:rom_table = {
    \   'z9': ['（', ''],
    \   'z0': ['）', ''],
    \   "z\<Space>": ["\u3000", ''],
    \ }
  for char in split('abcdefghijklmnopqrstuvwxyz,._-!?', '.\zs')
    let l:rom_table['c'.char] = [char, '']
  endfor

  call skkeleton#config(#{
    \   eggLikeNewline: v:true,
    \   globalJisyo: s:jisyo_path,
    \   immediatelyCancel: v:false,
    \   registerConvertResult: v:true,
    \   selectCandidateKeys: '1234567',
    \   showCandidatesCount: 1,
    \ })
  call skkeleton#register_kanatable('rom', l:rom_table)
endfunction

augroup skkeleton
  autocmd!
  autocmd User skkeleton-initialize-pre call <SID>skkeleton_init()
augroup END
