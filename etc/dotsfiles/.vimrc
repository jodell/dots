
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basic Setup

" Colors
syntax on
colors inkpot
set term=ansi
set t_Co=256

filetype plugin indent on " Enable filetype-specific indenting and plugins
set backspace=indent,eol,start
set nocompatible          
set sw=2 sts=2 et ai
set whichwrap=b,s,h,l
set wildmenu
set wildmode=list:longest
"set list
set nostartofline " restart at last cursor position - YAY!
set scrolloff=10  " keep 10 lines above and below position
set showcmd
set showmatch
set ruler
set hlsearch
set incsearch

" File name, git branch, and line & col position
set laststatus=2
set statusline=%F\ <%{GitBranch()}>\ %l,%v

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key Mappings
"
let mapleader = ","
noremap ,e :!ruby %<CR>
noremap ,w :w!<CR>
noremap ,x :x!<CR>
noremap ,q :qa<CR>
noremap ,c :!cucumber --format pretty %<CR>
noremap ,r :!rake %<CR>
noremap ,g :!!<CR>
noremap ,, :!! %<CR>
" Run the cucumber scenario under the cursor <3
noremap ,f :execute "!cucumber --format pretty %:".line('.')<CR>

" NERd Tree
noremap ,t :execute 'NERDTreeToggle'<CR> 
autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p

" Map ctrl-j to escape for more home row action!
:imap <C-j> <Esc>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Filetypes - Move Me
" Load matchit (% to bounce from do to end, etc.)
runtime! macros/matchit.vim

augroup myfiletypes
  " Clear old autocmds in group
  autocmd!
  " autoindent with two spaces, always expand tabs
  autocmd FileType rspec,ruby,eruby,yaml,rake set ai sw=2 sts=2 et
augroup END

" ruby
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
"improve autocomplete menu color
highlight Pmenu ctermbg=238 gui=bold
augroup mkd
  autocmd BufRead *.mkd,*.md  set ai formatoptions=tcroqn2 comments=n:&gt;
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" History
set backup
set backupdir=~/.vim/backup
set directory=~/.vim/tmp

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Folding
set foldenable
set foldmethod=syntax
set foldlevel=100
au BufWinLeave * silent! mkview " Automatically load/save folding views
au BufWinEnter * silent! loadview

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Misc 
"
" Highlight > 80 cols
" http://stackoverflow.com/questions/235439/vim-80-column-layout-concerns
if has("colorcolumn")
  set colorcolumn=80
else
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif


" gist-vim
let g:gist_clip_command = 'pbcopy'
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1

