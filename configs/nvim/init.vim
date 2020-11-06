"Editor settings
syntax enable
set autoindent
set shiftwidth=4
set smartindent
set smarttab
set softtabstop=4
set expandtab
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=2
set foldmethod=manual
set nobackup
set number
set laststatus=2
set termguicolors
set cursorline
set pumblend=15
set t_Co=256
set background=light


"Indentation
autocmd Filetype html setlocal ts=2 sts=2 sw=2
autocmd Filetype php setlocal ts=2 sts=2 sw=2
autocmd Filetype css setlocal ts=2 sts=2 sw=2
autocmd Filetype sass setlocal ts=2 sts=2 sw=2
autocmd Filetype scss setlocal ts=2 sts=2 sw=2

"Shortcuts
map <C-n> :NERDTreeToggle<CR>
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

call plug#begin()
if has('nvim')
  Plug 'relastle/bluewery.vim'
  Plug 'itchyny/lightline.vim'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
  Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
  Plug 'alvan/vim-closetag'
  Plug 'NLKNguyen/papercolor-theme'
  Plug 'ntpeters/vim-better-whitespace'
  Plug 'iCyMind/NeoSolarized'
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
call plug#end()

colorscheme PaperColor

let g:deoplete#enable_at_startup = 1
let g:indentLine_char = '¦'
let g:closetag_filenames = "*.html,*.xhtml,*.phtml"
let g:one_allow_italics = 1
let g:lightline = { 'colorscheme': 'PaperColor' }
