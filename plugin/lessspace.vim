" LessSpace - a Vim plugin to strip whitespace on modified lines
" By George Hilliard - thirtythreeforty

if exists('g:loaded_lessspace_plugin')
    finish
endif
let g:loaded_lessspace_plugin = 1

" By default whitelist everything
if !exists('g:lessspace_whitelist')
    let g:lessspace_whitelist = '.*'
endif

fun! <SID>SetupTrailingWhitespaces()
    let curline = line('.')
    let b:insert_top = curline
    let b:insert_bottom = curline
endfun

fun! <SID>UpdateTrailingWhitespace()
    let curline = line('.')
    if b:insert_top > curline
        let b:insert_top = curline
    elseif b:insert_bottom < curline
        let b:insert_bottom = curline
    endif
endfun

fun! <SID>StripTrailingWhitespaces()
    " Only do this on whitelisted filetypes
    if &filetype !~ g:lessspace_whitelist
        return
    endif

    let original_cursor = getpos('.')
    let file_bottom = line('$')

    " Handle the user deleting lines at the bottom
    if b:insert_bottom > file_bottom
        let b:insert_bottom = file_bottom
    endif

    exe b:insert_top ',' b:insert_bottom 's/\s\+$//e'
    call setpos('.', original_cursor)
endfun

augroup TrailingWhitespace
    autocmd!
    autocmd InsertEnter * :call <SID>SetupTrailingWhitespaces()
    autocmd InsertLeave * :call <SID>StripTrailingWhitespaces()
    autocmd CursorMovedI * :call <SID>UpdateTrailingWhitespace()

    " The user may move between buffers in insert mode
    " (for example, with the mouse), so handle this appropriately.
    autocmd BufEnter * :if mode() == 'i'
        \ | call <SID>SetupTrailingWhitespaces() | endif
    autocmd BufLeave * :if mode() == 'i'
        \ | call <SID>StripTrailingWhitespaces() | endif
augroup END

