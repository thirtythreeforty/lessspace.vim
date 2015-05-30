# LessSpace.vim

This simple plugin will strip the trailing whitespace from the file you are editing.
However, it does this only on the lines you have visited in Insert mode; it leaves all the others untouched.

I wrote this plugin because I work with people whose editors don't clean up whitespace.
My editor (Vim) *did* strip all whitespace, and saving my edits caused a lot of extraneous whitespace changes that showed up in version control logs.
This plugin gives the best of both worlds: it cleans up whitespace on edited lines only, keeping version control diffs clean.

## Installation

If you don't have a preferred installation method, I recommend installing [pathogen.vim](https://github.com/tpope/vim-pathogen), and then simply copy and paste:

    cd ~/.vim/bundle
    git clone git://github.com/thirtythreeforty/lessspace.vim

## Configuration

LessSpace doesn't offer many configuration options, because everything happens automatically when you enter and leave Insert mode.
It does, however, allow you to change the filetypes that it operates on.
(Perhaps, for example, you're writing [Whitespace](https://en.wikipedia.org/wiki/Whitespace_%28programming_language%29).)
By default it operates on `.*`, all filetypes.
You can change this by setting the `g:lessspace_extensions` variable, preferably in your `vimrc` file.
For example, to only operate on Vim and Ruby files, you could use:

    let g:lessspace_extensions = 'ruby\|vim'

You can use any regular expression describing one or more filetypes.
Note that the regex is always evaluated in "magic" mode, so ensure you escape the proper characters.
