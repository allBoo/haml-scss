" Vim syntax file
" Language:     HamlDjango
" Maintainer:   Tim Pope <vimNOSPAM@tpope.info>
" Maintainer:   Dan LaMotte <lamotte85@gmail.com>
" Filenames:    *.haml

" TODO mostly incomplete with ruby still here, but a work in progress... mostly
" works...

if exists("b:current_syntax")
  finish
endif

if !exists("main_syntax")
  let main_syntax = 'haml'
endif
let b:ruby_no_expensive = 1

runtime! syntax/html.vim
unlet! b:current_syntax
silent! syn include @hamlSassTop syntax/sass.vim
unlet! b:current_syntax
syn include @hamlRubyTop syntax/ruby.vim

syn case match
"
" Mark illegal characters
syn match djangoError "%}\|}}\|#}"

" Django template built-in tags and parameters
" 'comment' doesn't appear here because it gets special treatment
syn keyword djangoStatement contained autoescape csrf_token empty
" FIXME ==, !=, <, >, <=, and >= should be djangoStatements:
" syn keyword djangoStatement contained == != < > <= >=
syn keyword djangoStatement contained and as block endblock by cycle debug else
syn keyword djangoStatement contained extends filter endfilter firstof for
syn keyword djangoStatement contained endfor if endif ifchanged endifchanged
syn keyword djangoStatement contained ifequal endifequal ifnotequal
syn keyword djangoStatement contained endifnotequal in include load not now or
syn keyword djangoStatement contained parsed regroup reversed spaceless
syn keyword djangoStatement contained endspaceless ssi templatetag openblock
syn keyword djangoStatement contained closeblock openvariable closevariable
syn keyword djangoStatement contained openbrace closebrace opencomment
syn keyword djangoStatement contained closecomment widthratio url with endwith
syn keyword djangoStatement contained get_current_language trans noop blocktrans
syn keyword djangoStatement contained endblocktrans get_available_languages
syn keyword djangoStatement contained get_current_language_bidi plural

" Django templete built-in filters
syn keyword djangoFilter contained add addslashes capfirst center cut date
syn keyword djangoFilter contained default default_if_none dictsort
syn keyword djangoFilter contained dictsortreversed divisibleby escape escapejs
syn keyword djangoFilter contained filesizeformat first fix_ampersands
syn keyword djangoFilter contained floatformat get_digit join last length length_is
syn keyword djangoFilter contained linebreaks linebreaksbr linenumbers ljust
syn keyword djangoFilter contained lower make_list phone2numeric pluralize
syn keyword djangoFilter contained pprint random removetags rjust slice slugify
syn keyword djangoFilter contained safe safeseq stringformat striptags
syn keyword djangoFilter contained time timesince timeuntil title
syn keyword djangoFilter contained truncatewords truncatewords_html unordered_list upper urlencode
syn keyword djangoFilter contained urlize urlizetrunc wordcount wordwrap yesno

" Keywords to highlight within comments
syn keyword djangoTodo contained TODO FIXME XXX

" Django template constants (always surrounded by double quotes)
syn region djangoArgument contained start=/"/ skip=/\\"/ end=/"/

" Mark illegal characters within tag and variables blocks
syn match djangoTagError contained "#}\|{{\|[^%]}}\|[&#]"
syn match djangoVarError contained "#}\|{%\|%}\|[<>!&#%]"

" Django template tag and variable blocks
syn region djangoTagBlock start="{%" end="%}" contains=djangoStatement,djangoFilter,djangoArgument,djangoTagError display
syn region djangoVarBlock start="{{" end="}}" contains=djangoFilter,djangoArgument,djangoVarError display

" Django template 'comment' tag and comment block
syn region djangoComment start="{%\s*comment\s*%}" end="{%\s*endcomment\s*%}" contains=djangoTodo
syn region djangoComBlock start="{#" end="#}" contains=djangoTodo

syn cluster hamlComponent    contains=hamlAttributes,hamlClassChar,hamlIdChar,hamlObject,hamlDespacer,hamlSelfCloser,hamlRuby,hamlPlainChar,hamlInterpolatable
syn cluster hamlEmbeddedRuby contains=hamlAttributes,hamlObject,hamlRuby,hamlRubyFilter
syn cluster hamlTop          contains=hamlBegin,hamlPlainFilter,hamlRubyFilter,hamlSassFilter,hamlComment,hamlHtmlComment

syn match   hamlBegin "^\s*[<>&]\@!" nextgroup=hamlTag,hamlAttributes,hamlClassChar,hamlIdChar,hamlObject,hamlRuby,hamlPlainChar,hamlInterpolatable

syn match   hamlTag        "%\w\+" contained contains=htmlTagName,htmlSpecialTagName nextgroup=@hamlComponent
syn region  hamlAttributes matchgroup=hamlAttributesDelimiter start="{" end="}" contained contains=@hamlRubyTop nextgroup=@hamlComponent
syn region  hamlObject     matchgroup=hamlObjectDelimiter   start="\[" end="\]" contained contains=@hamlRubyTop nextgroup=@hamlComponent
syn match   hamlDespacer "[<>]" contained nextgroup=hamlDespacer,hamlSelfCloser,hamlRuby,hamlPlainChar,hamlInterpolatable
syn match   hamlSelfCloser "/" contained
syn match   hamlClassChar "\." contained nextgroup=hamlClass
syn match   hamlIdChar    "#"  contained nextgroup=hamlId
syn match   hamlClass "\%(\w\|-\)\+" contained nextgroup=@hamlComponent
syn match   hamlId    "\%(\w\|-\)\+" contained nextgroup=@hamlComponent
syn region  hamlDocType start="^\s*!!!" end="$"

