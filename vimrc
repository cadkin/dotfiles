" Always have syntax
syntax on
" Highlight search
set hlsearch
" Fix the tabs
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
" Enable the mouse
set mouse=a
" 256 colors on dark background.
set t_Co=256
set background=dark
" Paste insert toggle
set pastetoggle=<F2>
" Enable numbering
set number
" Enable indention
set autoindent
" Enable scrolloff
set scrolloff=5
" Disable the help
map <F1> <Esc>
imap <F1> <Esc>
" Highlight extra whitespaces
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
" Clean extra whitespace
autocmd BufWritePre * %s/\s\+$//e
" Allow cross-session paste
set clipboard=unnamed
" Backspacing
set backspace=indent,eol,start
" Recall edit position
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Status bar
set laststatus=2


" File options
" Tex
au BufReadPost,BufNewFile *.tex setlocal tw=120 spell

" Load and generate help.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL
