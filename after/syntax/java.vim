" Java identifiers follow the conventional TypeName / variableName casing.
" Leave match-based keywords to Vim; syntax keywords already take priority.
syntax match javaOceanVariable /\<\%(import\>\|class\>\|record\>\|permits\>\|var\>\|yield\>\|sealed\>\|default\>\)\@![a-z_$][[:alnum:]_$]*\>/
syntax match javaOceanType /\<[A-Z][[:alnum:]_$]*\>/
syntax match javaOceanMethod /\<[a-z_$][[:alnum:]_$]*\>\ze\s*(/
syntax match javaOceanImportPath /\%(\<import\s\+\%(static\s\+\)\?\)\@<=[[:alnum:]_$.*]\+/ containedin=javaImportDeclBlock
syntax match javaOceanPackagePath /\%(\<package\s\+\)\@<=[[:alnum:]_$.]\+/
" Class-qualified calls are yellow; argument identifiers keep their own colors.
syntax match javaOceanStaticCall /\<[A-Z][[:alnum:]_$]*\s*\.\s*[[:alpha:]_$][[:alnum:]_$]*\ze\s*(/
syntax match javaOceanStaticCall /\<[A-Z][[:alnum:]_$]*\s*\.\s*[[:alpha:]_$][[:alnum:]_$]*\s*(\s*)/

" Keep identifiers visible with Vim's optional method-signature highlighting.
syntax cluster javaFuncParams add=javaOceanVariable,javaOceanType
syntax cluster javaClasses add=javaOceanType

highlight default link javaOceanVariable Identifier
highlight default link javaOceanType Type
highlight default link javaOceanImportPath Type
highlight default link javaOceanStaticCall Type
highlight default link javaOceanField Function
highlight default link javaOceanMethod Function
highlight default link javaOceanPackagePath Normal

" Collect field names at class-body depth, excluding locals inside methods.
" This is syntax-based: a local that shadows a field shares its field color.
function! s:HighlightFields() abort
  silent! syntax clear javaOceanField
  let l:depth = 0
  let l:classes = []
  let l:pending_class = 0
  let l:fields = []
  for l:lnum in range(1, line('$'))
    let l:line = getline(l:lnum)
    if !empty(l:classes) && l:depth == l:classes[-1]
      let l:name = matchstr(l:line, '^\s*\%(\%(public\|protected\|private\|static\|final\|transient\|volatile\)\s\+\)*[[:alpha:]_$][[:alnum:]_$.]*\%(<[^;=()]*>\)\?\%(\s*\[\s*\]\)*\s\+\zs[[:alpha:]_$][[:alnum:]_$]*\ze\s*[;=,\[]')
      if !empty(l:name)
        let l:col = match(l:line, '\<' . l:name . '\>') + 1
        if synIDattr(synID(l:lnum, l:col, 1), 'name') !~# 'Comment\|String\|Character\|TextBlock'
          call add(l:fields, l:name)
        endif
      endif
    endif
    let l:offset = 0
    while 1
      let [l:token, l:start, l:end] = matchstrpos(l:line, '\<\%(class\|interface\|enum\|record\)\>\|[{}]', l:offset)
      if l:start < 0
        break
      endif
      let l:offset = l:end
      if synIDattr(synID(l:lnum, l:start + 1, 1), 'name') =~# 'Comment\|String\|Character\|TextBlock'
        continue
      endif
      if l:token ==# '{'
        let l:depth += 1
        if l:pending_class
          call add(l:classes, l:depth)
          let l:pending_class = 0
        endif
      elseif l:token ==# '}'
        if !empty(l:classes) && l:classes[-1] == l:depth
          call remove(l:classes, -1)
        endif
        let l:depth = max([0, l:depth - 1])
      elseif strpart(l:line, 0, l:start) !~# '\.\s*$'
        let l:pending_class = 1
      endif
    endwhile
  endfor
  for l:name in uniq(sort(l:fields))
    execute 'syntax match javaOceanField /\<' . l:name . '\>\%(\s*(\)\@!/'
  endfor
endfunction

call s:HighlightFields()
augroup doz_java_fields
  autocmd! * <buffer>
  autocmd TextChanged,TextChangedI <buffer> call <SID>HighlightFields()
augroup END
