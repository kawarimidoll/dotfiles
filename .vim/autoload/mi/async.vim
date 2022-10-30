" [[WIP]]
" ref: https://github.com/airblade/vim-gitgutter/blob/master/autoload/gitgutter/async.vim
let s:jobs = {}

" handler = {
"   err(bufnr, data),
"   out(bufnr, data)
" }

function! mi#async#execute(cmd, bufnr, handler) abort
  let options = {
        \   'stdout_buffer': [],
        \   'stderr_buffer': [],
        \   'buffer': a:bufnr,
        \   'handler': a:handler
        \ }
  let command = s:build_command(a:cmd)

  if exists('*jobstart')
    let job_id = jobstart(command, extend(options, {
          \   'on_stdout': function('s:on_stdout_nvim'),
          \   'on_stderr': function('s:on_stderr_nvim'),
          \   'on_exit':   function('s:on_exit_nvim'),
          \   'stdin':     'null'
          \ }))
    let s:jobs[job_id] = 1
  elseif exists('*job_start')
    let job = job_start(command, {
          \   'out_cb':   function('s:on_stdout_vim', options),
          \   'err_cb':   function('s:on_stderr_vim', options),
          \   'close_cb': function('s:on_exit_vim', options),
          \   'in_io':    'null'
          \ })
    let s:jobs[s:job_id(job)] = job
  else
    throw 'cannot use job'
  endif
endfunction

function! mi#async#jobs() abort
  return s:jobs
endfunction

function! s:build_command(cmd)
  if has('unix')
    return ['sh', '-c', a:cmd]
  endif

  if has('win32')
    return has('nvim') ? ['cmd.exe', '/c', a:cmd] : 'cmd.exe /c ' .. a:cmd
  endif

  throw 'unknown os'
endfunction

function! s:on_stdout_nvim(_job_id, data, _event) dict abort
  if empty(self.stdout_buffer)
    let self.stdout_buffer = a:data
  else
    let self.stdout_buffer = self.stdout_buffer[:-2] +
          \ [self.stdout_buffer[-1] .. a:data[0]] +
          \ a:data[1:]
  endif
endfunction

function! s:on_stderr_nvim(_job_id, data, _event) dict abort
  " With Neovim there is always [''] reported on stderr.
  if a:data == ['']
    return
  endif
  call self.handler.err(self.buffer, a:data)
endfunction

function! s:on_exit_nvim(job_id, exit_code, _event) dict abort
  if has_key(s:jobs, jobid)
    unlet s:jobs[jobid]
  endif
  if !a:exit_code
    call self.handler.out(self.buffer, self.stdout_buffer)
  endif
endfunction

function! s:on_stdout_vim(_channel, data) dict abort
  let t = type(a:data)
  if t == v:t_list
    let data = a:data
  elseif t == v:t_string
    let data = split(a:data, "\r\?\n")
  else
    let data = [a:data]
  endif
  call extend(self.stdout_buffer, data)
endfunction

function! s:on_stderr_vim(_channel, data) dict abort
  let t = type(a:data)
  if t == v:t_list
    let data = a:data
  elseif t == v:t_string
    let data = split(a:data, "\r\?\n")
  else
    let data = [a:data]
  endif
  call extend(self.stderr_buffer, data)
endfunction

function! s:on_exit_vim(channel) dict abort
  let job = ch_getjob(a:channel)
  let jobid = s:job_id(job)
  if has_key(s:jobs, jobid)
    unlet s:jobs[jobid]
  endif

  while 1
    if job_status(job) == 'dead'
      let exit_code = job_info(job).exitval
      break
    endif
    sleep 5m
  endwhile

  if !exit_code
    call self.handler.out(self.buffer, self.stdout_buffer)
  else
    call self.handler.err(self.buffer, self.stderr_buffer, exit_code)
  endif
endfunction

function! s:job_id(job)
  " Vim
  return job_info(a:job).process
endfunction
