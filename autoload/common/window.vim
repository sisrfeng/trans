" ============================================================================
" File:        window.vim
" Description: File contains functions for working with window
" Maintainer:  Egor Churaev <egor.churaev@gmail.com>
" Licence:     GPLv3
"
" ============================================================================

let s:trans_win_name = "__Translate__"
let s:trans_prev_win_id = -1

" Private functions {{{ "
fun! s:closeWindowMap()
    nno      <silent> <buffer> q :call common#window#CloseTransWindow()<CR>
endf

fun! s:maps()
    nno      <silent> <buffer> <CR> :call common#window#SaveSelectedTranslation()<CR>
    call s:closeWindowMap()
endf
" }}} Private functions "

fun! common#window#CloseTransWindow()
    q
    if s:trans_prev_win_id > -1
        exec s:trans_prev_win_id."wincmd w"
    en
endf

fun! common#window#OpenTrans(cmd)
    let translate = system(a:cmd)
    let find = match(a:cmd, '\V-no-translate')
    if find > -1 && strlen(translate) == 0
        return
    en
    call common#window#GotoTransWindow()

    call s:maps()
    setl     buftype=nofile
    setl     complete=.
    setl     noswapfile
    setl     nobuflisted
    setl     nonumber
    setl     norelativenumber
    setl     ft=trans
    setl     modifiable

    %delete
    silent! put = translate
    norm gg
    setl     nomodifiable
endf

fun! common#window#OpenTransWindow()
    let bufnum = bufnr(s:trans_win_name)
    let bufwinnum = bufwinnr(s:trans_win_name)

    if bufnum != -1 && bufwinnum != -1
        return
    en
    let wcmd = s:trans_win_name
    let s:trans_prev_win_id = winnr()

    if g:trans_win_position == "bottom"
        exe 'silent! botright ' . g:trans_win_height . 'split ' . wcmd
    elseif g:trans_win_position == "right"
        exe 'silent! botright ' . g:trans_win_width . 'vsplit ' . wcmd
    elseif g:trans_win_position == "top"
        exe 'silent! topleft ' . g:trans_win_height . 'split ' . wcmd
    el
        exe 'silent! topleft ' . g:trans_win_width . 'vsplit ' . wcmd
    en
endf

fun! common#window#GotoTransWindow()
    if bufname("%") == s:trans_win_name
        return
    en

    let trans_winnr = bufwinnr(s:trans_win_name)
    if trans_winnr == -1
        silent! call common#window#OpenTransWindow()
        silent! let trans_winnr = bufwinnr(s:trans_win_name)
    en
    exec 'silent!' trans_winnr . "wincmd w"
endf

fun! common#window#SaveSelectedTranslation()
    if g:trans_save_history == 0
        redraw | echohl WarningMsg | echo "Cannot save translation. g:trans_save_history is zero" | echohl None
        return
    en
    " Get and trim selected line
    let translation = substitute(getline('.'), '^\s*\(.\{-}\)\s*$', '\1', '')
    if strlen(translation) == 0
        redraw | echohl WarningMsg | echo "Cannot save translation for empty line." | echohl None
        return
    en
    let source_text = common#trans#GetCurrentSourceText()
    let history_file =  common#history#AddTranslationToHistory(source_text, translation)
    if history_file =~ "^Error!"
        redraw | echohl WarningMsg | echo history_file | echohl None
        return
    en
    if g:trans_close_window_after_saving > 0
        call common#window#CloseTransWindow()
    en
    redraw | echo "Saved: ".source_text." -> ".translation.". To file: ".history_file
endf

fun! common#window#OpenTransHistoryWindow()
    let history_list = common#history#GetListOfHistoryFiles()
    let history_list_size = len(history_list)
    if history_list_size == 0
        return
    en

    if history_list_size == 1
        let history_file = history_list[0]
    el
        let shown_items = common#common#GenerateInputlist("Select history file:", history_list)
        let selected = inputlist(shown_items) - 1
        let history_file = history_list[selected]
    en

    if bufname("%") == history_file
        return
    en

    let trans_winnr = bufwinnr(history_file)
    if trans_winnr == -1
        let bufnum = bufnr(history_file)
        let bufwinnum = bufwinnr(history_file)

        if bufnum == -1 || bufwinnum == -1
            let wcmd = history_file
            exe 'silent! botright ' . g:trans_win_height . 'split ' . wcmd
            let trans_winnr = bufwinnr(history_file)
        en
    en
    call s:closeWindowMap()
    exec trans_winnr . "wincmd w"
endf

