" Bare identifiers in expressions. Keywords retain Vim's keyword priority;
" leave declaration prefixes, calls and composite types to vim-go's matches.
syntax match goVariable /\<\%(func\>\|type\>\|var\>\|const\>\|import\>\)\@!\h\w*\>\%(\s*[(\[{]\)\@!/

" Selector members and keyed struct fields; := is a variable declaration.
syntax match goField /\%(\.\s*\)\@<=\h\w*/
syntax match goFieldKey /\<\h\w*\>\ze\s*:\%([=]\)\@!/
syntax match goQualifiedType /\%(\.\s*\)\@<=\h\w*\ze\s*{/

" Field declarations belong to struct bodies, not ordinary variable declarations.
" TOP keeps normal Go syntax active; nested structs get their own field scope.
syntax region goStructBody matchgroup=goStructDelimiter transparent start=/\%(\<struct\_s*\)\@<={/ end=/}/ contains=TOP
syntax match goStructField /\%(^\s*\|[;{]\s*\)\@<=\h\w*\%(\s*,\s*\h\w*\)*\ze\s\+\%(\h\|[*[<]\)/ contained containedin=goStructBody

" Separate these words from the other statements and predefined identifiers.
syntax keyword goReturn return
syntax keyword goNil nil

" Extend vim-go with constant declaration names (not the const keyword).
" Keep this separate from the colorscheme so syntax reloads retain the rules.
syntax match goConstant /\%(\<const\s\+\)\@<=\h\w*\%(\s*,\s*\h\w*\)*/
syntax match goConstant /^\s*\zs\h\w*\%(\s*,\s*\h\w*\)*/ contained containedin=goConst

" Provide a fallback when another colorscheme is selected.
highlight default link goConstant Constant
highlight default link goVariable Identifier
highlight default link goFieldKey Function
highlight default link goReceiverUse goReceiverVar
highlight default link goPackageName Normal
highlight default link goQualifiedType Type
highlight default link goImportedConstant goConstant
highlight default link goStructField goField
highlight default link goStructDelimiter Normal
highlight default link goReturn Keyword
highlight default link goNil Keyword

" Read gofmt-style imports rather than treating every selector root as a
" package: dict.Dict.Id still starts with an ordinary variable.
function! s:HighlightPackages() abort
  silent! syntax clear goPackageName
  silent! syntax clear goImportedConstant
  syntax match goPackageName /\%(^package\s\+\)\@<=\h\w*/
  let l:packages = []
  for l:lnum in range(1, line('$'))
    let l:line = getline(l:lnum)
    let l:spec = matchlist(l:line, '^\s*\%(import\s\+\)\?\%(\(\h\w*\|[._]\)\s\+\)\?"\([^"]\+\)"')
    if empty(l:spec)
      continue
    endif
    let l:col = match(l:line, '"') + 1
    if synIDattr(synID(l:lnum, l:col, 1), 'name') !=# 'goImportString'
      continue
    endif
    let l:name = empty(l:spec[1]) ? fnamemodify(l:spec[2], ':t') : l:spec[1]
    if l:name =~# '^\h\w*$' && l:name !=# '_'
      call add(l:packages, l:name)
    endif
  endfor
  for l:name in uniq(sort(l:packages))
    " Include & in an address-of composite literal, as in &dictionary.Request{}.
    execute 'syntax match goPackageName /&\?\<' . l:name . '\>\ze\s*\./ containedin=goParamType'
    " Syntax alone cannot identify imported constants. Use the project's
    " Consts/Constants naming convention; allow other aliases via vimrc.
    if l:name =~? '\%(consts\|constants\)$'
          \ || index(get(g:, 'doz_go_constant_packages', []), l:name) >= 0
      execute 'syntax match goImportedConstant /\%(\<' . l:name . '\>\s*\.\s*\)\@<=[A-Z]\w*\>\%(\s*[(\[{]\)\@!/'
    endif
  endfor
endfunction

" Track receiver names within gofmt-style method bodies. Restrict matches to
" each method so an ordinary variable with the same name elsewhere stays red.
function! s:HighlightReceivers() abort
  silent! syntax clear goReceiverUse
  let l:receiver = ''
  let l:start = 0
  let l:patterns = []
  for l:lnum in range(1, line('$'))
    let l:line = getline(l:lnum)
    if l:line =~# '^func\>' && !empty(l:receiver)
          \ && synIDattr(synID(l:lnum, 1, 1), 'name') ==# 'goDeclaration'
      call add(l:patterns, '\%>' . (l:start - 1) . 'l\%<' . l:lnum . 'l\<' . l:receiver . '\>')
      let l:receiver = ''
    endif
    let l:decl = matchlist(l:line, '^func\s*(\s*\(\h\w*\)\s\+')
    if !empty(l:decl)
      let l:col = match(l:line, '\<func\>') + 1
      if synIDattr(synID(l:lnum, l:col, 1), 'name') ==# 'goDeclaration'
        let l:receiver = l:decl[1]
        let l:start = l:lnum
      endif
    endif
    if !empty(l:receiver) && (l:line =~# '^}' || (!empty(l:decl) && l:line =~# '}\s*$'))
      let l:col = match(l:line, '}\s*$') + 1
      let l:group = synIDattr(synID(l:lnum, max([1, l:col]), 1), 'name')
      if l:group !~# 'Comment\|String'
        call add(l:patterns, '\%>' . (l:start - 1) . 'l\%<' . (l:lnum + 1) . 'l\<' . l:receiver . '\>')
        let l:receiver = ''
      endif
    endif
  endfor
  if !empty(l:receiver)
    call add(l:patterns, '\%>' . (l:start - 1) . 'l\<' . l:receiver . '\>')
  endif
  for l:pattern in l:patterns
    execute 'syntax match goReceiverUse /' . l:pattern . '/'
  endfor
endfunction

call s:HighlightPackages()
call s:HighlightReceivers()
augroup doz_go_receivers
  autocmd! * <buffer>
  autocmd TextChanged,TextChangedI <buffer> call <SID>HighlightPackages() | call <SID>HighlightReceivers()
augroup END
