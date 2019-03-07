set nocompatible

filetype off                  " required
let mapleader = ","

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim' " Plugin Manager
Plugin 'christoomey/vim-tmux-navigator' " Use same shortcuts for changing tmux and vim panes
Plugin 'scrooloose/nerdtree' " File-Tree manager
" Plugin 'scrooloose/syntastic' " Syntax check
Plugin 'kien/ctrlp.vim' " use Ctrl+P for fuzzy file opening
Plugin 'tpope/vim-fugitive' " manage git
Plugin 'tmux-plugins/vim-tmux' " tmux.conf file highlight
Plugin 'benmills/vimux' " open tmux panes from vim
Plugin 'bling/vim-airline' " much prettier statusbar
Plugin 'vim-airline/vim-airline-themes'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'tpope/vim-surround'
Plugin 'LaTeX-Box-Team/LaTeX-Box'
" Plugin 'Valloric/YouCompleteMe'
" Plugin 'rdnetto/YCM-Generator'
" All of your Plugins must be added before the following line
call vundle#end()

" Enable syntax highlighting
syntax on
filetype plugin indent on

" Colorscheme see https://github.com/hukl/Smyck-Color-Scheme
color smyck

" Add line numbers
set number
set ruler

" Set encoding
set encoding=utf-8

" Whitespace stuff
set nowrap
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" Show trailing spaces and highlight hard tabs
set list listchars=tab:»·,trail:·

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Strip trailing whitespaces on each save
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" Search related settings
set incsearch
set hlsearch

" Map uppercase Q,W to lowercase q,w commands
:command! WQ wq
:command! Wq wq
:command! W w
:command! Q q

" Map Ctrl+l to clear highlighted searches
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

" Highlight characters behind the 80 chars margin
:au BufWinEnter * let w:m2=matchadd('ColumnMargin', '\%>80v.\+', -1)

" Disable code folding
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set nofoldenable
set foldlevel=2

" Directories for swp files
set backupdir=~/.vimbackup
set directory=~/.vimbackup
" Use OSX clipboard per default
set clipboard=unnamed
" NERDTree configuration
let NERDTreeIgnore=['\.pyc$', '\.rbc$', '\~$']
" show hidden files in NERDTree
let NERDTreeShowHidden=1
map <Leader>n :NERDTreeToggle<CR>

" CtrlP configuration
let g:ctrlp_dotfiles=1
let g:ctrlp_working_path_mode = 'ra'

" CtrlP ignore patterns
let g:ctrlp_custom_ignore = {
            \ 'dir': '\.git$\|node_modules$\|\.hg$\|\.svn$',
            \ 'file': '\.exe$\|\.so$'
            \ }

" Syntastic Configuration
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0


" use <leader>m to run make in a tmux pane
nmap <leader>m :call VimuxRunCommand("")<CR>
" nmap <leader>M :call VimuxRunCommand("clear; vassh make")<CR>

" airline configuration

let g:airline_powerline_fonts=0
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_solarized_bg='dark'
" always enable status bar
set laststatus=2

" make uses real tabs
au FileType make set noexpandtab

" Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru}    set ft=ruby

" add json syntax highlighting
au BufNewFile,BufRead *.json set ft=javascript

" make Python follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
au FileType python set softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79

if( exists('+python') && v:version > 703)
" You Complete Me autocompletion
let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"
endif
" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" ctrp custom ignores
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.hg$\|\.svn$\|\.eunit$',
  \ 'file': '\.exe$\|\.so$\|\.dll\|\.beam$\|\.DS_Store$'
  \ }

au FocusLost * :wa

" latexbox
let g:LatexBox_show_warnings=0
let g:LatexBox_ignore_warnings=[
      \ 'Package caption Warning',
      \ 'Package hyperref Warning',
      \ ]
autocmd FileType tex :nmap <Leader>ll \ll
let g:LatexBox_latexmk_preview_continuously = 1
let g:LatexBox_latexmk_options = '-pvc'
let g:LatexBox_viewer = "open -a Skim"

" autocomplete settings
set completeopt=longest,menuone
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'


" split opening
set splitbelow
set splitright

set mouse=a
