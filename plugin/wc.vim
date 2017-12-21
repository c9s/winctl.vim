
" Window Ctrl Plugin
"
" Author: Cornelius 
" Email:  cornelius.howl@gmail.com 
" Version: 0.1

" Screen info {{{

let g:screen_cols = 177
let g:screen_rows = 48
"  - depends on font-width

let g:screen_w = 1280
let g:screen_h = 800

let g:zero_x = 2
let g:zero_y = 20

" }}}

" Window Ctrl Config"{{{

let g:window_ctrl_h_inc = 5  " columns
let g:window_ctrl_v_inc = 3   " lines
let g:window_ctrl_x_inc = 30
let g:window_ctrl_y_inc = 30

"}}}
" Window Ctrl"{{{
"
fun! s:WHLeft()
  execute printf('winsize %d %d', g:screen_cols / 2 , g:screen_rows )
  execute printf('winpos  %d %d', g:zero_x , g:zero_y )
endfunction

fun! s:WHRight()
  execute printf('winsize %d %d', g:screen_cols / 2 , g:screen_rows )
  execute printf('winpos  %d %d', g:screen_w / 2 , g:zero_y )
endfunction

fun! s:WFull()
  execute printf('winsize %d %d', g:screen_cols , g:screen_rows )
  execute printf('winpos  %d %d', g:zero_x , g:zero_y )
endfunction

fun! s:AdjustHeight(op)
  let cur_lines = &lines
  exec 'let cur_lines ' a:op . '=' . g:window_ctrl_v_inc 
  exec 'set lines=' . cur_lines
endf

fun! s:AdjustWidth(op)
  let cur_columns = &columns
  exec 'let cur_columns ' a:op . '=' . g:window_ctrl_h_inc
  exec 'set columns=' . cur_columns
endf


fun! s:AdjustX(op)
  let x = getwinposx()
  let y = getwinposy()
  exec 'let x ' . a:op . '=' . g:window_ctrl_x_inc
  exec 'winpos ' . x . ' ' . y
endf

fun! s:AdjustY(op)
  let x = getwinposx()
  let y = getwinposy()
  exec 'let y ' . a:op . '=' . g:window_ctrl_y_inc
  exec 'winpos ' . x . ' ' . y
endf

fun! s:WindowSnapToGrid()
  let x = getwinposx()
  let y = getwinposy()
  if x <= g:screen_w / 2
    let x = 0 + g:zero_x
  else 
    let x = g:screen_w / 2
  endif

  if y <= g:screen_h / 2
    let y = 0 + g:zero_y
  else 
    let y = g:screen_h / 2
  endif
  exec 'winpos ' . x . ' ' . y
endf


com! SetWindowSnapToGrid   :call s:WindowSnapToGrid()
com! WHLeft  :cal s:WHLeft()
com! WHRight :cal s:WHRight()


fun! EnableWindowCtrl()
  nnoremap <buffer> <silent> <Up>    :DecHeight<CR>
  nnoremap <buffer> <silent> <Down>  :IncHeight<CR>
  nnoremap <buffer> <silent> <Left>  :DecWidth<CR>
  nnoremap <buffer> <silent> <Right> :IncWidth<CR>

  nnoremap <buffer> <silent> j     :IncY<CR>
  nnoremap <buffer> <silent> k     :DecY<CR>

  nnoremap <buffer> <silent> l     :IncX<CR>
  nnoremap <buffer> <silent> h     :DecX<CR>

  nnoremap <buffer> <silent> gg      :SetWindowSnapToGrid<CR>
  "nnoremap <buffer> <silent> gh      :exec printf('winpos %d %d' , 0 , g:zero_y )<CR>
  "nnoremap <buffer> <silent> gl      :exec printf('winpos %d %d' , g:screen_w / 2 , g:zero_y )<CR>
  nnoremap <buffer> <silent> gh      :WHLeft<CR>
  nnoremap <buffer> <silent> gl      :WHRight<CR>
endf

fun! DisableWindowCtrl()
  nunmap <buffer> <silent> <Up>
  nunmap <buffer> <silent> <Down>
  nunmap <buffer> <silent> <Left>
  nunmap <buffer> <silent> <Right>
  nunmap <buffer> <silent> gg
  nunmap <buffer> <silent> gh
  nunmap <buffer> <silent> gl
  nunmap <buffer> <silent> j
  nunmap <buffer> <silent> k
  nunmap <buffer> <silent> h
  nunmap <buffer> <silent> l
endf

let g:window_ctrl = 0
fun! ToggleWindowCtrl()
  if g:window_ctrl 
    echo 'Window Ctrl: off'
    call DisableWindowCtrl()
    let g:window_ctrl = 0
    redraw
  else
    echo 'Window Ctrl: on'
    call EnableWindowCtrl()
    let g:window_ctrl = 1
    redraw
  endif
endf

com! IncHeight :call s:AdjustHeight('+')
com! DecHeight :call s:AdjustHeight('-')
com! IncWidth :call s:AdjustWidth('+')
com! DecWidth :call s:AdjustWidth('-')

com! IncY :cal s:AdjustY('+')
com! DecY :cal s:AdjustY('-')
com! IncX :call s:AdjustX('+')
com! DecX :call s:AdjustX('-')

com! WindowCtrlToggle         :cal ToggleWindowCtrl()

nmap <leader>ww   :WindowCtrlToggle<CR>

"}}}
