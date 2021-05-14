# Vim Cheatsheet
-   `:Cheat`: Show this file

## Default

## Plugins
### vim-abolish
#### Substitution
-   `:S/query` to search
-   `:S/quer{y,ies}` to smart search
-   `:S/from/to/[flags]` to replace
-   `:S/{red,blue}/{blue,red}/` to swap

#### Coercion
-   `crs` to `snake_case`
-   `cr_` to `snake_case`
-   `crm` to `MixedCase`
-   `crc` to `camelCase`
-   `cru` to `UPPER_CASE`
-   `cr-` to `dash-case`
-   `crk` to `kebab-kase`
-   `cr.` to `dot.case`
-   `cr ` to `space case`
-   `crt` to `Title Case`

### coc.nvim

```
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
`nmap <silent> [g <Plug>(coc-diagnostic-prev)`
`nmap <silent> ]g <Plug>(coc-diagnostic-next)`

" GoTo code navigation.
`nmap <silent> gd <Plug>(coc-definition)`
`nmap <silent> gy <Plug>(coc-type-definition)`
`nmap <silent> gi <Plug>(coc-implementation)`
`nmap <silent> gr <Plug>(coc-references)`

" Use K to show documentation in preview window.
`nnoremap <silent> K :call <SID>show_documentation()<CR>`

" Symbol renaming.
`nmap <leader>rn <Plug>(coc-rename)`

" Formatting selected code.
`xmap <leader>f  <Plug>(coc-format-selected)`
`nmap <leader>f  <Plug>(coc-format-selected)`

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Mappings for CocList
nnoremap <silent><nowait> <space>A  :<C-u>CocList diagnostics<CR>
nnoremap <silent><nowait> <space>E  :<C-u>CocList extensions<CR>
nnoremap <silent><nowait> <space>C  :<C-u>CocList commands<CR>
nnoremap <silent><nowait> <space>O  :<C-u>CocList outline<CR>
nnoremap <silent><nowait> <space>S  :<C-u>CocList -I symbols<CR>
nnoremap <silent><nowait> <space>J  :<C-u>CocNext<CR>
nnoremap <silent><nowait> <space>K  :<C-u>CocPrev<CR>
nnoremap <silent><nowait> <space>P  :<C-u>CocListResume<CR>
```

### vim-sandwich
#### Add

```
sa{motion/textobject}{addition}
```

example: `saiw(` makes `foo` to `(foo)`

#### Delete

```
sd{deletion}
sdb
```

example: `sd(` makes `(foo)` to `foo`
example: use `sdb` to auto-search surrounding

#### Replace

```
srb{addition}
sr{deletion}{addition}
```

example: `srb"` or `sr("` makes `(foo)` to `"foo"`

