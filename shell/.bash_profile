# Load the shell dotfiles, and then some:
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.dotfiles/shell/.{exports,aliases,functions}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file"
done

for file in ~/.dotfiles-custom/shell/.{exports,aliases,functions}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# Powerline
powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
source /usr/local/lib/python3.7/site-packages/powerline/bindings/bash/powerline.sh

#
# Adjust PATH
#

export PATH="$HOME/.composer/vendor/bin:$PATH"
export PATH="$HOME/.dotfiles/bin:$PATH"

#
# enable bash completion
#

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

#
# Magento Cloud
#

export PATH="~/.magento-cloud/bin:$PATH"
if [ -f ~/.magento-cloud/shell-config.rc ]; then . ~/.magento-cloud/shell-config.rc; fi

#
# Symfony
#

export PATH="~/.symfony/bin:$PATH"
if [ -f ~/.symfony/shell-config.rc ]; then . ~/.symfony/shell-config.rc; fi

complete -C "/Users/simensen/.symfony/bin/symfony self:autocomplete" symfony

#
# phpbrew
#

[[ -e ~/.phpbrew/bashrc ]] && source ~/.phpbrew/bashrc

#
# Ruby
#

export PATH="/usr/local/opt/ruby/bin:/usr/local/opt/ruby/libexec/gembin:$PATH"

#
# Misc
#

# Import ssh keys in keychain
ssh-add -A 2>/dev/null;

[ -r "~/.profile" ] && source ~/.profile

