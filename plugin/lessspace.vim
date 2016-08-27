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

command! -bang LessSpace let g:lessspace_enabled = <bang>1
command! -bang LessSpaceBuf let b:lessspace_enabled = <bang>1

augroup LessSpace
    autocmd!
    autocmd InsertEnter * :call lessspace#SetupTrailingWhitespaces()
    autocmd InsertLeave * :call lessspace#StripTrailingWhitespaces()
    autocmd TextChangedI * :call lessspace#OnTextChangedI()
    autocmd CursorMovedI * :call lessspace#OnCursorMovedI()

    " The user may move between buffers in insert mode
    " (for example, with the mouse), so handle this appropriately.
    autocmd BufEnter * :if mode() == 'i'
        \ | call lessspace#SetupTrailingWhitespaces() | endif
    autocmd BufLeave * :if mode() == 'i'
        \ | call lessspace#StripTrailingWhitespaces() | endif
augroup END
