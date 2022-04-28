if exists('g:loaded_gr_tooltip') || &compatible
  finish
endif
let g:loaded_gr_tooltip = 1

" Folder to store tooltip files
let g:gr_tooltip_folder='~/.GrTooltip/'

function! GrTooltip()
  let l:currentWord = expand('<cword>')
  let l:filename = expand(g:gr_tooltip_folder.currentWord)
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
    echomsg l:currentWord." not found!"
  endif
endfunction

function! GrTooltipEdit()
  let l:currentWord = expand('<cword>')
  let l:filename = expand(g:gr_tooltip_folder.currentWord)
  execute "edit +3 ".fnameescape(l:filename)
endfunction

command GrTooltip :call GrTooltip()
nnoremap <C-G><C-T> :call GrTooltip()<CR>

command GrTooltipEdit :call GrTooltipEdit()
nnoremap <C-G><C-O> :call GrTooltipEdit()<CR>
