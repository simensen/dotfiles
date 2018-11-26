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
# Misc
#

# Import ssh keys in keychain
ssh-add -A 2>/dev/null;
