fun! lessspace#OnInsertEnter()
    let curline = line('.')
    let b:insert_top = curline
    let b:insert_bottom = curline
    let b:whitespace_lastline = curline
endfun

fun! lessspace#OnTextChanged()
    " Text was modified in non-Insert mode.  Use the '[ and '] marks to find
    " what was edited and remove its whitespace.
    if g:lessspace_normal == 0
        return
    endif

    call lessspace#MaybeStripWhitespace(line("'["), line("']"))
endfun

fun! lessspace#OnTextChangedI()
    " Handle motion this way (rather than checking if
    " b:insert_bottom < curline) to catch the case where the user presses
    " Enter, types whitespace, moves up, and presses Enter again.
    let curline = line('.')

    if b:whitespace_lastline < curline
        " User inserted lines below whitespace_lastline
        let b:insert_bottom = b:insert_bottom + (curline - b:whitespace_lastline)
    elseif b:whitespace_lastline > curline
        " User inserted lines above whitespace_lastline
        let b:insert_top = b:insert_top - (b:whitespace_lastline - curline)
    endif

    let b:whitespace_lastline = curline
endfun

fun! lessspace#OnCursorMovedI()
    " This function is called when the cursor moves, including when the
    " user types text.  However we've already handled the text typing in the
    " OnTextChangedI() hook, so this function is harmless.
    let curline = line('.')

    let b:insert_top = min([curline, b:insert_top])
    let b:insert_bottom = max([curline, b:insert_bottom])
    let b:whitespace_lastline = curline
endfun

fun! lessspace#OnInsertExit()
    " Handle the user deleting lines at the bottom
    let file_bottom = line('$')
    if b:insert_bottom > file_bottom
        let b:insert_bottom = file_bottom
    endif

    call lessspace#MaybeStripWhitespace(b:insert_top, b:insert_bottom)
endfun

fun! lessspace#MaybeStripWhitespace(top, bottom)
    " Only do this on whitelisted filetypes and if the buffer is modifiable
    " and modified
    if !lessspace#ShouldStripFiletype(&filetype)
        \ || !&modifiable
        \ || !&modified
        \ || !g:lessspace_enabled
        \ || (exists('b:lessspace_enabled') && !b:lessspace_enabled)
        return
    endif

    " All conditions passed, go ahead and strip
    let original_cursor = getpos('.')
    exe a:top ',' a:bottom 's/\v\s+$//e'
    call setpos('.', original_cursor)
endfun

fun! lessspace#ShouldStripFiletype(filetype)
    " Whitelists override blacklists.
    if exists("g:lessspace_whitelist")
        if type(g:lessspace_whitelist) == type("")
            " Legacy handling of a regex whitelist.
            " Why did I ever think this was a good idea?
            if !exists("g:lessspace_whitelist_warning")
                echoerr "Lessspace: regex filetype whitelists have been deprecated! Please use the new list-based format."
                g:lessspace_whitelist_warning = 1
            endif
            return a:filetype =~# g:lessspace_whitelist
        endif

        return index(g:lessspace_whitelist, a:filetype) >= 0
    else
        return !(index(g:lessspace_blacklist, a:filetype) >= 0)
    endif
endfun

