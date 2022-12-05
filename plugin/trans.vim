" Description: Translate text by using translate-shell
" Maintainer:  Egor Churaev <egor.churaev@gmail.com>
" Licence:     GPLv3
"

if exists('loaded_trans')
    finish
en
let loaded_trans = 1

" Default configuration {{{ "
    if !exists('g:trans_bin')
        let g:trans_bin = ""
    en
    if !exists('g:trans_default_direction')
        let g:trans_default_direction = ""
    en
    if !exists('g:trans_directions_list')
        let g:trans_directions_list = []
    en
    if !exists('g:trans_interactive_full_list')
        let g:trans_interactive_full_list = 0
    en
    if !exists('g:trans_advanced_options')
        let g:trans_advanced_options = ""
    en
    if !exists('g:trans_win_width')
        let g:trans_win_width = 50
    en
    if !exists('g:trans_win_height')
        let g:trans_win_height = 15
    en
    if !exists('g:trans_win_position')
        let g:trans_win_position = 'bottom'
    en
    if !exists('g:trans_join_lines')
        let g:trans_join_lines = 0
    en
    if !exists('g:trans_save_history')
        let g:trans_save_history = 0
    en
    if !exists('g:trans_history_file')
        let g:trans_history_file = ''
    en
    if !exists('g:trans_history_format')
        let g:trans_history_format = '%s;%t'
    en
    if !exists('g:trans_close_window_after_saving')
        let g:trans_close_window_after_saving = 0
    en
    if !exists('g:trans_save_only_unique')
        let g:trans_save_only_unique = 0
    en
    if !exists('g:trans_save_audio')
        let g:trans_save_audio = 0
    en
    if !exists('g:trans_ignore_audio_for_langs')
        let g:trans_ignore_audio_for_langs = []
    en
    if !exists('g:trans_save_raw_history')
        let g:trans_save_raw_history = 0
    en
    if !exists('g:trans_history_raw_file')
        let g:trans_history_raw_file = '~/.vim/.trans_raw_history'
    en

"
com!  -nargs=* TransTerm                   call trans#TransTerm(<f-args>)
com!  -nargs=* -range Trans                call trans#Trans(<line1>, <line2>, <count>, <f-args>)
com!  -nargs=0 -range TransSelectDirection call trans#TransSelectDirection(0, <line1>, <line2>, <count>)
com!  -nargs=* TransInteractive            call trans#TransInteractive(0, <f-args>)
com!  -nargs=0 TransOpenHistoryWindow      call trans#TransOpenHistoryWindow()
com!  -nargs=0 TransChangeDefaultDirection call trans#TransChangeDefaultDirection()

