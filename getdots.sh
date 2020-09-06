#!/bin/bash

DEST_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/dotfiles"
cp -rt $DEST_DIR ~/.zshrc ~/.condarc ~/.profile ~/.vim ~/.vimrc > /dev/null 2>&1
