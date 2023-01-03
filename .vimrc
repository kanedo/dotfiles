" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif
"Above here are the code you just pasted in the last step
call plug#begin('~/.vim/plugged')
" YOUR PLUGINS GO HERE
" Make sure you use single quotes
" Examples of plugins installations below
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-fugitive'
Plug 'powerline/powerline'
Plug 'ap/vim-buftabline'
Plug 'airblade/vim-gitgutter'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'vim-scripts/indentpython.vim'
Plug 'sheerun/vim-polyglot'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'thomasfaingnaert/vim-lsp-ultisnips'
Plug 'morhetz/gruvbox'
Plug 'rhysd/vim-grammarous'

" Initialize plugin system
call plug#end()
"Below go the Vim scripts for even further configuration

autocmd vimenter * ++nested colorscheme gruvbox

" show line numbers
set number

map <C-n> :NERDTreeToggle<CR>
set mouse=a

" fzf finder
nnoremap <silent> <C-f> :Files<CR>

let g:buftabline_numbers = 1

"
" LSP 
" 
nnoremap <leader>dd :LspDefinition<cr>
nnoremap <leader>dn :LspNextDiagnostic<cr>
nnoremap <leader>dp :LspPreviousDiagnostic<cr>
nnoremap <leader>df :LspReferences<cr>
nnoremap <leader>dr :LspRename<cr>
nnoremap <leader>ds :LspStopServer<cr>
nnoremap <leader>dp :LspPeekDefinition<cr>
nnoremap <leader>da :LspCodeAction<cr>
nnoremap <leader>dh :LspHover<cr>
nnoremap <leader>dd :LspDefinition<cr>

" NERDTree
let NERDTreeShowHidden=1  "  Always show dot files
let NERDTreeQuitOnOpen=1

" Use installed lannguagetool
let g:grammarous#languagetool_cmd = 'languagetool'
" Grammarous only for markdown files, help files and comments
let g:grammarous#default_comments_only_filetypes = {
              \ '*' : 1, 'help' : 0, 'markdown' : 0,
                          \ }
