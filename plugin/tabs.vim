" File: tabs.vim
" Author: valsorym <i@valsorym.com>


""" LABELS OF THE TABS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function TabLabel(n, style)
    " Creates a label of tab at the specified style:
    "   0. short tabs - only filename;
    "   1. show parent folder + filename;
    "   2. show only first and last symbol from parent folder + filename;
    "   3. show only first symbol from parent folder + filename;
    "   4. show only three first symbol from parent folder + filename.
    let label = ''
    let buflist = tabpagebuflist(a:n)
    let file = bufname(buflist[tabpagewinnr(a:n) - 1])
    let label = substitute(file, '.*/', '', '')

    " If active NERDTree or Tagbar - ignore their names in the tab.
    " On the tab we try to find a buffer with a real file.
    for i in buflist
        let s:file=fnamemodify(bufname(i), '')
        let s:is_tagbar_buffer=stridx(s:file, '__Tagbar__') == 0
        let s:is_nerdtree_buffer=stridx(s:file, 'NERD_tree_') == 0
        """ silent execute '!echo '. file .' >> ~/.vimdebug.tmp'
        if bufexists(i) && !s:is_tagbar_buffer && !s:is_nerdtree_buffer
            let file=s:file
            let label=substitute(s:file, '.*/', '', '')
            break
        endif
    endfor

    if label == ''
        let label = '[No Name]'
        let label = ' ' . a:n . '. ' . label
    else
        " The style == 1 - full name parent folder.
        let parent = split(fnamemodify(file, ':p'), '/')[-2]
        if parent != '' && a:style != 0
            if a:style == 2
                " The style == 2 - only first and last symbol of parent folder.
                let parent = parent[0] . '..' . parent[strlen(parent) - 1]
            elseif a:style == 3
                " The style == 3 - only first symbol of parent folder.
                let parent = parent[0]
            elseif a:style == 4
                " The style == 4 - only three first symbol of parent folder.
                if strlen(parent) > 5
                    " The three first symbols + two dots - it's 5 symbols, so
                    " if parent folder name has 5 symbols - just show parent.
                    let parent = parent[0] . parent[1] . parent[2] . '..'
                endif
            endif

            let label = ' ' . a:n . '. ' . parent . '/' . label
        else
            " Short on no detected parent.
            let label = ' ' . a:n . '. ' . label
        endif
    endif

    for i in range(len(buflist))
        if getbufvar(buflist[i], "&modified")
            let label = label . '*'
            break
        endif
    endfor

    return label
endfunction " TabLabel

function TabName(style)
    " Style tab name.
    let str = ''

    for i in range(tabpagenr('$'))
        if i + 1 == tabpagenr()
            let str .= '%#TabLineSel#'
        else
            let str .= '%#TabLine#'
        endif

        let str .= '%' . (i + 1) . 'T'
        let str .= ' %{TabLabel(' . (i + 1) . ', ' . a:style . ')} |'
    endfor

    let str .= '%#TabLineFill#%T'

    if tabpagenr('$') > 1
        let str .= '%=%#TabLine#%999XX'
    endif

    return str
endfunction " TabName


""" TAB MANAGER
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function MoveTabLeft()
    " Move tab to the left.
    let current_tab = tabpagenr()
    if current_tab > 1
        let current_tab = current_tab - 2
        execute 'tabmove' current_tab
    endif
endfunction " MoveTabLeft

function MoveTabRight()
    " Move tab to the rigeht.
    let current_tab = tabpagenr()
    if has("gui_macvim")
        " For MacVim.
        let current_tab = tabpagenr() + 1
    endif
    execute 'tabmove' current_tab
endfunction " MoveTabRight

function MoveTabFirst()
    " Move tab to the first position.
    execute 'tabmove' 0
endfunction " MoveTabFirst

function MoveTabLast()
    " Move tab to the last position.
    let current_tab = len(range(tabpagenr('$')))
    execute 'tabmove' current_tab
endfunction " MoveTabLast

function OpenFirstTab()
    " Open first tab.
    execute 'tabn' 1
endfunction " OpenFirstTab

function AutoMoveTabLast()
    " Auto move tab to the last position.
    let current_tab = tabpagenr()
    let last_tab = len(range(tabpagenr("$")))
    if (last_tab > 5) && ((last_tab - current_tab) > 3)
        " Only if we have a lot of tabs and the tab is not in the display.
        execute "tabmove" last_tab
    endif
endfunction " AutoMoveTabLast

function NewTabMoveLast()
    " Auto move new tab to the last position.
    let last_tab = len(range(tabpagenr("$")))
    execute "tabmove" last_tab
endfunction " NewTabMoveLast

function CloseDuplicateTabs(method)
    " Close duplicate tabs.
    " The method to determine the order of the scan tabs:
    " 0. from left to right;
    " 1. from right to left.
    let tpbufflst = []
    let duplicates = []

    " Search duplicates.
    if a:method == 1
        " Scan from right to left.
        " It is profitable if used the NewTabMoveLast method:
        " autocmd BufNew * call NewTabMoveLast()
        " autocmd BufEnter * call CloseDuplicateTabs(1)
        let i = tabpagenr("$")
        let tabpgbufflst = tabpagebuflist(i)
        while i > 0
            " View all tabs.
            let buflist = tabpagebuflist(i)
            let j = 0
            if len(buflist) > 1
                " If are running vim-nerdtree-tabs (in buflist[0]) - ignore it.
                let j = 1
            endif

            while j < len(buflist)
                " Filter duplicate buffers by buffer index.
                let buffer = buflist[j]
                if index(tpbufflst, buffer) >= 0
                    " Add tab number as a tab for removal.
                    if index(duplicates, i) < 0
                        call add(duplicates, i)
                    endif
                else
                    " Add buffer number - as already scanned buffer.
                    call add(tpbufflst, buffer)
                endif
                let j += 1
            endwhile " /while

            let i -= 1
        endwhile " /while
    else
        " Scan  from left to right.
        " If not used the NewTabMoveLast method.
        let i = 1
        let tabpgbufflst = tabpagebuflist(i)
        while type(tabpagebuflist(i)) == 3
            " * type() get 3 if object have list type.
            " View all tabs.
            let buflist = tabpagebuflist(i)
            let j = 0
            if len(buflist) > 1
                " If are running vim-nerdtree-tabs (in buflist[0]) - ignore it.
                let j = 1
            endif

            while j < len(buflist)
                " Filter duplicate buffers by buffer index.
                let buffer = buflist[j]
                if index(tpbufflst, buffer) >= 0
                    " Add tab number as a tab for removal.
                    if index(duplicates, i) < 0
                        call add(duplicates, i)
                    endif
                else
                    " Add buffer number - as already scanned buffer.
                    call add(tpbufflst, buffer)
                endif
                let j += 1
            endwhile " /while

            let i += 1
        endwhile

        " If there are several duplicates, need to remove them from the end.
        call reverse(duplicates)
    endif

    " Close duplicates.
    for tb in duplicates
        exec "tabclose ".tb
    endfor
endfunction " CloseDuplicateTabs

