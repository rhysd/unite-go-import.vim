A unite.vim source to import Go packages
========================================

This is a [unite.vim](https://github.com/Shougo/unite.vim) source to import packages for Go programming language.  You can search and import/drop packages incrementally with unite interface.

## Usage

```
:Unite go/import
```

![screenshot](https://raw.githubusercontent.com/rhysd/screenshots/master/unite-go-import.vim/unite-go-import.gif)

unite-go-import.vim caches the first result on memory.  If you want to refresh the cache and make candidates again, specify `!` argument.

```
:Unite go/import:!
```

You can see the GoDoc as preview of the package.  Please enter `p` on the candidate of unite window.  If you want to show the preview automatically, execute `:Unite` command as below.

```
:Unite go/import -auto-preview
```

There are `import`, `drop`, `godoc`, `godoc_browser` and `import_as` actions for package candidates in unite interface.  `import` is a default action.

Additionally, if you want to search a package to see the GoDoc for the pacakge, specifying `godoc` as a default action may be helpful.  You can search a package incrementally and open its GoDoc.

```
:Unite go/import -default-action=godoc -start-insert
```

## Installation

This plugin depends on [unite.vim](https://github.com/Shougo/unite.vim) and `:Import`/`:Drop` Vim commands.  `:Import`/`:Drop` commands are bundled in Go environment.  See [documentation](http://golang.org/misc/vim/readme.txt).  As optional, `:GoImport`, `:GoDrop` commands can be also referred which are defined in [vim-go](https://github.com/fatih/vim-go).

If you use neobundle.vim, copy and paste below code in your `.vimrc`.

```vim
NeoBundleLazy 'rhysd/unite-go-import.vim', {
        \ 'autoload' : {
        \     'depends' : 'Shougo/unite.vim',
        \     'filetypes' : 'go',
        \   }
        \ }
```

You can boost gathering all packages by installing [gopkgs](https://github.com/haya14busa/gopkgs).  If you have so many Go files under your `GOPATH` directory, I highly recommend to install gopkgs.

```
$ go get -u github.com/haya14busa/gopkgs/cmd/gopkgs
```

## License

This plugin is distributed under the same license as Go programming language.

    Copyright (c) 2014-2016 rhysd.
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are
    met:

    * Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above
    copyright notice, this list of conditions and the following disclaimer
    in the documentation and/or other materials provided with the
    distribution.
    * Neither the name of Google Inc. nor the names of its
    contributors may be used to endorse or promote products derived from
    this software without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
    A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
    OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
    SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
    LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
    DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
    THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
    OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
