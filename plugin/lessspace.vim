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

" By default, strip whitespace in normal mode
if !exists('g:lessspace_normal')
    let g:lessspace_normal = 1
endif

command! -bang LessSpace let g:lessspace_enabled = <bang>1
command! -bang LessSpaceBuf let b:lessspace_enabled = <bang>1

augroup LessSpace
    autocmd!
    autocmd InsertEnter * :call lessspace#OnInsertEnter()
    autocmd InsertLeave * :call lessspace#OnInsertExit(0)
    autocmd TextChangedI * :call lessspace#OnTextChangedI()
    autocmd CursorMovedI * :call lessspace#OnCursorMovedI()

    autocmd TextChanged * :call lessspace#OnTextChanged()

    " The user may move between buffers in insert mode
    " (for example, with the mouse), so handle this appropriately.
    autocmd BufEnter * :if mode() == 'i'
        \ | call lessspace#OnInsertEnter() | endif
    autocmd BufLeave * :if mode() == 'i'
        \ | call lessspace#OnInsertExit(1) | endif

    autocmd CursorMoved * :call lessspace#DoDeferredStrip(0)
    autocmd BufWritePre * :call lessspace#DoDeferredStrip(1)
    autocmd FileWritePre * :call lessspace#DoDeferredStrip(1)
    autocmd FileAppendPre * :call lessspace#DoDeferredStrip(1)
    autocmd FilterWritePre * :call lessspace#DoDeferredStrip(1)

    autocmd User MultipleCursorsPre call lessspace#TemporaryDisableBegin()
    autocmd User MultipleCursorsPost call lessspace#TemporaryDisableEnd()
augroup END
