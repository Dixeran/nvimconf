#!/bin/bash

set -xe

if [ -d "$HOME/.config/nvim" ]; then
    echo "Backing up existing nvim config directory..."
    rm -rf "${HOME}/.config/nvim_backup"
    mv "$HOME/.config/nvim" "${HOME}/.config/nvim_backup"
fi

echo "Creating new nvim config directory..."
mkdir -p "$HOME/.config/nvim"

echo "Moving all files under ~/.config/nvim to $HOME/.config/nvim..."
cp -r ./* "$HOME/.config/nvim"

# install deps
echo "Making sure nvim install properly..."
if [ -d "$HOME/.local/share/nvim" ]; then
    echo "$HOME/.local/share/nvim path detected"
else
    echo "ERROR: Nvim site path not found"
    exit 1
fi

echo "Cloning packer into site path.."
if [ -d "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ]; then

    read -p "Remove current packer installation? (y/n): " response

    if [[ $response == 'y' ]]; then
        rm -rf ~/.local/share/nvim/site/pack/packer/start/packer.nvim
        git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
    fi
fi

read -p "Do you wish to install Rust and ripgrep? (y/n): " response

if [[ $response == 'y' ]]; then

    echo "Installing Rust-lang and ripgrep"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

    source "$HOME/.cargo/env"
    
    cargo install ripgrep

fi

read -p "Do you wish to install Node.js? (y/n): " response

if [[ $response == 'y' ]]; then
    echo "Installing Node.js.."
    curl -fsSL https://fnm.vercel.app/install | bash
    ~/.local/share/fnm/fnm install --lts
fi

nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

echo "Make sure you install NerdFont for icons display! See https://www.nerdfonts.com/"