syn region  hamlRuby   matchgroup=hamlRubyOutputChar start="[=~]" end="$" contained contains=@hamlRubyTop keepend
syn region  hamlRuby   matchgroup=hamlRubyChar       start="-"    end="$" contained contains=djangoStatement,djangoFilter,djangoArgument,djangoTagError keepend
syn match   hamlPlainChar "\\" contained
syn region hamlInterpolatable matchgroup=hamlInterpolatableChar start="==" end="$" keepend contained contains=hamlInterpolation
syn region hamlInterpolation matchgroup=hamlInterpolationDelimiter start="#{" end="}" contained contains=@hamlRubyTop
syn region hamlErbInterpolation matchgroup=hamlInterpolationDelimiter start="<%[=-]\=" end="-\=%>" contained contains=@hamlRubyTop

syn match   hamlHelper  "\<action_view?\|\.\@<!\<\%(flatten\|open\|puts\)" contained containedin=@hamlEmbeddedRuby,@hamlRubyTop,rubyInterpolation
syn keyword hamlHelper   capture_haml find_and_preserve  html_attrs init_haml_helpers list_of preced preserve succeed surround tab_down tab_up page_class contained containedin=@hamlEmbeddedRuby,@hamlRubyTop,rubyInterpolation

syn cluster hamlHtmlTop contains=@htmlTop,htmlBold,htmlItalic,htmlUnderline
syn region  hamlPlainFilter matchgroup=hamlFilter start="^\z(\s*\):\%(plain\|preserve\|erb\|redcloth\|textile\|markdown\)\s*$" end="^\%(\z1 \)\@!" contains=@hamlHtmlTop,rubyInterpolation
syn region  hamlEscapedFilter matchgroup=hamlFilter start="^\z(\s*\):\%(escaped\)\s*$" end="^\%(\z1 \)\@!" contains=rubyInterpolation
syn region  hamlErbFilter  matchgroup=hamlFilter start="^\z(\s*\):erb\s*$" end="^\%(\z1 \)\@!" contains=@hamlHtmlTop,hamlErbInterpolation
syn region  hamlRubyFilter  matchgroup=hamlFilter start="^\z(\s*\):ruby\s*$" end="^\%(\z1 \)\@!" contains=@hamlRubyTop
syn region  hamlSassFilter  matchgroup=hamlFilter start="^\z(\s*\):sass\s*$" end="^\%(\z1 \)\@!" contains=@hamlSassTop
syn region  hamlJavascriptBlock matchgroup=hamlFilter start="^\z(\s*\):javascript" nextgroup=@hamlComponent,hamlError end="^\%(\S*\|\%(\z1 \)\)\@!" contains=@hamlTop,@htmlJavaScript keepend

syn region  hamlJavascriptBlock start="^\z(\s*\)%script" nextgroup=@hamlComponent,hamlError end="^\%(\z1 \)\@!" contains=@hamlTop,@htmlJavaScript keepend
syn region  hamlCssBlock        start="^\z(\s*\)%style" nextgroup=@hamlComponent,hamlError end="^\%(\z1 \)\@!" contains=@hamlTop,@htmlCss keepend
syn match   hamlError "\$" contained

syn region  hamlComment     start="^\z(\s*\)-#" end="^\%(\z1 \)\@!" contains=rubyTodo
syn region  hamlHtmlComment start="^\z(\s*\)/" end="^\%(\z1 \)\@!" contains=@hamlTop,rubyTodo
syn match   hamlIEConditional "\%(^\s*/\)\@<=\[if\>[^]]*]" contained containedin=hamlHtmlComment

hi def link djangoTagBlock  PreProc
hi def link djangoVarBlock  PreProc
hi def link djangoStatement Statement
hi def link djangoFilter    Identifier
hi def link djangoArgument  Constant
hi def link djangoTagError  Error
hi def link djangoVarError  Error
hi def link djangoError     Error
hi def link djangoComment   Comment
hi def link djangoComBlock  Comment
hi def link djangoTodo      Todo

hi def link hamlSelfCloser             Special
hi def link hamlDespacer               Special
hi def link hamlClassChar              Special
hi def link hamlIdChar                 Special
hi def link hamlTag                    Special
hi def link hamlClass                  Type
hi def link hamlId                     Identifier
hi def link hamlPlainChar              Special
hi def link hamlInterpolatableChar     hamlRubyChar
hi def link hamlRubyOutputChar         hamlRubyChar
hi def link hamlRubyChar               Special
hi def link hamlInterpolationDelimiter Delimiter
hi def link hamlDocType                PreProc
hi def link hamlFilter                 PreProc
hi def link hamlAttributesDelimiter    Delimiter
hi def link hamlObjectDelimiter        Delimiter
hi def link hamlHelper                 Function
hi def link hamlHtmlComment            hamlComment
hi def link hamlComment                Comment
hi def link hamlIEConditional          SpecialComment
hi def link hamlError                  Error

let b:current_syntax = "haml"

" vim:set sw=2:
