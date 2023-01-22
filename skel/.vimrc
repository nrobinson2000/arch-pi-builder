"Basic
set nocompatible
filetype plugin indent on
syntax enable
set ruler
set shortmess+=I
set wildmenu
set autoread
set scrolloff=3

"Indentation
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smarttab

"Line numbering
set number
set relativenumber

"Searching
set ignorecase
set smartcase
set incsearch
set hlsearch
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

"Status bars
set showtabline=2
set laststatus=2

"Mouse
set mouse=a

"Remap Q to save
nmap Q :w<CR>
