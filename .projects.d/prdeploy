alias prdeploy-rehash='. /Users/simensen/.dotfiles/shell/.projects.d/prdeploy'

alias prdeploy-cd='cd /Users/simensen/Code/prdeploy'

# Docker Compose
function prdeploy-docker-compose() (
    if [ -f '.contrail/docker/.env' ]; then
        DOCKER_COMPOSE_ENV_FILE_OPT="--env-file .contrail/docker/.env"
    fi

    if [ -f ".contrail/docker/docker-compose.override.yaml" ]; then
        env CONTRAIL_PROJECT_HOME="${CONTRAIL_PROJECT_HOME:-$PWD}" \
        docker-compose $(echo ${DOCKER_COMPOSE_ENV_FILE_OPT}) \
            -p prdeploy \
            -f .contrail/docker/docker-compose.common.yaml \
            -f .contrail/docker/docker-compose.common-traefik.yaml \
            -f .contrail/docker/docker-compose.testing.yaml \
            -f .contrail/docker/docker-compose.testing-traefik.yaml \
            -f .contrail/docker/docker-compose.traefik-external.yaml \
            -f .contrail/docker/docker-compose.override.yaml \
            "$@"
    else
        env CONTRAIL_PROJECT_HOME="${CONTRAIL_PROJECT_HOME:-$PWD}" \
        docker-compose $(echo ${DOCKER_COMPOSE_ENV_FILE_OPT}) \
            -p prdeploy \
            -f .contrail/docker/docker-compose.common.yaml \
            -f .contrail/docker/docker-compose.common-traefik.yaml \
            -f .contrail/docker/docker-compose.testing.yaml \
            -f .contrail/docker/docker-compose.testing-traefik.yaml \
            -f .contrail/docker/docker-compose.traefik-external.yaml \
            "$@"
    fi
)

# Docker Compose Helpers
alias prdeploy-up='prdeploy-docker-compose up'
alias prdeploy-down='prdeploy-docker-compose down'
alias prdeploy-restart='prdeploy-docker-compose restart'

# Core
alias prdeploy-shell='prdeploy-docker-compose exec php bash'
alias prdeploy-composer='prdeploy-docker-compose exec php composer'

# PHP and Composer
alias prdeploy-php='prdeploy-docker-compose exec php php'
alias prdeploy-composer='prdeploy-docker-compose exec php composer'
alias prdeploy-test-php='prdeploy-docker-compose exec php_testing php'

# PHPUnit
alias prdeploy-phpunit='prdeploy-test-php ./vendor/bin/phpunit'
alias prdeploy-phpunit-coverage='prdeploy-phpunit --coverage-html=public/coverage'

# Laravel
alias prdeploy-artisan='prdeploy-php artisan'
alias prdeploy-tinker='prdeploy-artisan tinker'

# Laravel Testing
alias prdeploy-test-artisan='prdeploy-test-php artisan --env=testing'

# MySQL
alias prdeploy-mysql='prdeploy-docker-compose exec -e MYSQL_PWD=password php mysql -h mysql -uprdeploy prdeploy'
alias prdeploy-mysqldump='prdeploy-docker-compose exec -e MYSQL_PWD=password php mysqldump -h mysql -uprdeploy prdeploy'
alias prdeploy-test-mysql='prdeploy-docker-compose exec -e MYSQL_PWD=password php_testing mysql -h mysql_testing -uprdeploy prdeploy'
alias prdeploy-test-mysqldump='prdeploy-docker-compose exec -e MYSQL_PWD=password php_testing mysqldump -h mysql_testing -uprdeploy prdeploy'

function prdeploy-mysql-snapshot-create() (
    SNAPSHOT="$1"
    shift
    MYSQL_PWD=password
    prdeploy-mysqldump -u root --result-file=database/snapshots/${SNAPSHOT}.sql "$@"
)

function prdeploy-mysql-snapshot-load() (
    SNAPSHOT="$1"
    shift
    prdeploy-mysql --execute="SET autocommit=0 ; source database/snapshots/${SNAPSHOT}.sql ; COMMIT ;" "$@"
)

function prdeploy-test-mysql-snapshot-create() (
    SNAPSHOT="$1"
    shift
    MYSQL_PWD=password
    prdeploy-test-mysqldump -u root --result-file=database/snapshots/${SNAPSHOT}.sql "$@"
)

function prdeploy-test-mysql-snapshot-load() (
    SNAPSHOT="$1"
    shift
    prdeploy-test-mysql --execute="SET autocommit=0 ; source database/snapshots/${SNAPSHOT}.sql ; COMMIT ;" "$@"
)


# Custom
alias prdeploy-dusk='prdeploy-test-artisan dusk'
alias prdeploy-eslint='npx eslint resources/js'
alias prdeploy-eslint-fix='npx eslint --fix resources/js'
alias prdeploy-fresh='prdeploy-artisan migrate:fresh --seed'
alias prdeploy-test-fresh='prdeploy-artisan migrate:fresh'
alias prdeploy-ide='prdeploy-artisan ide-helper:generate -H && \
prdeploy-artisan ide-helper:models -M && \
prdeploy-artisan ide-helper:eloquent'
alias prdeploy-phpcbf='prdeploy-php vendor/bin/phpcbf'
alias prdeploy-phpcs='prdeploy-php vendor/bin/phpcs'
alias prdeploy-psalm='prdeploy-php vendor/bin/psalm'
alias prdeploy-vapor='prdeploy-php vendor/bin/vapor'

function prdeploy-run {
    FILE="$1"
    shift
    KERNEL=$(cat <<__KERNEL__
require __DIR__ . '/vendor/autoload.php';
\$app = require __DIR__ . '/bootstrap/app.php';
\$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();
require_once '$FILE';
__KERNEL__
)
    prdeploy-php -r "$KERNEL" "$@"
}
