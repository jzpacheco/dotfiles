#!/bin/bash

# Install ZSH(if needed)
echo "Checking zsh" 
if ! command -v zsh &> /dev/null; then
	echo "Installing Zsh..."
	if [[ "$OSTYPE" == "linux-gnu"* ]]; then
		# sudo apt update && sudo apt install -y zsh
		sudo pacman -S zsh
	elif [[ "$OSTYPE" == "darwin"* ]]; then
		brew install zsh
	else
		echo "Unsuported OS:$OSTYPE"
	        echo "Install ZSH manually"
	fi
fi	
echo "Finished zsh checking"
# Dowloanding .zshrc from git
ZSHRC_URL="https://raw.githubusercontent.com/jzpacheco/dotfiles/main/.zshrc"
echo " aquieee"
if command -v curl &> /dev/null; then
	echo "entrou"
	if curl -sO "$ZSHRC_URL"; then
		echo "Dowloaded .zshrc sucessfully"
	else
		echo "Failed to downalod .zshrc" >&2
		exit 1
	fi	
else
	echo "curl not found" >&2
	exit 1
fi

# Install Oh-My-ZZsh(if needed)
if ! -d "$HOME/.oh-my-zsh" ; then
	echo "Installing Oh-My-Zsh"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc 
fi

ZSH="${ZSH:-$HOME/.oh-my-zsh}"
mkdir -p "ZSH"/{competions,custom,functions}

if [ "$SHELL" != "$(which zsh)" ]; then
	echo "Setting Zsh as default shell..."
	chsh -s "$(which zsh)"
else
	echo "ZSH already current shell"
fi

echo "Basic Zsh setup Done!!"
