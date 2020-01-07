
""============================================================================""
"                             *** REMAPPING ***                                "
""============================================================================""

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

Plugin 'joshdick/onedark.vim' " Vim theme
Plugin 'ntpeters/vim-better-whitespace' " Use to remove trailing space
Plugin 'vim-airline/vim-airline' " Colorfull powerline
Plugin 'vim-airline/vim-airline-themes' " Theme for vim-airline
"Plugin 'preservim/nerdtree'
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'Raimondi/delimitMate'

call vundle#end()

set t_Co=256 " Set vim to support 256 colors
colorscheme onedark " Set colorscheme to onedark
let g:airline_theme='luna' " Set theme powerline

"NERDTree
let g:NERDTreeWinSize=42
let g:NERDTreeNaturalSort=1


""============================================================================""
"                             *** UI Layout ***                                "
""============================================================================""

" Tabs and spaces
set expandtab " Replace tabs with spaces
set tabstop=4 " Number of visual spaces per TAB
set shiftwidth=4 " Indent a line with 4 space
set softtabstop=4 " Number of spaces in tab when editing

syntax on
set number " Show line numbers
set relativenumber " Set the number to be displayed relatively to your position
set showmatch " Highlight matching [{()}]
set autoindent " Keep indentation when going to new line
set smartindent " Activate smart indentaton among the language
filetype plugin indent on " Load filetype-specific indent files
set colorcolumn=80

set nocompatible " Removed compatibility with VI
set encoding=utf-8

"
""============================================================================""
"                             *** Functions ***                                "
""============================================================================""

" toggle between number and relativenumber
function! ToggleNumber()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunc


""============================================================================""
"                             *** REMAPPING ***                                "
""============================================================================""

" Replace default hjkl with jkl; for better finger position
noremap ; l
noremap l k
noremap k j
noremap j h

" Add usefull shortcut in the F key
" Qui and save
map <F4> :x <CR>
" Remove all trailling space
map <F6> :StripWhitespace <CR>
" Reindent all the file
map <F7> gg=G <CR>
" Quit without saving
map <F8> :q! <CR>
" Launch the plugin install
map <F9> :PluginInstall <CR>
" Switch between relative number and absolute number
map <F10> :call ToggleNumber() <CR>

" NERDTree
map <C-n> :NERDTreeFocus <CR>
map <C-m> :NERDTreeClose <CR>
