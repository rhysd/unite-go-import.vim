let s:save_cpo = &cpo
set cpo&vim

let g:unite_source_go_import_go_command = get(g:, 'unite_source_go_import_go_command', 'go')
let g:unite_source_go_import_disable_cache = get(g:, 'unite_source_go_import_disable_cache', 0)

let s:source = {
            \   'name' : 'go/import',
            \   'description' : 'Go packages to import',
            \   'default_action' : {'common' : 'import'},
            \   'action_table' : {},
            \ }

let s:previous_result = []

function! unite#sources#go_import#define()
    if ! exists(':Import')
        return {}
    endif
    return s:source
endfunction

function! unite#sources#go_import#reset_cache()
    let s:previous_result = []
endfunction

if $GOOS != ''
    let s:OS = $GOOS
elseif has('mac')
    let s:OS = 'darwin'
elseif has('win32') || has('win64')
    let s:OS = 'windows'
else
    let s:OS = '*'
endif

if $GOARCH != ''
    let s:ARCH = $GOARCH
else
    let s:ARCH = '*'
endif


function! s:go_packages()
    let dirs = []

    if executable('go')
        let goroot = substitute(system('go env GOROOT'), '\n', '', 'g')
        if v:shell_error
            echohl ErrorMsg | echomsg "'go env GOROOT' failed" | echohl None
            return []
        endif
    else
        let goroot = $GOROOT
    endif

    if goroot != '' && isdirectory(goroot)
        call add(dirs, goroot)
    endif

    if s:OS ==# 'windows'
        let pathsep = ';'
    else
        let pathsep = ':'
    endif
    let workspaces = split($GOPATH, pathsep)
    let dirs += workspaces

    if dirs == []
        return []
    endif

    let ret = []
    for dir in dirs
        " This may expand to multiple lines
        let roots = split(expand(dir . '/pkg/' . s:OS . '_' . s:ARCH), "\n")
        call add(roots, expand(dir . '/src'))
        for root in roots
            call extend(ret,
                \   map(
                \       map(
                \           split(globpath(root, '**/*.a'), "\n"),
                \           'substitute(v:val, ''\.a$'', "", "g")'
                \       ),
                \       'substitute(v:val, ''\\'', "/", "g")[len(root)+1:]'
                \   )
                \)
        endfor
    endfor
    return ret
endfunction

function! s:source.gather_candidates(args, context)
    if ! g:unite_source_go_import_disable_cache &&
                \ (empty(s:previous_result) || a:args == ['!'])
        let s:previous_result = map(s:go_packages(), '{
                                        \ "word" : v:val,
                                        \ }')
    endif
    return s:previous_result
endfunction

let s:source.action_table.import = {
            \ 'description' : 'Import Go package(s)',
            \ 'is_selectable' : 1,
            \ }

function! s:source.action_table.import.func(candidates)
    for candidate in a:candidates
        execute 'Import' candidate.word
    endfor
endfunction

let s:source.action_table.drop = {
            \ 'description' : 'Drop Go package(s)',
            \ 'is_selectable' : 1,
            \ }

function! s:source.action_table.drop.func(candidates)
    for candidate in a:candidates
        execute 'Drop' candidate.word
    endfor
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
