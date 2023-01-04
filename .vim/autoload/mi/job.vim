" ref: https://github.com/tani/vim-jetpack/blob/b5cf6209866c1acdf06d4047ff33e7734bfa2879/plugin/jetpack.vim#L170-L217
function! s:jobcount(jobs) abort
  return len(filter(copy(a:jobs), {_, val -> s:jobstatus(val) ==# 'run'}))
endfunction

function! s:jobwait(jobs, njobs) abort
  let running = s:jobcount(a:jobs)
  while running > a:njobs
    let running = s:jobcount(a:jobs)
  endwhile
endfunction

let s:jobs = {}
if has('nvim')
  function! s:jobstatus(job) abort
    return jobwait([a:job], 0)[0] == -1 ? 'run' : 'dead'
  endfunction

  function! mi#job#list() abort
    let result = []
    for id in keys(s:jobs)
      call add(result, {'id': id, 'status': s:jobstatus(id)})
    endfor
    return result
  endfunction

  function! mi#job#start(cmd, opts = {}) abort
    let buf = []
    let On_out = get(a:opts, 'out', {data->0})
    let On_err = get(a:opts, 'err', {data->0})
    let On_exit = get(a:opts, 'exit', {data->0})
    let job = jobstart(a:cmd, {
          \   'stdin': 'null',
          \   'on_stdout': {_, data -> [extend(buf, data), On_out(data)]},
          \   'on_stderr': {_, data -> [extend(buf, data), On_err(data)]},
          \   'on_exit': {-> On_exit(join(buf, "\n"))}
          \ })
    let s:jobs[job] = 1
    return job
  endfunction
else
  function! s:jobstatus(job) abort
    return job_status(a:job)
  endfunction

  function! s:job_id(job)
    return job_info(a:job).process
  endfunction

  function! s:job_exit_cb(buf, cb, job, ...) abort
    let ch = job_getchannel(a:job)
    while ch_status(ch) ==# 'open' | sleep 1ms | endwhile
    while ch_status(ch) ==# 'buffered' | sleep 1ms | endwhile
    call a:cb(join(a:buf, "\n"))
  endfunction

  function! mi#job#list() abort
    let result = []
    for [id, job] in items(s:jobs)
      call add(result, {'id': id, 'status': s:jobstatus(job)})
    endfor
    return result
  endfunction

  function! mi#job#start(cmd, opts = {}) abort
    let buf = []
    let On_out = get(a:opts, 'out', {data->0})
    let On_err = get(a:opts, 'err', {data->0})
    let On_exit = get(a:opts, 'exit', {data->0})
    let job = job_start(a:cmd, {
          \   'in_io': 'null',
          \   'out_mode': 'raw',
          \   'out_cb': {_, data -> [extend(buf, split(data, "\n")), On_out(split(data, "\n"))]},
          \   'err_mode': 'raw',
          \   'err_cb': {_, data -> [extend(buf, split(data, "\n")), On_err(split(data, "\n"))]},
          \   'exit_cb': function('s:job_exit_cb', [buf, On_exit])
          \ })
    let s:jobs[s:job_id(job)] = job
    return job
  endfunction
endif
