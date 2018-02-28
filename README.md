# LessSpace.vim

This simple plugin will strip the trailing whitespace from the file you are editing.
However, it does this only on the lines you edit or visit in Insert mode; it leaves all the others untouched.

I wrote this plugin because I work with people whose editors don't clean up whitespace.
My editor (Vim) *did* strip all whitespace, and saving my edits caused a lot of extraneous whitespace changes that showed up in version control logs.
This plugin gives the best of both worlds: it cleans up whitespace on edited lines only, keeping version control diffs clean.

## Installation

If you don't have a preferred installation method, I recommend installing [pathogen.vim](https://github.com/tpope/vim-pathogen), and then simply copy and paste:

    cd ~/.vim/bundle
    git clone git://github.com/thirtythreeforty/lessspace.vim

## Usage

For basic usage, just install it and forget it.
LessSpace works automatically.

LessSpace provides a couple commands that allow you to turn it on or off, either globally or per-buffer.
The global commands are:

 - `LessSpace`: Turn on whitespace stripping
 - `LessSpace!`: Turn off whitespace stripping

The per-buffer commands are very similar:

 - `LessSpaceBuf`: Turn on whitespace stripping
 - `LessSpaceBuf!`: Turn off whitespace stripping

## Configuration

LessSpace doesn't offer many configuration options, because everything happens automatically when you enter and leave Insert mode.

You can disable LessSpace on startup by setting the `g:lessspace_enabled` variable:

    let g:lessspace_enabled = 0

(The same effect can be achieved after startup by just running `:LessSpace!`.)

By default, LessSpace strips whitespace after normal mode operations (such as when you paste something from a register).
If you don't want this, you can have LessSpace only work in insert mode by setting `g:lessspace_normal`:

    let g:lessspace_normal = 0

You can also specify the filetypes that it operates on by specifying a filetype whitelist or blacklist.
(Perhaps, for example, you're writing [Whitespace](https://en.wikipedia.org/wiki/Whitespace_%28programming_language%29).)
By default, nothing is blacklisted.
You can change this by setting either of the `g:lessspace_whitelist` or `g:lessspace_blacklist` variables, preferably in your `vimrc` file.
These variables should be lists of the desired filetypes.
For example, to only operate on Vim and Ruby files, you could use:

    let g:lessspace_whitelist = ['ruby', 'vim']

And to operate on everything but Python files:

    let g:lessspace_blacklist = ['python']

(Previously, the whitelist had to be specified as a regex string.
This has been deprecated and removed; you should update to the list-based method.)

## License

Copyright © 2015-2017 George Hilliard.  Distributed under the same terms as Vim itself.
See `:help license`.
