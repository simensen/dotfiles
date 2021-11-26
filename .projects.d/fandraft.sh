alias fandraft-rehash='. /Users/simensen/.dotfiles/.projects.d/fandraft.sh'

alias fandraft-cd='cd /Users/simensen/Code/clients/fandraft/fandraft'

# Docker Compose
function fandraft-docker-compose() (
    if [ -f '.contrail/docker/.env' ]; then
        DOCKER_COMPOSE_ENV_FILE_OPT="--env-file .contrail/docker/.env"
    fi

    if [ -f ".contrail/docker/docker-compose.override.yaml" ]; then
        env CONTRAIL_PROJECT_HOME="${CONTRAIL_PROJECT_HOME:-$PWD}" \
        docker-compose $(echo ${DOCKER_COMPOSE_ENV_FILE_OPT}) \
            -p fandraft \
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
            -p fandraft \
            -f .contrail/docker/docker-compose.common.yaml \
            -f .contrail/docker/docker-compose.common-traefik.yaml \
            -f .contrail/docker/docker-compose.testing.yaml \
            -f .contrail/docker/docker-compose.testing-traefik.yaml \
            -f .contrail/docker/docker-compose.traefik-external.yaml \
            "$@"
    fi
)

# Docker Compose Helpers
alias fandraft-up='fandraft-docker-compose up'
alias fandraft-down='fandraft-docker-compose down'
alias fandraft-restart='fandraft-docker-compose restart'

# Core
alias fandraft-shell='fandraft-docker-compose exec php bash'
alias fandraft-composer='fandraft-docker-compose exec php composer'

# PHP and Composer
alias fandraft-php='fandraft-docker-compose exec php php'
alias fandraft-composer='fandraft-docker-compose exec php composer'
alias fandraft-test-php='fandraft-docker-compose exec php_testing php'

# PHPUnit
alias fandraft-phpunit='fandraft-test-php ./vendor/bin/phpunit'
alias fandraft-phpunit-coverage='fandraft-phpunit --coverage-html=public/coverage'

# Laravel
alias fandraft-artisan='fandraft-php artisan'
alias fandraft-tinker='fandraft-artisan tinker'

# Laravel Testing
alias fandraft-test-artisan='fandraft-test-php artisan --env=testing'

# MySQL
alias fandraft-mysql='fandraft-docker-compose exec -e MYSQL_PWD=password php mysql -h mysql -ufandraft fandraft'
alias fandraft-mysqldump='fandraft-docker-compose exec -e MYSQL_PWD=password php mysqldump -h mysql -ufandraft fandraft'
alias fandraft-test-mysql='fandraft-docker-compose exec -e MYSQL_PWD=password php_testing mysql -h mysql_testing -ufandraft fandraft'
alias fandraft-test-mysqldump='fandraft-docker-compose exec -e MYSQL_PWD=password php_testing mysqldump -h mysql_testing -ufandraft fandraft'

function fandraft-mysql-snapshot-create() (
    SNAPSHOT="$1"
    shift
    MYSQL_PWD=password
    fandraft-mysqldump -u root --result-file=database/snapshots/${SNAPSHOT}.sql "$@"
)

function fandraft-mysql-snapshot-load() (
    SNAPSHOT="$1"
    shift
    fandraft-mysql --execute="SET autocommit=0 ; source database/snapshots/${SNAPSHOT}.sql ; COMMIT ;" "$@"
)

function fandraft-test-mysql-snapshot-create() (
    SNAPSHOT="$1"
    shift
    MYSQL_PWD=password
    fandraft-test-mysqldump -u root --result-file=database/snapshots/${SNAPSHOT}.sql "$@"
)

function fandraft-test-mysql-snapshot-load() (
    SNAPSHOT="$1"
    shift
    fandraft-test-mysql --execute="SET autocommit=0 ; source database/snapshots/${SNAPSHOT}.sql ; COMMIT ;" "$@"
)


# Custom
alias fandraft-eslint='npx eslint resources/js'
alias fandraft-eslint-fix='npx eslint --fix resources/js'
alias fandraft-fresh='fandraft-artisan migrate:fresh --seed'
alias fandraft-test-fresh='fandraft-artisan migrate:fresh'
alias fandraft-ide='fandraft-artisan ide-helper:generate -H && \
fandraft-artisan ide-helper:models -M && \
fandraft-artisan ide-helper:eloquent'
alias fandraft-phpcbf='fandraft-php vendor/bin/phpcbf'
alias fandraft-phpcs='fandraft-php vendor/bin/phpcs'
alias fandraft-psalm='fandraft-php vendor/bin/psalm'
alias fandraft-vapor='fandraft-php vendor/bin/vapor'

function fandraft-run {
    FILE="$1"
    shift
    KERNEL=$(cat <<__KERNEL__
require __DIR__ . '/vendor/autoload.php';
\$app = require __DIR__ . '/bootstrap/app.php';
\$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();
require_once '$FILE';
__KERNEL__
)
    fandraft-php -r "$KERNEL" "$@"
}
