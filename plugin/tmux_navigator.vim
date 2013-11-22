if exists("g:loaded_tmux_navigator") || &cp || v:version < 700
  finish
endif
let g:loaded_tmux_navigator = 1

function! s:UseTmuxNavigatorMappings()
  return !exists("g:tmux_navigator_no_mappings") || !g:tmux_navigator_no_mappings
endfunction

function! s:InTmuxSession()
  return $TMUX != ''
endfunction

let s:tmux_is_last_pane = 0
au WinEnter * let s:tmux_is_last_pane = 0

" Like `wincmd` but also change tmux panes instead of vim windows when needed.
function! s:TmuxWinCmd(direction, zoom)
  if s:InTmuxSession()
    call s:TmuxAwareNavigate(a:direction, a:zoom)
  else
    call s:VimNavigate(a:direction)
  endif
endfunction

function! s:TmuxAwareNavigate(direction, zoom)
  let nr = winnr()
  let tmux_last_pane = (a:direction == 'p' && s:tmux_is_last_pane)
  if !tmux_last_pane
    call s:VimNavigate(a:direction)
  endif
  " Forward the switch panes command to tmux if:
  " a) we're toggling between the last tmux pane;
  " b) we tried switching windows in vim but it didn't have effect.
  if tmux_last_pane || nr == winnr()
    if a:zoom
      let cmd = 'tmux resize-pane -Z'
    else
      let cmd = 'tmux select-pane -' . tr(a:direction, 'hjkl', 'LDUR')
    endif

    silent call system(cmd)
    let s:tmux_is_last_pane = 1
  else
    let s:tmux_is_last_pane = 0
  endif
endfunction

function! s:VimNavigate(direction)
  try
    execute 'wincmd ' . a:direction
  catch
    echohl ErrorMsg | echo 'E11: Invalid in command-line window; <CR> executes, CTRL-C quits: wincmd k' | echohl None
  endtry
endfunction

command! TmuxNavigateLeft call <SID>TmuxWinCmd('h', 0)
command! TmuxNavigateDown call <SID>TmuxWinCmd('j', 0)
command! TmuxNavigateUp call <SID>TmuxWinCmd('k', 0)
command! TmuxNavigateRight call <SID>TmuxWinCmd('l', 0)

" I'll add back previous sometime
" command! TmuxNavigatePrevious call <SID>TmuxWinCmd('p', 0)

command! TmuxNavigateLeftZoom call <SID>TmuxWinCmd('h', 1)
command! TmuxNavigateDownZoom call <SID>TmuxWinCmd('j', 1)
command! TmuxNavigateUpZoom call <SID>TmuxWinCmd('k', 1)
command! TmuxNavigateRightZoom call <SID>TmuxWinCmd('l', 1)


if s:UseTmuxNavigatorMappings()
  nnoremap <silent> <F1> :TmuxNavigateLeft<cr>
  nnoremap <silent> <F2> :TmuxNavigateDown<cr>
  nnoremap <silent> <F3> :TmuxNavigateUp<cr>
  nnoremap <silent> <F4> :TmuxNavigateRight<cr>

  nnoremap <silent> <F5> :TmuxNavigateLeftZoom<cr>
  nnoremap <silent> <F6> :TmuxNavigateDownZoom<cr>
  nnoremap <silent> <F7> :TmuxNavigateUpZoom<cr>
  nnoremap <silent> <F8> :TmuxNavigateRightZoom<cr>
  
  inoremap <silent> <F1> <ESC>:TmuxNavigateLeft<cr>i
  inoremap <silent> <F2> <ESC>:TmuxNavigateDown<cr>i
  inoremap <silent> <F3> <ESC>:TmuxNavigateUp<cr>i
  inoremap <silent> <F4> <ESC>:TmuxNavigateRight<cr>i

  inoremap <silent> <F5> <ESC>:TmuxNavigateLeftZoom<cr>i
  inoremap <silent> <F6> <ESC>:TmuxNavigateDownZoom<cr>i
  inoremap <silent> <F7> <ESC>:TmuxNavigateUpZoom<cr>i
  inoremap <silent> <F8> <ESC>:TmuxNavigateRightZoom<cr>i
endif
