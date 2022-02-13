alias whrc-portal-extras-rehash='. /Users/simensen/.dotfiles/.projects.d/whrc-portal-extras.sh'

alias whrc-portal-migrate='whrc-portal-artisan migrate'

alias whrc-portal-wipe='whrc-portal-artisan db:wipe'
alias whrc-portal-wipe-and-load='whrc-portal-wipe && whrc-portal-mysql-snapshot-load'

alias whrc-portal-snap='whrc-portal-wipe-and-load snap && whrc-portal-migrate'
alias whrc-portal-snap-no-migrate='whrc-portal-wipe-and-load snap'

alias whrc-portal-snap-now='whrc-portal-wipe-and-load now && whrc-portal-migrate'
alias whrc-portal-snap-now-no-migrate='whrc-portal-wipe-and-load now'

alias whrc-portal-snap-fresh='whrc-portal-wipe-and-load fresh'
alias whrc-portal-snap-fresh-no-migrate='whrc-portal-wipe-and-load fresh && whrc-portal-migrate'

alias whrc-portal-snap-from-current='whrc-portal-mysql-snapshot-create snap'

alias whrc-portal-snap-from-now='whrc-portal-snap-now && whrc-portal-snap-from-current'
alias whrc-portal-snap-from-now-no-migrate='whrc-portal-snap-now-no-migrate && whrc-portal-snap-from-current'

alias whrc-portal-snap-from-fresh='whrc-portal-wipe && whrc-portal-fresh && whrc-portal-snap-from-current'
alias whrc-portal-snap-from-fresh-seeded='whrc-portal-wipe && whrc-portal-fresh --seed && whrc-portal-snap-from-current'
