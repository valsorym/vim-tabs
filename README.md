VIM TABS
========

The vim plugin that allows you to comfortably manage of the tabs.

Problem
-------

###Tab style


If we have such a directory structure:

```
    myapp/
        models/
            accounts.py
            ...
        forms/
            accounts.py
            ...
        views/
            accounts.py
            ...
```
If we open all the accounts.py files we'll see the following tabs:

```
1. accounts.py | 2. accounts.py | 3. accounts.py
```

It is problem, because we don't know which file open on tab 2! Now we've added a tab styles.

Set custom stule (for example - style 3):

```
echo "set tabline=%!TabName(3)" >> ~/.vimrc
```

####Style 1
Show parent folder and filename. Show only parent folder, not full path to file.

```
1. models/accounts.py | 2. forms/accounts.py | 3. views/accounts.py
```

#### Style 2
Show only first and last symbol from parent folder and filename.

```
1. m..s/accounts.py | 2. f..s/accounts.py | 3. v..s/accounts.py
```

####Style 3
Show only first symbol from parent folder and filename.

```
1. m/accounts.py | 2. f/accounts.py | 3. v/accounts.py
```

But if we have files:

```
    myapp/
        models/
            accounts.py
        managers/
            accounts.py
```

Problem - models and managers starts with m.:
```
1. m/accounts.py | 2. m/accounts.py
```

####Style 4
Show only three first symbol from parent folder + filename. But if the name of the parent directory is less or equal to 5 characters - it is displayed as full.
```
1. mod../accounts.py | 2. forms/accounts.py | 3. views/accounts.py
```

###The tabs are hidden

If you open 2-5 tabs - you have no problems. But if you have opened 25 tabs - it is a problem. All the tabs do not fit on the screen. Therefore, if you have more than 5 tabs open, and you begin to edit tab - the current tab automatically moves to the last position.

And all new tab automatically moves to the last position.

###Moving between tabs

Uncomfortable enter commands to open a tab, it is much better to assign hot-keys for this.


Install
-------

Use vundle, add 
```
Plugin 'valsorym/vim-tabs'
```
and run `:PluginInstall!` in your vim.

Configs
-------

Add next configs into `~/.vimrc`:

```
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" TABS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Styling of the tabs.
""" USAGE:
"""     Ctrl+j - move tab left;
"""     Ctrl+k - move tab right;
"""     Ctrl+h - move tab to first position;
"""     Ctrl+l - move tab to last position;
"""     Ctrl+z - open first tab.
""" URLS:
"""     https://github.com/valsorym/vim-tabs
"""
""" TAB LABEL STYLE
""" 0. Short tabs - only filename.
""" 1. Show parent folder + filename.
""" 2. Show only first and last symbol from parent folder + filename.
""" 3. Show only first symbol from parent folder + filename.
""" 4. Show only three first symbol from parent folder + filename.
""" Show only three first symbol from parent folder + filename.
set tabline=%!TabName(4)

""" Automatically move the tab to the last position.
if has('autocmd')
    " If open a lot of tabs and when the tab is editing - moved tab to last
    " position.
    autocmd InsertEnter * call AutoMoveTabLast()

    " If open new tab - move it on the last position.
    autocmd BufNew * call NewTabMoveLast()

    " Autoclose duplicate tabs.
    " + Add `CloseDuplicateTabs` - duplicate tabs closing command.
    " * If used NewTabMoveLast method - use CloseDuplicateTabs(1).
    autocmd BufEnter * call CloseDuplicateTabs(1)
    command CloseDuplicateTabs :call CloseDuplicateTabs(1)
endif " autocmd

imap <C-j> <Esc>:call MoveTabLeft()<CR>
nmap <C-j> :call MoveTabLeft()<CR>

imap <C-k> <Esc>:call MoveTabRight()<CR>
nmap <C-k> :call MoveTabRight()<CR>

imap <C-h> <Esc>:call MoveTabFirst()<CR>
nmap <C-h> :call MoveTabFirst()<CR>

imap <C-l> <Esc>:call MoveTabLast()<CR>
nmap <C-l> :call MoveTabLast()<CR>

imap <C-z> <Esc>:call OpenFirstTab()<CR>
nmap <C-z> :call OpenFirstTab()<CR>

```

... so, hot-keys:

- `C-t` - list of buffers (tabs).
- `C-n` - open new tab (or - `F7`).
- `C-h` - move tab to first position.
- `C-j` - move tab to left.
- `C-k` - move tab to right.
- `C-l` - move tab to last position.
- `C-z` - open first tab.
- `C-PgUp` or `F5` - tab prev.
- `C-PgDw` or `F6` - tab next.

License
-------

Copy, modify and use in anywhere!

*Please, leave the links to the original plugins and solutions that you use in your configurations. Respect the work of other developers!*


