" Install Vim-Plug manager
" ----------------------------------------------------------------
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" ----------------------------------------------------------------

call plug#begin('~/.vim/plugged')
" Theme
Plug 'joshdick/onedark.vim'
Plug 'itchyny/lightline.vim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Auto Complete
Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }

" LSP
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'

" Syntax Hightlight

" Python sense
Plug 'jeetsukumaran/vim-pythonsense'

" Linting
Plug 'dense-analysis/ale'

" Syntax highlighting
" Plug 'sheerun/vim-polyglot'

" Arduino vim plugin
" Plug 'stevearc/vim-arduino'

call plug#end()


" General Config
" -------------------
" Enter the current millenium (Force Vim to NOT behave like Vi)
set nocompatible
filetype indent on

set number
set relativenumber
set ts=4 sw=4
syntax on
colorscheme onedark

set laststatus=2
set noshowmode
" ------------------

" LSP config
"------------------------------------------------------
if executable('pylsp')
    " pip install python-lsp-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pylsp',
        \ 'cmd': {server_info->['pylsp']},
        \ 'allowlist': ['python'],
        \ })
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
"------------------------------------------------------

" YSM config
" -----------------------------------------------------
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_enable_semantic_highlighting=1

" -----------------------------------------------------
"

" ALE config
" ------------------------------------------
let g:ale_fixers = {
    \    '*': ['remove_trailing_lines', 'trim_whitespace'],
    \    'python': ['black'],
    \}
let g:ale_fix_on_save = 1
" ------------------------------------------


" Vim Keybind for Git
" -------------------------------------------
"" Open File explorer for current Git repo
nmap <C-P> :GFiles<CR>
" -------------------------------------------
"

" Shortcut key for Joplin
function! InsertCurrentDateTime()
    " Run the Python command and capture the output
    let l:current_datetime = system('python3 -c "from datetime import datetime; print(datetime.now().strftime(\"%d/%m/%Y %H:%M\"))"')
    " Insert the output at the cursor position
    execute "normal! i" . l:current_datetime
endfunction
nnoremap <F5> :call InsertCurrentDateTime()<CR>
