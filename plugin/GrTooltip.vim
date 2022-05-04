if exists('g:gr_tooltip_loaded') || &compatible
  finish
endif

if version < 800
  echohl WarningMsg
  echom  "GrTooltip requires Vim >= 8.0"
  echohl None
  finish
endif

" if !exists("g:UltiSnipsPMDebugBlocking")
" let g:UltiSnipsPMDebugBlocking = 0
" endif

" Loaded flag
let g:gr_tooltip_loaded = 1

" Use an alternative filetype
let g:gr_tooltip_filetype_remap = { 'c': 'cpp' }

" Folder to store tooltip files
let g:gr_tooltip_folder='~/.GrTooltip'

" Default for undefined filetype
let g:gr_tooltip_default_filetype = 'cpp'

" Return an alternative filetype if it's specified in
" gr_tooltip_filetype_remap
function! GrTooltipFiletype()
  if len(&filetype) == 0
    return g:gr_tooltip_default_filetype
  endif
  let l:filetype = get(g:gr_tooltip_filetype_remap, &filetype, &filetype)
  return l:filetype
endfunction

" Return tooltip filename
function! GrTooltipFilename()
  let l:currentWord = expand('<cword>')
  let l:filetype = GrTooltipFiletype()
  let l:filename = expand(g:gr_tooltip_folder.'/'.l:filetype.'/'.currentWord)
  return l:filename
endfunction

" Show tooltip
function! GrTooltip()
  let l:filename = GrTooltipFilename()
  if filereadable(l:filename)
    let l:contents = readfile(l:filename)
    call popup_create(l:contents, #{
          \ title: ' geraldolsribeiro/GrTooltip.vim ',
          \ padding: [0,1,0,1],
          \ drag: 1,
          \ border: [],
          \ close: 'click'
          \ })
  else
    echomsg l:filename." not found!"
  endif
endfunction

" Create folder to store new tooltips
function! GrTooltipCreateFolder()
  let l:filetype = GrTooltipFiletype()
  let l:foldername = expand(g:gr_tooltip_folder.'/'.l:filetype)
  call mkdir(foldername, "p", 0o700)
endfunction

" Open tooltip file to edit
function! GrTooltipEdit()
  GrTooltipCreateFolder()
  let l:filename = GrTooltipFilename()
  execute "edit +3 ".fnameescape(l:filename)
endfunction

function! GrTooltipAppend()
  let l:filename = GrTooltipFilename()
  " https://stackoverflow.com/questions/23089736/how-do-i-append-text-to-a-file-with-vim-script
  new
  setlocal buftype=nofile bufhidden=hide noswapfile nobuflisted
  normal! "+p
  execute "w >>" l:filename
  q
  echomsg "Clipboard text appended to ".l:filename
endfunction

command GrTooltip :call GrTooltip()
nnoremap <C-G><C-T> :call GrTooltip()<CR>

command GrTooltipEdit :call GrTooltipEdit()
nnoremap <C-G><C-O> :call GrTooltipEdit()<CR>

command GrTooltipAppend :call GrTooltipAppend()<CR>
nnoremap <C-G><C-A> :call GrTooltipAppend()<CR>

