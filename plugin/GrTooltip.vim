if exists('g:loaded_gr_tooltip') || &compatible
  finish
endif

if version < 800
  echohl WarningMsg
  echom  "GrTooltip requires Vim >= 8.0"
  echohl None
  finish
endif

let g:loaded_gr_tooltip = 1

" Folder to store tooltip files
let g:gr_tooltip_folder='~/.GrTooltip'

function! GrTooltipFilename()
  let l:currentWord = expand('<cword>')
  let l:filetype = &filetype
  let l:filename = expand(g:gr_tooltip_folder.'/'.filetype.'/'.currentWord)
  return l:filename
endfunction

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

function! GrTooltipEdit()
  let l:filename = GrTooltipFilename()
  let l:filetype = &filetype
  let l:foldername = expand(g:gr_tooltip_folder.'/'.filetype)
  call mkdir(foldername, "p", 0o700)
  execute "edit +3 ".fnameescape(l:filename)
endfunction

command GrTooltip :call GrTooltip()
nnoremap <C-G><C-T> :call GrTooltip()<CR>

command GrTooltipEdit :call GrTooltipEdit()
nnoremap <C-G><C-O> :call GrTooltipEdit()<CR>
