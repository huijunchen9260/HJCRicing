" Vim indent file
" Language:        AWK Script
" Maintainer:      Clavelito <maromomo@hotmail.com>
" Id:              $Date: 2014-01-07 12:49:27+09 $
"                  $Revision: 1.46 $


if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal indentexpr=GetAwkIndent()
setlocal indentkeys-=0#

if exists("*GetAwkIndent")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

function GetAwkIndent()
  let lnum = prevnonblank(v:lnum - 1)
  if lnum == 0
    return 0
  endif

  let cline = getline(v:lnum)
  if cline =~ '^#'
    return 0
  endif

  let line = getline(lnum)
  if  line =~ '^\s*#' && cline =~ '^\s*$'
    let ind = indent(lnum)
    return ind
  endif

  let ind = s:ContinueLineIndent(line, lnum)
  let stop = lnum
  let [line, lnum] = s:JoinContinueLine(
        \ line, lnum, '\\$\|\%(&&\|||\|,\)\s*\%(#.*\)\=$', 0)
  let [pline, pnum] = s:JoinContinueLine(
        \ line, lnum, '\\$\|\%(&&\|||\|,\)\s*\%(#.*\)\=$', 1)
  let ind = s:MorePrevLineIndent(pline, pnum, line, lnum, ind)
  let ind = s:PrevLineIndent(line, lnum, stop, ind)
  let ind = s:CurrentLineIndent(cline, line, lnum, pline, pnum, ind)

  return ind
endfunction

function s:ContinueLineIndent(line, lnum)
  let [pline, line, ind] = s:PreContinueLine(a:line, a:lnum)
  if line =~ '(\s*\%(\S\+\s*,\s*\)\+\%(#.*\)\=$'
        \ || line =~ '(\s*\%(\S\+\s*,\s*\)\+\\$'
    let ind = s:GetMatchWidth(line, '(')
    let line = substitute(line, '^.*(', '', '')
    let ind = ind + match(line, '\S') + 1
  elseif line =~ '\S\+\s*,\s*\%(#.*\)\=$' || line =~ '\S\+\s*,\s*\\$'
    let ind = s:GetMatchWidth(line, '\S\+\s*,')
  elseif line =~# '^\s*\%(function\s\+\)\=\h\w*(\s*\\$'
    let ind = s:GetMatchWidth(line, '(') + 1
  elseif line =~# '^\s*\%(if\|else\s\+if\|for\|}\=\s*while\)\>'
        \ && line =~ '\\$\|\%(&&\|||\)\s*\%(#.*\)\=$'
    let ind = ind + &sw * 2
  elseif ind && pline !~ '\\$' && line =~ '\\$'
    let ind = ind + &sw
  elseif ind && pline =~ '\\$' && line !~ '\\$\|\%(&&\|||\|,\)\s*\%(#.*\)\=$'
    let ind = ind - &sw
  endif

  return ind
endfunction

