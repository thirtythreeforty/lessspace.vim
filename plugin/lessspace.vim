" LessSpace - a Vim plugin to strip whitespace on modified lines
" By George Hilliard - thirtythreeforty

if exists('g:loaded_lessspace_plugin')
    finish
endif
let g:loaded_lessspace_plugin = 1

" By default blacklist nothing, unless the user has other preferences
if !exists('g:lessspace_whitelist') && !exists('g:lessspace_blacklist')
    let g:lessspace_blacklist = []
endif

" By default, enable by default
if !exists('g:lessspace_enabled')
    let g:lessspace_enabled = 1
endif

fun! <SID>SetupTrailingWhitespaces()
    let curline = line('.')
    let b:insert_top = curline
    let b:insert_bottom = curline
    let b:whitespace_lastline = curline
endfun

fun! <SID>UpdateTrailingWhitespace()
    " Handle motion this way (rather than checking if
    " b:insert_bottom < curline) to catch the case where the user presses
    " Enter, types whitespace, moves up, and presses Enter again.
    let curline = line('.')

    if b:whitespace_lastline < curline
        let b:insert_bottom = b:insert_bottom + (curline - b:whitespace_lastline)
    elseif b:whitespace_lastline > curline
        let b:insert_top = b:insert_top - (b:whitespace_lastline - curline)
    endif

    let b:whitespace_lastline = curline
endfun

fun! <SID>StripTrailingWhitespaces()
    " Only do this on whitelisted filetypes and if the buffer is modifiable
    if !<SID>ShouldStripFiletype(&filetype)
        \ || !&modifiable
        \ || !g:lessspace_enabled
        \ || (exists('b:lessspace_enabled') && !b:lessspace_enabled)
        return
    endif

    let original_cursor = getpos('.')

    " Handle the user deleting lines at the bottom
    let file_bottom = line('$')
    if b:insert_bottom > file_bottom
        let b:insert_bottom = file_bottom
    endif

    exe b:insert_top ',' b:insert_bottom 's/\v\s+$//e'
    call setpos('.', original_cursor)
endfun

fun! <SID>ShouldStripFiletype(filetype)
    " Whitelists override blacklists.
    if exists("g:lessspace_whitelist")
        if type(g:lessspace_whitelist) == type("")
            " Legacy handling of a regex whitelist.
            " Why did I ever think this was a good idea?
            return a:filetype =~# g:lessspace_whitelist
        endif

        return index(g:lessspace_whitelist, a:filetype) >= 0
    else
        return !(index(g:lessspace_blacklist, a:filetype) >= 0)
    endif
endfun

command! -bang LessSpace let g:lessspace_enabled = <bang>1
command! -bang LessSpaceBuf let b:lessspace_enabled = <bang>1

augroup LessSpace
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
