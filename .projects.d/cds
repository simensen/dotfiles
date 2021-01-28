# CDS
alias cds-docker-compose='docker-compose \
 -p cpapdropship \
 -f docker/docker-compose.common.yml \
 -f docker/docker-compose.common-traefik.yml \
 -f docker/docker-compose.macos-project_root.yml \
 -f docker/docker-compose.testing.yml \
 -f docker/docker-compose.testing-traefik.yml \
 -f docker/docker-compose.tinkerwell.yml \
 -f docker/docker-compose.tinkerwell-traefik.yml \
 -f docker/docker-compose.traefik-external.yml \
 -f docker/docker-compose.override.yml'

alias cds-cd='cd ~/Code/app.cpapdropship.com'
alias cds-up='cds-docker-compose up'
alias cds-down='cds-docker-compose down'
alias cds-restart='cds-docker-compose restart'
alias cds-artisan='cds-docker-compose exec php php artisan'
alias cds-tinker='cds-docker-compose exec php php artisan tinker'
alias cds-composer='cds-docker-compose exec php composer'
alias cds-ide='cds-docker-compose exec php composer ide'
alias cds-test-artisan='cds-docker-compose exec php_test php artisan'
alias cds-test-fresh='cds-test-artisan migrate:fresh --seed'
alias cds-fresh='cds-artisan migrate:fresh --seed'
alias cds-phpunit='cds-docker-compose exec php_test ./vendor/bin/phpunit'
alias cds-phpunit-coverage='cds-docker-compose exec php_test ./vendor/bin/phpunit --coverage-html=public/coverage'
alias cds-dusk='cds-docker-compose exec php_test php artisan dusk'
alias cds-dusk:fails='cds-docker-compose exec php_test php artisan dusk:fails'
alias cds-cs='cds-docker-compose exec php php vendor/bin/phpcs --runtime-set ignore_warnings_on_exit true'
alias cds-cbf='cds-docker-compose exec php php vendor/bin/phpcbf -n'
alias cds-psalm='cds-docker-compose exec php php vendor/bin/psalm'
alias cds-eslint='npx eslint --ext .js,.vue resources/js'
alias cds-eslint-fix='npx eslint --ext .js,.vue --fix resources/js'
alias cds-check='(cds-cs; cds-phpunit; cds-dusk; cds-psalm; cds-eslint)'
alias cds-fix='(cds-cbf; cds-eslint-fix)'
alias cds-shell='cds-docker-compose exec php bash'
alias cds-mysql='cds-docker-compose exec -e MYSQL_PWD=password php mysql -h db -ucpapdropship cpapdropship'
alias cds-test-mysql='cds-docker-compose exec -e MYSQL_PWD=password php_test mysql -h db -ucpapdropship cpapdropship'
alias cds-php='cds-docker-compose exec php php'

alias cds-snapshot-create='cds-artisan snapshot:create'
alias cds-snapshot-list='cds-artisan snapshot:list'

function cds-test-snapshot-load {
    SNAPSHOT="$1"
    shift
    cds-mysql --execute="SET autocommit=0 ; source database/snapshots/$SNAPSHOT.sql ; COMMIT ;" "$@"
}

function cds-snapshot-load {
    SNAPSHOT="$1"
    shift
    cds-mysql --execute="SET autocommit=0 ; source database/snapshots/$SNAPSHOT.sql ; COMMIT ;" "$@"
}

function cds-run {
    FILE="$1"
    shift
    KERNEL=$(cat <<__KERNEL__
require __DIR__ . '/vendor/autoload.php';
\$app = require __DIR__ . '/bootstrap/app.php';
\$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();
require_once '$FILE';
__KERNEL__
)
    cds-php -r "$KERNEL" "$@"
}

