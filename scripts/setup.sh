#!/bin/bash

# TODO: add setup for dotfiles for home and work machines/profiles
echo "Setting up dotfiles..."
git clone --bare git@github.com:yourusername/dotfiles.git $HOME/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles checkout
dotfiles config --local status.showUntrackedFiles no
echo "Dotfiles setup complete!"
