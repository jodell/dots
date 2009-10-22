set ruler
"set foldmethod=syntax
"colors ron
colors inkpot
set sw=2 sts=2 et ai
set hlsearch

set term=ansi
set t_Co=256
set hlsearch
set incsearch
"map <F5> :!ruby %<CR>
noremap ,e :!ruby %<CR>

set nocompatible          " We're running Vim, not Vi!
syntax on                 " Enable syntax highlighting
filetype plugin indent on " Enable filetype-specific indenting and plugins

" Load matchit (% to bounce from do to end, etc.)
runtime! macros/matchit.vim

augroup myfiletypes
  " Clear old autocmds in group
  autocmd!
  " autoindent with two spaces, always expand tabs
  autocmd FileType rspec,ruby,eruby,yaml,rake set ai sw=2 sts=2 et
augroup END

"noremap t :NERDTreeToggle
noremap ,t :execute 'NERDTreeToggle'<CR>
"set nonumber

"ruby
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
"improve autocomplete menu color
highlight Pmenu ctermbg=238 gui=bold

"Map ctrl-j to escape for more home row action!
:imap <C-j> <Esc>