function s:MorePrevLineIndent(pline, pnum, line, lnum, ind)
  if a:line =~ '\\$\|\%(&&\|||\|,\)\s*\%(#.*\)\=$'
    return a:ind
  endif

  let [pline, pnum, ind] = s:PreMorePrevLine(a:pline, a:pnum, a:line, a:lnum)
  while pnum
        \ &&
        \ (pline =~# '^\s*\%(if\|else\s\+if\|for\|while\)\s*(.*)\s*\%(#.*\)\=$'
        \ || pline =~# '^\s*}\=\s*else\>\s*\%(#.*\)\=$'
        \ || pline =~# '^\s*do\>\s*\%(#.*\)\=$'
        \ || pline =~# '^\s*}\s*\%(else\s\+if\|while\)\s*(.*)\s*\%(#.*\)\=$')
    let ind = indent(pnum)
    if pline =~# '^\s*do\>\s*\%(#.*\)\=$'
          \ && s:NoClosedPair(pnum, '\C\<do\>', '\C\<while\>', a:lnum)
      break
    elseif pline =~# '^\s*}\=\s*else\>'
      let [pline, pnum] = s:GetIfLine(pline, pnum)
    elseif pline =~# '^\s*}\=\s*while\>'
      let [pline, pnum] = s:GetDoLine(pline, pnum, pnum)
    endif
    let [pline, pnum] = s:JoinContinueLine(
          \ pline, pnum, '\\$\|\%(&&\|||\|,\)\s*\%(#.*\)\=$', 1)
  endwhile

  return ind
endfunction

function s:PrevLineIndent(line, lnum, stop, ind)
  let ind = a:ind
  if a:line =~# '^\s*\%(if\|else\s\+if\|for\)\s*(.*)\s*{\=\s*\%(#.*\)\=$'
        \ || a:line =~# '^\s*\%(else\|do\)\s*{\=\s*\%(#.*\)\=$'
        \ || a:line =~# '^\s*}\s*else\s*{\=\s*\%(#.*\)\=$'
        \ || a:line =~# '^\s*}\s*else\s\+if\s*(.*)\s*{\=\s*\%(#.*\)\=$'
        \ || a:line =~# '^\s*while\s*(.*)\s*{\s*\%(#.*\)\=$'
        \ || a:line =~# '^\s*while\s*(.*)\s*\%(#.*\)\=$'
        \ && get(s:GetDoLine(a:line, a:lnum, a:lnum), 1) == a:lnum
        \ || a:line =~ '^\s*{\s*\%(#.*\)\=$'
    let ind = indent(a:lnum) + &sw
  elseif a:line =~# '^\s*}\=\s*while\s*(.*)\s*\%(#.*\)\=$' && a:lnum != a:stop
    let [pline, pnum] = s:GetDoLine(a:line, a:lnum, a:lnum)
    let ind = indent(pnum)
    let ind = s:MorePrevLineIndent(pline, pnum, a:line, a:lnum, ind)
  elseif a:line =~ ')\s*{\s*\%(#.*\)\=$'
    let ind = indent(get(s:GetStartPairLine(a:line, ')', '(', a:lnum), 1)) + &sw
  elseif a:line =~ '{' && s:NoClosedPair(a:lnum, '{', '}', a:stop)
    let ind = indent(a:lnum) + &sw
  elseif a:line =~ '\S\+\s*}\s*\%(#.*\)\=$'
    let ind = indent(get(s:GetStartPairLine(a:line, '}', '{', a:lnum), 1))
  elseif a:line =~# '^\s*\%(function\s\+\)\=\h\w*('
        \ && a:line =~ '\%(,\s*\)\@<!\\$' && a:lnum != a:stop
    let ind = s:GetMatchWidth(a:line, '(')
  elseif a:line =~# '^\s*\(case\|default\)\>'
    let ind = ind + &sw
  endif

  return ind
endfunction

function s:CurrentLineIndent(cline, line, lnum, pline, pnum, ind)
  let ind = a:ind
  if a:cline =~ '^\s*}'
    let ind = ind - &sw
  elseif a:cline =~ '^\s*{\s*\%(#.*\)\=$'
        \ &&
        \ (a:line =~# '^\s*\%(if\|else\s\+if\|while\|for\)\s*(.*)\s*\%(#.*\)\=$'
        \ || a:line =~# '^\s*\%(else\|do\)\s*\%(#.*\)\=$'
        \ || a:line =~# '^\s*\(case\|default\)\>.*:\s*\%(#.*\)\=$')
    let ind = ind - &sw
  elseif a:cline =~# '^\s*else\>'
    let ind = s:CurrentElseIndent(a:line, a:lnum, a:pline, a:pnum)
  elseif a:cline =~# '^\s*\(case\|default\)\>'
        \ && a:line !~ '\({\|}\)\s*\%(#.*\)\=$'
    let ind = ind - &sw
  endif

  return ind
endfunction

function s:PreContinueLine(line, lnum)
  let [line, lnum] = s:SkipCommentLine(a:line, a:lnum)
  let pnum = prevnonblank(lnum - 1)
  let pline = getline(pnum)
  let [pline, pnum] = s:SkipCommentLine(pline, pnum)
  let ind = indent(lnum)

  return [pline, line, ind]
endfunction

function s:JoinContinueLine(line, lnum, item, prev)
  if a:prev && s:GetPrevNonBlank(a:lnum)
    let lnum = s:prev_lnum
    let line = getline(lnum)
  elseif a:prev
    let lnum = 0
    let line = ""
  else
    let line = a:line
    let lnum = a:lnum
  endif
  let [line, lnum] = s:SkipCommentLine(line, lnum)
  while lnum && s:GetPrevNonBlank(lnum)
    let pline = getline(s:prev_lnum)
    if pline !~ a:item
      break
    endif
    let lnum = s:prev_lnum
    let line = pline . line
  endwhile
  unlet! s:prev_lnum

  return [line, lnum]
endfunction

function s:SkipCommentLine(line, lnum)
  let line = a:line
  let lnum = a:lnum
  while lnum && line =~ '^\s*#' && s:GetPrevNonBlank(lnum)
    let lnum = s:prev_lnum
    let line = getline(lnum)
  endwhile
  unlet! s:prev_lnum

  return [line, lnum]
endfunction

function s:GetPrevNonBlank(lnum)
  let s:prev_lnum = prevnonblank(a:lnum - 1)

  return s:prev_lnum
endfunction

function s:PreMorePrevLine(pline, pnum, line, lnum)
  let lnum = a:lnum
  if a:line =~# '^\s*}\=\s*while\>'
    let [line, lnum] = s:GetDoLine(a:line, a:lnum, a:lnum)
  elseif a:line =~# '\s*}\=\s*else\>'
    let [line, lnum] = s:GetIfLine(a:line, a:lnum)
  elseif a:line =~ '^\s*}' || a:line =~ '\S\+\s*}\s*\%(#.*\)\=$'
    let [line, lnum] = s:GetStartBraceLine(a:line, a:lnum)
  elseif a:line =~ ')\s*\%(#.*\)\=$'
    let [line, lnum] = s:GetStartPairLine(a:line, ')', '(', a:lnum)
  endif
  if lnum != a:lnum
    let [pline, pnum] = s:JoinContinueLine(
          \ line, lnum, '\\$\|\%(&&\|||\|,\)\s*\%(#.*\)\=$', 1)
  else
    let pline = a:pline
    let pnum = a:pnum
  endif
  let ind = indent(lnum)

  return [pline, pnum, ind]
endfunction

function s:GetStartBraceLine(line, lnum)
  let line = a:line
  let lnum = a:lnum
  let [line, lnum] = s:GetStartPairLine(line, '}', '{', lnum)
  if line =~# '^\s*}\=\s*else\>'
    let [line, lnum] = s:GetIfLine(line, lnum)
  endif

  return [line, lnum]
endfunction

function s:GetStartPairLine(line, item1, item2, lnum)
  let save_cursor = getpos(".")
  call cursor(a:lnum, len(a:line))
  let lnum = search(a:item1, 'cbW', a:lnum)
  while lnum && s:InsideAwkItemOrCommentStr()
    let lnum = search(a:item1, 'bW', a:lnum)
  endwhile
  if lnum
    let lnum = searchpair(
          \ a:item2, '', a:item1, 'bW', 's:InsideAwkItemOrCommentStr()')
  endif
  if lnum > 0
    let line = getline(lnum)
    if line =~ ')\s*{' && a:item1 == '}' && a:item2 == '{'
      let [line, lnum] = s:GetStartPairLine(line, ')', '(', lnum)
    endif
  else
    let line = a:line
    let lnum = a:lnum
  endif
  call setpos('.', save_cursor)

  return [line, lnum]
endfunction

function s:GetIfLine(line, lnum)
  let save_cursor = getpos(".")
  call cursor(a:lnum, 1)
  let lnum = searchpair('\C\<if\>', '', '\C\<else\>', 'bW',
        \ 'getline(".") =~# "else\\s\\+if" ' .
        \ '|| indent(line(".")) > indent(a:lnum) ' .
        \ '|| s:InsideAwkItemOrCommentStr()')
  call setpos('.', save_cursor)
  if lnum > 0
    let line = getline(lnum)
    let nnum = lnum
    while nnum && line =~ '\\$\|\%(&&\|||\)\s*\%(#.*\)\=$'
      let nnum = nextnonblank(nnum + 1)
      let nline = getline(nnum)
      let line = line . nline
    endwhile
  else
    let line = a:line
    let lnum = a:lnum
  endif

  return [line, lnum]
endfunction

function s:GetDoLine(line, lnum, snum)
  let save_cursor = getpos(".")
  call cursor(a:lnum, 1)
  let lnum = s:SearchDoLoop(a:snum)
  call setpos('.', save_cursor)
  if lnum > 0
    let line = getline(lnum)
  else
    let line = a:line
    let lnum = a:lnum
  endif

  return [line, lnum]
endfunction

function s:SearchDoLoop(snum)
  let lnum = 0
  let onum = 0
  while search('\C^\s*do\>', 'ebW')
    let save_cursor = getpos(".")
    let lnum = searchpair('\C\<do\>', '', '\C\<while\>', 'W',
          \ 'indent(line(".")) > indent(get(save_cursor, 1)) ' .
          \ '|| s:InsideAwkItemOrCommentStr()', a:snum)
    if lnum < onum || lnum < 1
      let lnum = 0
      break
    elseif lnum == a:snum
      let lnum = get(save_cursor, 1)
      break
    else
      let onum = lnum
      let lnum = 0
    endif
    call setpos('.', save_cursor)
  endwhile

  return lnum
endfunction

function s:NoClosedPair(lnum, item1, item2, stop)
  let snum = 0
  let enum = 0
  let save_cursor = getpos(".")
  call cursor(a:lnum, 1)
  let snum = search(a:item1, 'cW', a:stop)
  while snum && s:InsideAwkItemOrCommentStr()
    let snum = search(a:item1, 'W', a:stop)
  endwhile
  if snum
    let enum = searchpair(
          \ a:item1, '', a:item2, 'W', 's:InsideAwkItemOrCommentStr()')
  endif
  call setpos('.', save_cursor)

  if snum == enum
    return 0
  else
    return 1
  endif
endfunction

function s:GetMatchWidth(line, item)
  let msum = match(a:line, a:item)
  let tsum = matchend(a:line, '\t*', 0)

  return msum - tsum + tsum * &sw
endfunction

function s:CurrentElseIndent(line, lnum, pline, pnum)
  if a:line =~# '^\s*\%(if\|else\s\+if\)\s*(.*)\s*\%([^#].*\)'
        \ && a:line !~ '{\s*\%(#.*\)\=$'
    let ind = indent(a:lnum)
  elseif a:line =~# '^\s*else\>\s\+\%([^#].*\)' && a:line !~ '{\s*\%(#.*\)\=$'
    let ind = indent(a:lnum) - &sw
  elseif a:pline =~# '^\s*\%(if\|}\=\s*else\s\+if\)\s*(.*)\s*\%(#.*\)\=$'
    let ind = indent(a:pnum)
  elseif a:pline =~# '^\s*\%(}\s*\)\=else\>\s*\%(#.*\)\=$'
    let ind = indent(a:pnum) - &sw
  else
    let ind = indent(get(s:GetIfLine(a:line, a:lnum), 1))
  endif

  return ind
endfunction

function s:InsideAwkItemOrCommentStr()
  let line = getline(line("."))
  let cnum = col(".")
  let sum = match(line, '\S')
  let slash = 0
  let dquote = 0
  let bracket = 0
  while sum < cnum
    let str = strpart(line, sum, 1)
    if str == '#' && !slash && !dquote
      return 1
    elseif str == '\' && (slash || dquote) && strpart(line, sum + 1, 1) == '\'
      let str = laststr
      let sum += 1
    elseif str == '[' && (slash || dquote) && !bracket && laststr != '\'
      let bracket = 1
      if strpart(line, sum + 1, 1) == ']'
        let str = ']'
        let sum += 1
      endif
    elseif str == ']' && (slash || dquote) && bracket && laststr != '\'
      let bracket = 0
    elseif str == '/' && !slash && !dquote
          \ && (!exists("nb_laststr")
          \ || nb_laststr =~ '\%(}\|(\|\%o176\|,\|=\|&\||\|!\)')
      let slash = 1
    elseif str == '/' && slash && laststr != '\' && !bracket
      let slash = 0
    elseif str == '"' && !dquote && !slash
      let dquote = 1
    elseif str == '"' && dquote && laststr != '\' && !bracket
      let dquote = 0
    endif
    if str !~ '\s'
      let nb_laststr = str
    endif
    let laststr = str
    let sum += 1
  endwhile

  if slash || dquote
    return 1
  else
    return 0
  endif
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: set sts=2 sw=2 expandtab smarttab:


" AWK  ref. is: Alfred V. Aho, Brian W. Kernighan, Peter J. Weinberger
" The AWK Programming Language, Addison-Wesley, 1988

" GAWK ref. is: Arnold D. Robbins
" Effective AWK Programming, Third Edition, O'Reilly, 2001
" Effective AWK Programming, Fourth Edition, O'Reilly, 2015
" (up-to-date version available with the gawk source distribution)

" MAWK is a "new awk" meaning it implements AWK ref.
" mawk conforms to the Posix 1003.2 (draft 11.3)
" definition of the AWK language which contains a few features
" not described in the AWK book, and mawk provides a small number of extensions.

" TODO:
" Dig into the commented out syntax expressions below.

" Quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn iskeyword @,48-57,_,192-255,@-@

" A bunch of useful Awk keywords
" AWK  ref. p. 188
syn keyword awkStatement	break continue delete exit
syn keyword awkStatement	function getline next
syn keyword awkStatement	print printf return
" GAWK ref. Chapter 7-9
syn keyword awkStatement	case default switch nextfile
syn keyword awkStatement	func
" GAWK ref. Chapter 2.7, Including Other Files into Your Program
" GAWK ref. Chapter 2.8, Loading Dynamic Extensions into Your Program
" GAWK ref. Chapter 15, Namespaces
" Directives
syn keyword awkStatement	@include @load @namespace
"
" GAWK ref. Chapter 9, Functions
" Numeric Functions
syn keyword awkFunction	atan2 cos exp int log rand sin sqrt srand
" String Manipulation Functions
syn keyword awkFunction	asort asorti gensub gsub index length match
syn keyword awkFunction	patsplit split sprintf strtonum sub substr
syn keyword awkFunction	tolower toupper
" Input Output Functions
syn keyword awkFunction	close fflush system
" Time Functions
syn keyword awkFunction	mktime strftime systime
" Bit Manipulation Functions
syn keyword awkFunction	and compl lshift or rshift xor
" Getting Type Information Functions
syn keyword awkFunction	isarray typeof
" String-Translation Functions
syn keyword awkFunction	bindtextdomain dcgettext dcngetext

syn keyword awkConditional	if else
syn keyword awkRepeat	while for do

syn keyword awkTodo	contained TODO

syn keyword awkPatterns	BEGIN END BEGINFILE ENDFILE

" GAWK ref. Chapter 7
" Built-in Variables That Control awk
syn keyword awkVariables        BINMODE CONVFMT FIELDWIDTHS FPAT FS
syn keyword awkVariables	IGNORECASE LINT OFMT OFS ORS PREC
syn keyword awkVariables	ROUNDMODE RS SUBSEP TEXTDOMAIN
" Built-in Variables That Convey Information
syn keyword awkVariables	ARGC ARGV ARGIND ENVIRON ERRNO FILENAME
syn keyword awkVariables	FNR NF FUNCTAB NR PROCINFO RLENGTH RSTART
syn keyword awkVariables	RT SYMTAB

" Arithmetic operators: +, and - take care of ++, and --
syn match   awkOperator		"+\|-\|\*\|/\|%\|="
syn match   awkOperator		"+=\|-=\|\*=\|/=\|%="
syn match   awkOperator		"\^\|\^="

" Octal format character.
syn match   awkSpecialCharacter display contained "\\[0-7]\{1,3\}"
" Hex   format character.
syn match   awkSpecialCharacter display contained "\\x[0-9A-Fa-f]\+"

syn match   awkFieldVars	"\$\d\+"

" catch errors caused by wrong parenthesis
syn region	awkParen	transparent start="(" end=")" contains=ALLBUT,awkParenError,awkSpecialCharacter,awkArrayElement,awkArrayArray,awkTodo,awkRegExp,awkBrktRegExp,awkBrackets,awkCharClass,awkComment
syn match	awkParenError	display ")"
"syn match	awkInParen	display contained "[{}]"

" 64 lines for complex &&'s, and ||'s in a big "if"
syn sync ccomment awkParen maxlines=64

" Search strings & Regular Expressions therein.
syn region  awkSearch	oneline start="^[ \t]*/"ms=e start="\(,\|!\=\~\)[ \t]*/"ms=e skip="\\\\\|\\/" end="/" contains=awkBrackets,awkRegExp,awkSpecialCharacter
syn region  awkBrackets	contained start="\[\^\]\="ms=s+2 start="\[[^\^]"ms=s+1 end="\]"me=e-1 contains=awkBrktRegExp,awkCharClass
syn region  awkSearch	oneline start="[ \t]*/"hs=e skip="\\\\\|\\/" end="/" contains=awkBrackets,awkRegExp,awkSpecialCharacter

syn match   awkCharClass	contained "\[:[^:\]]*:\]"
syn match   awkBrktRegExp	contained "\\.\|.\-[^]]"
syn match   awkRegExp	contained "/\^"ms=s+1
syn match   awkRegExp	contained "\$/"me=e-1
syn match   awkRegExp	contained "[?.*{}|+]"

" String and Character constants
" Highlight special characters (those which have a backslash) differently
syn region  awkString	start=+"+  skip=+\\\\\|\\"+  end=+"+  contains=@Spell,awkSpecialCharacter,awkSpecialPrintf
syn match   awkSpecialCharacter contained "\\."

" Some of these combinations may seem weird, but they work.
syn match   awkSpecialPrintf	contained "%[-+ #]*\d*\.\=\d*[cdefgiosuxEGX%]"

" Numbers, allowing signs (both -, and +)
" Integer number.
syn match  awkNumber		display "[+-]\=\<\d\+\>"
" Floating point number.
syn match  awkFloat		display "[+-]\=\<\d\+\.\d+\>"
" Floating point number, starting with a dot.
syn match  awkFloat		display "[+-]\=\<.\d+\>"
syn case ignore
"floating point number, with dot, optional exponent
syn match  awkFloat	display "\<\d\+\.\d*\(e[-+]\=\d\+\)\=\>"
"floating point number, starting with a dot, optional exponent
syn match  awkFloat	display "\.\d\+\(e[-+]\=\d\+\)\=\>"
"floating point number, without dot, with exponent
syn match  awkFloat	display "\<\d\+e[-+]\=\d\+\>"
syn case match

"syn match  awkIdentifier	"\<[a-zA-Z_][a-zA-Z0-9_]*\>"

" Comparison expressions.
syn match   awkExpression	"==\|>=\|=>\|<=\|=<\|\!="
syn match   awkExpression	"\~\|\!\~"
syn match   awkExpression	"?\|:"
syn keyword awkExpression	in

" Boolean Logic (OR, AND, NOT)
syn match  awkBoolLogic	"||\|&&\|\!"

" This is overridden by less-than & greater-than.
" Put this above those to override them.
" Put this in a 'match "\<printf\=\>.*;\="' to make it not override
" less/greater than (most of the time), but it won't work yet because
" keywords always have precedence over match & region.
" File I/O: (print foo, bar > "filename") & for nawk (getline < "filename")
"syn match  awkFileIO		contained ">"
"syn match  awkFileIO		contained "<"

" Expression separators: ';' and ','
syn match  awkSemicolon	";"
syn match  awkComma		","

syn match  awkComment	"#.*" contains=@Spell,awkTodo

syn match  awkLineSkip	"\\$"

" Highlight array element's (recursive arrays allowed).
" Keeps nested array names' separate from normal array elements.
" Keeps numbers separate from normal array elements (variables).
syn match  awkArrayArray	contained "[^][, \t]\+\["me=e-1
syn match  awkArrayElement      contained "[^][, \t]\+"
syn region awkArray		transparent start="\[" end="\]" contains=awkArray,awkArrayElement,awkArrayArray,awkNumber,awkFloat

" 10 should be enough.
" (for the few instances where it would be more than "oneline")
syn sync ccomment awkArray maxlines=10

" Define the default highlighting.
hi def link awkConditional	Conditional
hi def link awkFunction		Function
hi def link awkRepeat		Repeat
hi def link awkStatement	Statement
hi def link awkString		String
hi def link awkSpecialPrintf	Special
hi def link awkSpecialCharacter	Special
hi def link awkSearch		String
hi def link awkBrackets		awkRegExp
hi def link awkBrktRegExp	awkNestRegExp
hi def link awkCharClass	awkNestRegExp
hi def link awkNestRegExp	Keyword
hi def link awkRegExp		Special
hi def link awkNumber		Number
hi def link awkFloat		Float
hi def link awkFileIO		Special
hi def link awkOperator		Special
hi def link awkExpression	Special
hi def link awkBoolLogic	Special
hi def link awkPatterns		Special
hi def link awkVariables	Special
hi def link awkFieldVars	Special
hi def link awkLineSkip		Special
hi def link awkSemicolon	Special
hi def link awkComma		Special
hi def link awkIdentifier	Identifier
hi def link awkComment		Comment
hi def link awkTodo		Todo
" Change this if you want nested array names to be highlighted.
hi def link awkArrayArray	awkArray
hi def link awkArrayElement	Special
hi def link awkParenError	awkError
hi def link awkInParen		awkError
hi def link awkError		Error

let b:current_syntax = "awk"

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: ts=8
