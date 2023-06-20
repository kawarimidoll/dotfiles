Keymap ic <C-j> <Plug>(skkeleton-enable)

let s:jisyo_dir = expand('~/.local/share/skk')
if !isdirectory(s:jisyo_dir)
  call mkdir(s:jisyo_dir, 'p')
endif

function! s:skkeleton_init() abort
  if !exists('g:skk_dict_dir')
    echoerr 'g:skk_dict_dir is not exists'
    return
  endif
  if !exists('g:skk_wiki_dict_dir')
    echoerr 'g:skk_wiki_dict_dir is not exists'
    return
  endif

  let l:rom_table = {
        \   'la':  ['ぁ'],
        \   'le':  ['ぇ'],
        \   'li':  ['ぃ'],
        \   'lka': ['か'],
        \   'lke': ['け'],
        \   'lo':  ['ぉ'],
        \   'ltu': ['っ'],
        \   'lu':  ['ぅ'],
        \   'lwa': ['ゎ'],
        \   'lwe': ['ゑ'],
        \   'lwi': ['ゐ'],
        \   'll': 'disable',
        \   'lya': ['ゃ'],
        \   'lyo': ['ょ'],
        \   'lyu': ['ゅ'],
        \   'z9': ['（'],
        \   'z0': ['）'],
        \   "z\<Space>": ["\u3000"],
        \ }
  for char in split('abcdefghijklmnopqrstuvwxyz,._-!?', '.\zs')
    let l:rom_table['c' .. char] = [char, '']
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
    \     g:skk_dict_dir .. 'SKK-JISYO.jinmei',
    \     g:skk_wiki_dict_dir .. 'SKK-JISYO.jawiki'
    \  ],
    \  'immediatelyCancel': v:false,
    \  'registerConvertResult': v:true,
    \  'selectCandidateKeys': '1234567',
    \  'showCandidatesCount': 1,
    \  'userJisyo': expand(s:jisyo_dir . '/SKK-USER'),
    \  'completionRankFile': expand(s:jisyo_dir . '/rank.json'),
    \ })
  call skkeleton#register_kanatable('rom', l:rom_table)
  call skkeleton#register_keymap('input', "x", 'disable')
endfunction

augroup skkeleton
  autocmd!
  autocmd User skkeleton-initialize-pre call <SID>skkeleton_init()

  " keepState: v:false does not works in cmdline mode
  autocmd CmdlineLeave * if skkeleton#is_enabled()
    \ | call skkeleton#request('disable', [])
    \ | endif
augroup END
