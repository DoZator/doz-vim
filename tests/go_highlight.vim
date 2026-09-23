" Run from the repository: vim -Nu NONE -i NONE -n -es -S tests/go_highlight.vim
set nocompatible
let s:root = fnamemodify(expand('<sfile>:p'), ':h:h')
execute 'set runtimepath^=' . fnameescape(s:root)
execute 'set runtimepath^=' . fnameescape(s:root . '/plugged/vim-go')
execute 'set runtimepath+=' . fnameescape(s:root . '/after')
for s:setting in readfile(s:root . '/vimrc')
  if s:setting =~# '^let g:go_highlight_'
    execute s:setting
  endif
endfor
set termguicolors
syntax on
colorscheme base16-ocean
execute 'edit ' . fnameescape(s:root . '/tests/fixtures/highlight.go')
setfiletype go

function! s:Check(line, token, color) abort
  let l:lnum = match(getline(1, '$'), '\V' . escape(a:line, '\')) + 1
  call assert_true(l:lnum > 0, 'Missing fixture line: ' . a:line)
  let l:col = match(getline(l:lnum), '\V' . escape(a:token, '\')) + 1
  call assert_true(l:col > 0, 'Missing token: ' . a:token)
  let l:id = synID(l:lnum, l:col, 1)
  call assert_equal(a:color, synIDattr(synIDtrans(l:id), 'fg#'),
        \ a:line . ': ' . a:token . ' (' . synIDattr(l:id, 'name') . ')')
endfunction

function! s:CheckAll() abort
  call s:Check('package usecase', 'package', '#b48ead')
  call s:Check('package usecase', 'usecase', '#c1c1c1')
  call s:Check('DictName: authConsts.', 'authConsts', '#c1c1c1')
  call s:Check('DictName: authConsts.', 'DictNameTsoidCountry', '#52b2ac')
  call s:Check('dict, err :=', 'dict', '#bf616a')
  call s:Check('dict, err :=', '&dictionary', '#c1c1c1')
  call s:Check('dict, err :=', 'dictionary.', '#c1c1c1')
  call s:Check('dict, err :=', 'DictGetByNameReq', '#ebcb8b')
  call s:Check('dict, err :=', 'DictGetByName(', '#8fa1b3')
  call s:Check('const kLoginParam', 'kLoginParam', '#52b2ac')
  call s:Check('type AuthLogin', 'AuthLogin', '#ebcb8b')
  for l:field in ['NameAbis', 'CodeAbis', 'Nested', 'Enabled', 'First', 'Last']
    call s:Check(l:field, l:field, '#8fa1b3')
  endfor
  call s:Check('NameAbis string', 'string', '#ebcb8b')
  call s:Check('NameAbis string', 'json:', '#a3be8c')
  call s:Check('var plainName string', 'plainName', '#bf616a')
  call s:Check('var countryData struct', 'countryData', '#bf616a')
  call s:Check('type Named struct', 'Label', '#8fa1b3')
  call s:Check('type Named struct', 'Count', '#8fa1b3')
  call s:Check('const index = iota', 'iota', '#d08770')
  for l:token in ['return', 'nil', 'NameAbis']
    call s:Check('// return nil NameAbis', l:token, '#65737e')
    call s:Check('var words =', l:token, '#a3be8c')
  endfor
  for l:token in ['u *', 'GetCountryCodeByName']
    call s:Check('func (u *useCasesImpl)', l:token, '#8fa1b3')
  endfor
  call s:Check('func (u *useCasesImpl)', 'useCasesImpl', '#ebcb8b')
  call s:Check('func (u *useCasesImpl)', 'countryName', '#bf616a')
  call s:Check('resp, err :=', 'dictionary.', '#c1c1c1')
  for l:token in ['resp', 'err', 'ctx']
    call s:Check('resp, err :=', l:token, '#bf616a')
  endfor
  for l:token in ['u.', 'Providers', 'Dictionary', 'DocGetListByFilter(']
    call s:Check('resp, err :=', l:token, '#8fa1b3')
  endfor
  call s:Check('DictId: dict.Dict.Id', 'dict', '#bf616a')
  for l:token in ['DictId', 'Dict.', 'Id,']
    call s:Check('DictId: dict.Dict.Id', l:token, '#8fa1b3')
  endfor
  call s:Check('Filters:', 'Filters', '#8fa1b3')
  call s:Check('Value: strings.ToUpper(countryName)', 'countryName', '#bf616a')
  call s:Check('Value: strings.ToUpper(countryName)', 'ToUpper', '#8fa1b3')
  call s:Check('if err != nil', 'err', '#bf616a')
  call s:Check('if err != nil', 'if', '#b48ead')
  call s:Check('if err != nil', 'nil', '#b48ead')
  call s:Check('return "", fmt.Errorf', 'return', '#b48ead')
  for l:token in ['countryName,', 'err)']
    call s:Check('failed to query country-tsoid dictionary for country name', l:token, '#bf616a')
  endfor
  call s:Check('if len(resp.List)', 'len', '#8fa1b3')
  call s:Check('if len(resp.List)', 'resp', '#bf616a')
  call s:Check('if len(resp.List)', 'List', '#8fa1b3')
  call s:Check('// u err countryName', 'u err', '#65737e')
  call s:Check('text := "u err countryName', 'u err', '#a3be8c')
  call s:Check('client.Send()', 'client', '#8fa1b3')
  call s:Check('func (u *Service) Inline()', 'u)', '#8fa1b3')
  " Same identifier in unrelated functions is an ordinary variable.
  for l:name in ['ordinary', 'another']
    let l:start = search('^func ' . l:name . '(', 'nw')
    for l:lnum in [l:start, l:start + 1]
      let l:col = match(getline(l:lnum), '\<u\>') + 1
      call assert_equal('#bf616a', synIDattr(synIDtrans(synID(l:lnum, l:col, 1)), 'fg#'))
    endfor
  endfor
endfunction

call s:CheckAll()
colorscheme base16-ocean
call s:CheckAll()
set syntax=go
call s:CheckAll()
" Receiver rules must follow edits without reopening the buffer.
let s:receiver_line = search('^func (client ', 'nw')
call setline(s:receiver_line, substitute(getline(s:receiver_line), 'client', 'service', ''))
call setline(s:receiver_line + 1, substitute(getline(s:receiver_line + 1), 'client', 'service', ''))
doautocmd TextChanged
call s:Check('service.Send()', 'service', '#8fa1b3')
" Import aliases and their selector rules must also follow edits.
for s:lnum in range(1, line('$'))
  call setline(s:lnum, substitute(getline(s:lnum), '\<authConsts\>', 'securityConstants', 'g'))
endfor
doautocmd TextChanged
call s:Check('DictName: securityConstants.', 'securityConstants', '#c1c1c1')
call s:Check('DictName: securityConstants.', 'DictNameTsoidCountry', '#52b2ac')
call append(line('$'), ['// securityConstants.DictNameTsoidCountry &dictionary.DictGetByNameReq{}', 'var literal = "securityConstants.DictNameTsoidCountry &dictionary.DictGetByNameReq{}"', 'func example() {', '    securityConstants.Load()', '    _ = &dictionary.DictGetByNameReq{}', '}'])
doautocmd TextChanged
call s:Check('// securityConstants.', 'DictNameTsoidCountry', '#65737e')
call s:Check('var literal =', 'DictNameTsoidCountry', '#a3be8c')
call s:Check('securityConstants.Load()', 'Load', '#8fa1b3')
call s:Check('_ = &dictionary.', '&dictionary', '#c1c1c1')
call s:Check('_ = &dictionary.', 'DictGetByNameReq', '#ebcb8b')
if !empty(v:errors)
  for s:error in v:errors
    echom s:error
  endfor
  cquit
endif
qa!
