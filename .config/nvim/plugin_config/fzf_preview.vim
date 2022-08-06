let g:fzf_preview_filelist_command = 'find_for_vim'
let g:fzf_preview_fzf_preview_window_option = 'down:70%'
let g:fzf_preview_grep_cmd = "rg --line-number --no-heading --color=never --smart-case --max-columns=512 --hidden --trim --glob '!**/.git/*'"
let g:fzf_preview_use_dev_icons = 1
let g:fzf_preview_default_fzf_options = {
      \ '--reverse': v:true,
      \ '--preview-window': 'wrap',
      \ '--cycle': v:true,
      \ '--no-sort': v:true,
      \ }
