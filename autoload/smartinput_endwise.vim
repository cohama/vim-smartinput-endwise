function! smartinput_endwise#define_default_rules()
  call s:initialize()

  " vim-rules {{{
  for at in ['fu', 'fun', 'func', 'funct', 'functi', 'functio', 'function', 'if', 'wh', 'whi', 'whil', 'while', 'for', 'try']
    call s:define_vim_rule(at)
  endfor
  unlet at
  " }}}

  " ruby-rules {{{
  call s:define_rule('ruby', '^\s*\%(module\|def\|class\|if\|unless\|for\|while\|until\|case\)\>\%(.*[^.:@$]\<end\>\)\@!.*\%#', 'end', '')
  call s:define_rule('ruby', '^\s*\%(begin\)\s*\%#', 'end', '')
  call s:define_rule('ruby', '\%(^\s*#.*\)\@<!do\%(\s*|\k\+|\)\?\s*\%#', 'end', '')
  call smartinput#define_rule({
  \ 'at': '\<\%(if\|unless\)\>.*\%#',
  \ 'char': '<CR>',
  \ 'input': s:cr_key . 'end<Esc>O',
  \ 'filetype': ['ruby'],
  \ 'syntax': ['rubyConditionalExpression']
  \ })
  " }}}

  " sh rules {{{
  call s:define_rule('sh', '^\s*if\>.*\%#', 'fi', '')
  call s:define_rule('sh', '^\s*case\>.*\%#', 'esac', '')
  call s:define_rule('sh', '\%(^\s*#.*\)\@<!do\>.*\%#', 'done', '')
  " }}}
endfunction

function! s:initialize()
  if !exists('g:smartinput_endwise_avoid_neocon_conflict')
    let g:smartinput_endwise_avoid_neocon_conflict = 1
  endif
  let s:cr_key = '<C-r>=smartinput_endwise#_avoid_conflict_cr()<CR>'
  call smartinput#define_rule({'at': '\%#', 'char': '<CR>', 'input': s:cr_key})
endfunction

function! smartinput_endwise#_avoid_conflict_cr()
  if exists('*neocomplete#close_popup') && g:smartinput_endwise_avoid_neocon_conflict
    return "\<C-r>=neocomplete#close_popup()\<CR>\<CR>"
  elseif exists('*neocomplcache#close_popup()') && g:smartinput_endwise_avoid_neocon_conflict
    return "\<C-r>=neocomplcache#close_popup()\<CR>\<CR>"
  else
    return "\<CR>"
  endif
endfunction

function! s:define_vim_rule(at_word)
  call s:define_rule('vim', '^\s*'. a:at_word . '\>.*\%#', 'end' . a:at_word, '')
endfunction

function! s:define_rule(filetype, pattern, end, ignore_syntax)
  let rule = {
  \ 'at': a:pattern,
  \ 'char': '<CR>',
  \ 'input': s:cr_key . a:end . '<Esc>O'
  \ }

  if type(a:filetype) == type('')
    let rule.filetype = [a:filetype]
  elseif type(a:filetype) == type([])
    let rule.filetype = a:filetype
  endif
  call smartinput#define_rule(rule)

  if !empty(a:ignore_syntax)
    let ignore_rule = copy(rule)
    if type(a:syntax) == type('')
      let ignore_rule.syntax = [a:ignore_syntax]
    elseif type(a:syntax) == type([])
      let ignore_rule.syntax = a:ignore_syntax
    end
    let ignore_rule.input = s:cr_key
    call smartinput#define_rule(ignore_rule)
  endif
endfunction
