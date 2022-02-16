#!/bin/sh

echo "Setting up your Mac..."

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle

# Install PHP extensions with PECL
pecl install memcached imagick

# Install global Composer packages
/usr/local/bin/composer global require laravel/valet

# Install Laravel Valet
$HOME/.composer/vendor/bin/valet install

composer global require laravel/forge-cli

# Clone Github repositories
./clone.sh

# Remove .gitignore_global from $HOME (if it exists) and symlinks the .gitignore_global
# file from the .dotfiles
rm -f $HOME/.gitignore_global 
ln -s $HOME/.dotfiles/.gitignore_global $HOME/.gitignore_global

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -rf $HOME/.zshrc
ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc

# Removes .vimrc from $HOME (if it exists) and symlinks the .vimrc file from the .dotfiles
rm -rf $HOME/.vimrc
ln -s $HOME/.dotfiles/.vimrc $HOME/.vimrc

# Symlink the Mackup config file to the home directory (after removing them
# if they already exist)
rm -f $HOME/.mackup.cfg $HOME/.mackup
ln -s $HOME/.dotfiles/.mackup.cfg $HOME/.mackup.cfg
ln -s $HOME/.dotfiles/.mackup $HOME/.mackup

# Set macOS preferences
# We will run this last because this will reload the shell
source .macos

# Set up the sidebar the way I like it
source set-up-sidebar
