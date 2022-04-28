function! GrTooltip()
  let currentWord = expand('<cword>')
  let filename = expand('~/.GrTooltip/'.currentWord)
  if filereadable(filename)
    let contents = readfile(filename)
    call popup_create(contents, #{
          \ title: ' GrTooltip ', 
          \ padding: [0,1,0,1],
          \ drag: 1,
          \ border: [],
          \ close: 'click'
          \ })
  endif
endfunction
command GrTooltip :call GrTooltip()

nmap <C-G><C-T> GrTooltip<CR> 

" SO_BSDCOMPAT
