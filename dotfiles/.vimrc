" For personal Vim configurations in Windows 10 
syntax on
syntax enable 

set encoding=utf-8  " The encoding displayed.
set fileencoding=utf-8  " The encoding written to file.
set background=dark
set guifont=CaskaydiaCove_Nerd_Font:h10:cANSI:qDRAFT
set shell=pwsh
set splitbelow
set termwinsize=18x0
set pythonthreehome=python39.dll

cmap vt vertical terminal

set noerrorbells
set novisualbell
set tabstop=4 softtabstop=4
set shiftwidth=4 
set expandtab
set smartindent
set autoindent
set nu relativenumber
set nowrap
set smartcase
set showmatch
set noswapfile
set nobackup
set undodir=$HOME/vimfiles/undodir
set undofile
set incsearch
" set rulerformat=%15(%c%V\ %p%%%)

" By default, hide GUI menus, toggle between visibility and none using <F11>
set guioptions=hide

set colorcolumn=80
highlight ColorColumn ctermbg=0 ctermfg=0 guibg=lightgrey guifg=black

call plug#begin('$HOME/vimfiles/after')

Plug 'morhetz/gruvbox' 
Plug 'jremmen/vim-ripgrep'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'vim-utils/vim-man'
Plug 'tpope/vim-fugitive'
Plug 'mbbill/undotree' 
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes' 
Plug 'ycm-core/YouCompleteMe' 
Plug 'https://github.com/ctrlpvim/ctrlp.vim'

call plug#end()

colorscheme gruvbox 

if executable('rg') 
    let g:rg_derive_root='true'
endif

function! ToggleGUICruft() 
    if &guioptions=='hide'
        exec('set guioptions=imTrL')
    else
        exec('set guioptions=hide')
    endif
endfunction

function! <SID>StripTrailingWhitespaces()
    if !&binary && &filetype != 'diff'
        let l:save = winsaveview()
        keeppatterns %s/\s\+$//e
        call winrestview(l:save)
    endif
endfunction

map <F11> <Esc>:call ToggleGUICruft()<CR>

autocmd FileType c,cpp,java,go,rust,python autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

" vim-ripgrep is now usable
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
" <leader> key
let mapleader = " " 
let g:netrw_browse_split = 2
let g:netrw_banner = 0
let g:netrw_winszie = 25
let g:ctrlp_use_caching = 0
let g:airline#extensions#tabline#enabled = 1 
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_theme = 'transparent'

" Change default keymap for convenient usage
" <space>+h = :h
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>t :vsp <bar> :ter<CR>
nnoremap <leader>u :UndotreeShow<CR>
nnoremap <leader>pv :wincmd v <bar> :Ex <bar> :ex <bar> :vertical resize 30<CR>
nnoremap <leader>ps :Rg<SPACE>
nnoremap <leader>re :source %<CR> 
nnoremap <silent> <leader>+ :vertical resize +5<CR>
nnoremap <silent> <leader>- :vertical resize -5<CR>

" YCM: not done -> can not loaded `python` yet
nnoremap <silent> <Leader>gd :YcmCompleter GoTo<CR>
nnoremap <silent> <Leader>gf :YcmCompleter FixIt<CR>
