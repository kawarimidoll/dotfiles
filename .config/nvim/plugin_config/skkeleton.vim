Keymap ic <C-j> <Plug>(skkeleton-enable)

let s:jisyo_dir = expand('~/.local/share/skk')
if !isdirectory(s:jisyo_dir)
  call mkdir(s:jisyo_dir, 'p')
endif

let s:user_jisyo_path = expand(s:jisyo_dir . '/SKK-USER')

function! s:skkeleton_init() abort
  if !exists('g:skk_dict_dir')
    echoerr 'g:skk_dict_dir is not exists'
    return
  endif

  let l:rom_table = {
    \   'z9': ['（', ''],
    \   'z0': ['）', ''],
    \   "z\<Space>": ["\u3000", ''],
    \ }
  for char in split('abcdefghijklmnopqrstuvwxyz,._-!?', '.\zs')
    let l:rom_table['c'.char] = [char, '']
  endfor

  call skkeleton#config({
    \  'eggLikeNewline': v:true,
    \  'globalDictionaries': [
    \     g:skk_dict_dir .. 'SKK-JISYO.L',
    \     g:skk_dict_dir .. 'SKK-JISYO.emoji',
    \     g:skk_dict_dir .. 'SKK-JISYO.law',
    \     g:skk_dict_dir .. 'SKK-JISYO.propernoun',
    \     g:skk_dict_dir .. 'SKK-JISYO.geo',
    \     g:skk_dict_dir .. 'SKK-JISYO.station',
    \     g:skk_dict_dir .. 'SKK-JISYO.jinmei'
    \  ],
    \  'immediatelyCancel': v:false,
    \  'registerConvertResult': v:true,
    \  'selectCandidateKeys': '1234567',
    \  'showCandidatesCount': 1,
    \  'userJisyo': s:user_jisyo_path ,
    \ })
  call skkeleton#register_kanatable('rom', l:rom_table)
endfunction

augroup skkeleton
  autocmd!
  autocmd User skkeleton-initialize-pre call <SID>skkeleton_init()

  " keepState: v:false does not works in cmdline mode
  autocmd CmdlineLeave * if skkeleton#is_enabled()
    \ | call skkeleton#request('disable', [])
    \ | endif
augroup END
