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

" example
" call utils#select(['Fire', 'Air', 'Water', 'Earth'], {}, {item,_->item != v:null ? utils#echo(item) : ''})

" with options
" call utils#select(['Fire', 'Air', 'Water', 'Earth'], {
"   \   'prompt': 'Select Element:',
"   \   'format_item': {item->'The ' .. item}
"   \ }, {item,_->item != v:null ? utils#echo(item) : ''})
