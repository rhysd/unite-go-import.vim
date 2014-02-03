let s:save_cpo = &cpo
set cpo&vim

let g:unite_source_go_import_go_command = get(g:, 'unite_source_go_import_go_command', 'go')

let s:source = {
            \   'name' : 'go/import',
            \   'description' : 'Go packages to import',
            \   'default_action' : {'common' : 'import'},
            \   'action_table' : {},
            \ }

function! unite#sources#go_import#define()
    if ! exists(':Import')
        echomsg ':Import command is not found.'
        return {}
    endif
    return s:source
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
            echomsg "'go env GOROOT' failed"
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
    " TODO: Cache
    return map(s:go_packages(), '{
                \ "word" : v:val
                \ }')
endfunction

let s:source.action_table.import = {
            \ 'description' : 'Import Go package',
            \ 'is_selectable' : 1,
            \ }

function! s:source.action_table.import.func(candidates)
    for candidate in a:candidates
        execute 'Import' candidate.word
    endfor
endfunction

let s:source.action_table.drop = {
            \ 'description' : 'Drop Go package',
            \ 'is_selectable' : 1,
            \ }

function! s:source.action_table.drop.func(candidates)
    for candidate in a:candidates
        execute 'Drop' candidate.word
    endfor
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
