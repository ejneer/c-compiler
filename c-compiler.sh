#!/bin/sh
emacs --batch -l ~/c-compiler/c-compiler.el --eval "(print (c-compiler-compile \"$1\"))"
