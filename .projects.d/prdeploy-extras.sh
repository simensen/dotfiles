alias prdeploy-extras-rehash='. $HOME/.dotfiles/.projects.d/prdeploy-extras.sh'

alias prdeploy-cs='prdeploy-composer cs'
alias prdeploy-lint='prdeploy-composer lint'

alias prdeploy-migrate='prdeploy-artisan migrate'

alias prdeploy-wipe='prdeploy-artisan db:wipe'
alias prdeploy-wipe-and-load='prdeploy-wipe && prdeploy-mysql-snapshot-load'

alias prdeploy-snap='prdeploy-wipe-and-load snap && prdeploy-migrate'
alias prdeploy-snap-no-migrate='prdeploy-wipe-and-load snap'

alias prdeploy-snap-now='prdeploy-wipe-and-load now && prdeploy-migrate'
alias prdeploy-snap-now-no-migrate='prdeploy-wipe-and-load now'

alias prdeploy-snap-fresh='prdeploy-wipe-and-load fresh'
alias prdeploy-snap-fresh-no-migrate='prdeploy-wipe-and-load fresh && prdeploy-migrate'

alias prdeploy-snap-from-current='prdeploy-mysql-snapshot-create snap'

alias prdeploy-snap-from-now='prdeploy-snap-now && prdeploy-snap-from-current'
alias prdeploy-snap-from-now-no-migrate='prdeploy-snap-now-no-migrate && prdeploy-snap-from-current'

alias prdeploy-snap-from-fresh='prdeploy-wipe && prdeploy-fresh && prdeploy-snap-from-current'
alias prdeploy-snap-from-fresh-seeded='prdeploy-wipe && prdeploy-fresh --seed && prdeploy-snap-from-current'
