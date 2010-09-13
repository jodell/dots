" Colors
colors inkpot
syntax on                 " Enable syntax highlighting

filetype plugin indent on " Enable filetype-specific indenting and plugins
set backspace=indent,eol,start
set nocompatible          " We're running Vim, not Vi!
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

set term=ansi
set t_Co=256

" Key Mappings
"map <F5> :!ruby %<CR>
noremap ,e :!ruby %<CR>
noremap ,w :w!<CR>
noremap ,x :x!<CR>
noremap ,q :qa<CR>
noremap ,g :!!<CR>
noremap ,c :!cucumber --format pretty %<CR>
noremap ,r :!rake %<CR>
noremap ,, :!! %<CR>

" NERD Tree
"noremap t :NERDTreeToggle
noremap ,t :execute 'NERDTreeToggle'<CR> 
autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p

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


" Map ctrl-j to escape for more home row action!
:imap <C-j> <Esc>

" History
set backup
set backupdir=~/.vim/backup
set directory=~/.vim/tmp

" Folding
set foldenable
set foldmethod=syntax
set foldlevel=100

au BufWinLeave * mkview " Automatically load/save folding views
au BufWinEnter * silent loadview


" Highlight > 80 cols
" http://stackoverflow.com/questions/235439/vim-80-column-layout-concerns
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/

