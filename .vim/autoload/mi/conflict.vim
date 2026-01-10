vim9script
# respect: https://github.com/rhysd/conflict-marker.vim

const conflict_begin = '^<<<<<<< \@='
const conflict_ancestor = '^||||||| .*$'
const conflict_separator = '^=======$'
const conflict_end = '^>>>>>>> \@='

# コンフリクトマーカーの構造
# <<<<<<< HEAD        <- begin
# ours content
# ||||||| base        <- ancestor （ある場合のみ）
# base content
# =======             <- separator
# theirs content
# >>>>>>> branch      <- end

def SearchConflict(forward: bool): dict<number>
  var save_pos = getpos('.')

  var begin_line: number
  var separator_line: number
  var end_line: number

  if forward
    # 前方検索: まずbeginを探し、その後にseparator、endがあるか確認
    begin_line = search(conflict_begin, 'cW')
    if begin_line == 0
      return {}
    endif
    separator_line = search(conflict_separator, 'W')
    if separator_line == 0
      setpos('.', save_pos)
      return {}
    endif
    end_line = search(conflict_end, 'W')
    if end_line == 0
      setpos('.', save_pos)
      return {}
    endif
  else
    # 後方検索: まずendを探し、その前にseparator、beginがあるか確認
    end_line = search(conflict_end, 'cbW')
    if end_line == 0
      return {}
    endif
    separator_line = search(conflict_separator, 'bW')
    if separator_line == 0
      setpos('.', save_pos)
      return {}
    endif
    begin_line = search(conflict_begin, 'bW')
    if begin_line == 0
      setpos('.', save_pos)
      return {}
    endif
  endif

  setpos('.', save_pos)

  # 位置関係が正しいか検証 (begin < separator < end)
  if begin_line >= separator_line || separator_line >= end_line
    return {}
  endif

  return {begin: begin_line, separator: separator_line, end: end_line}
enddef

def GetCurrentConflict(): dict<number>
  var cur_line = line('.')
  var save_pos = getpos('.')

  # 上方向にbeginを探す
  var begin_line = search(conflict_begin, 'bcnW')
  if begin_line == 0
    return {}
  endif

  # 下方向にendを探す
  var end_line = search(conflict_end, 'cnW')
  if end_line == 0 || end_line < cur_line
    return {}
  endif

  # beginとendの間にいるか確認
  if cur_line < begin_line || cur_line > end_line
    return {}
  endif

  # separatorを探す (begin と end の間)
  cursor(begin_line, 1)
  var separator_line = search(conflict_separator, 'W', end_line)
  if separator_line == 0
    setpos('.', save_pos)
    return {}
  endif

  # ancestorを探す (begin と separator の間)
  cursor(begin_line, 1)
  var ancestor_line = search(conflict_ancestor, 'W', separator_line)

  setpos('.', save_pos)

  var result: dict<number> = {begin: begin_line, separator: separator_line, end: end_line}
  if ancestor_line > 0
    result.ancestor = ancestor_line
  endif

  return result
enddef

export def Jump(forward: bool)
  # 現在コンフリクト内にいる場合は一度抜ける
  var current = GetCurrentConflict()
  if !empty(current)
    if forward
      cursor(current.end + 1, 1)
    else
      cursor(current.begin - 1, 1)
    endif
  endif

  var conflict = SearchConflict(forward)
  if empty(conflict)
    echo 'no more conflict!'
    return
  endif
  cursor(conflict.begin, 1)
enddef

# oursのみ残す
export def UseOurs()
  var c = GetCurrentConflict()
  if empty(c)
    echo 'not in conflict'
    return
  endif
  # 下から削除（行番号がずれないように）
  if has_key(c, 'ancestor')
    execute $':{c.ancestor},{c.end}delete _'
  else
    execute $':{c.separator},{c.end}delete _'
  endif
  execute $':{c.begin}delete _'
enddef

# theirsのみ残す
export def UseTheirs()
  var c = GetCurrentConflict()
  if empty(c)
    echo 'not in conflict'
    return
  endif
  # 下から削除
  execute $':{c.end}delete _'
  execute $':{c.begin},{c.separator}delete _'
enddef

# 両方残す（ours, theirs の順）
export def UseBoth()
  var c = GetCurrentConflict()
  if empty(c)
    echo 'not in conflict'
    return
  endif
  # 下から削除
  execute $':{c.end}delete _'
  if has_key(c, 'ancestor')
    execute $':{c.ancestor},{c.separator}delete _'
  else
    execute $':{c.separator}delete _'
  endif
  execute $':{c.begin}delete _'
enddef

# 両方残す（theirs, ours の順）
export def UseBothReverse()
  var c = GetCurrentConflict()
  if empty(c)
    echo 'not in conflict'
    return
  endif
  var ours: list<string>
  if has_key(c, 'ancestor')
    ours = getline(c.begin + 1, c.ancestor - 1)
  else
    ours = getline(c.begin + 1, c.separator - 1)
  endif
  var theirs = getline(c.separator + 1, c.end - 1)
  execute $':{c.begin},{c.end}delete _'
  append(c.begin - 1, theirs + ours)
enddef

# ancestorのみ残す（ancestorがある場合のみ）
export def UseAncestor()
  var c = GetCurrentConflict()
  if empty(c)
    echo 'not in conflict'
    return
  endif
  if !has_key(c, 'ancestor')
    echo 'no ancestor in this conflict'
    return
  endif
  # 下から削除
  execute $':{c.separator},{c.end}delete _'
  execute $':{c.begin},{c.ancestor}delete _'
enddef

# 全て削除
export def UseNone()
  var c = GetCurrentConflict()
  if empty(c)
    echo 'not in conflict'
    return
  endif
  execute $':{c.begin},{c.end}delete _'
enddef

# 統一インターフェース
const use_targets = ['ours', 'theirs', 'both', 'both_reverse', 'ancestor', 'none']
const use_funcs: dict<func> = {
  ours: UseOurs,
  theirs: UseTheirs,
  both: UseBoth,
  both_reverse: UseBothReverse,
  ancestor: UseAncestor,
  none: UseNone,
}

var last_target: string = ''
var is_repeating: bool = false

export def Use(target: string)
  if index(use_targets, target) < 0
    echo 'invalid target: ' .. target .. ' (valid: ' .. join(use_targets, ', ') .. ')'
    return
  endif
  use_funcs[target]()

  # ドットリピート用
  if !is_repeating
    last_target = target
    &operatorfunc = Repeat
    var save_pos = getcurpos()
    normal! g@l
    setcursorcharpos(save_pos[1], save_pos[2])
  endif
enddef

def Repeat(_: string)
  if last_target != ''
    is_repeating = true
    Use(last_target)
    is_repeating = false
  endif
enddef

export def UseComplete(ArgLead: string, CmdLine: string, CursorPos: number): list<string>
  return copy(use_targets)->filter((_, v) => v =~# '^' .. ArgLead)
enddef
