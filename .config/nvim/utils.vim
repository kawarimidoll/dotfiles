function! utils#select(items, opts, on_choice) abort
  let prompt = get(a:opts, 'prompt', 'Select one of:')
  let s:format_item = get(a:opts, 'format_item', {item->item})
  let items = map(a:items[:], {idx,item-> (idx + 1) .. ': ' .. s:format_item(item)})

  let choice = inputlist(insert(items, prompt))

  call a:on_choice(choice > 0 ? a:items[choice-1] : v:null, choice)
endfunction

function! utils#echo(msg) abort
  echo a:msg
endfunction
function! utils#let(var_name, value, ...) abort
  let value = a:value
  let raw_value = get(a:000, 0, 0)
  if !raw_value
    let value = '"' .. a:value .. '"'
  endif
  execute 'let ' ..a:var_name .. '=' .. value
endfunction

" example
" call utils#select(['Fire', 'Air', 'Water', 'Earth'], {}, {item,_->item != v:null ? utils#echo(item) : ''})
" call utils#select(['Fire', 'Air', 'Water', 'Earth'], {}, {item,num->num > 0 ? utils#let('b:selected', item) : ''})
" if exists('b:selected')
"   echo b:selected
"   unlet b:selected
" endif

" with options
" call utils#select(['Fire', 'Air', 'Water', 'Earth'], {
"   \   'prompt': 'Select Element:',
"   \   'format_item': {item->'The ' .. item}
"   \ }, {item,_->item != v:null ? utils#echo(item) : ''})
