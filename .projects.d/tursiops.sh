alias tursiops-rehash='. /Users/simensen/.dotfiles/.projects.d/tursiops.sh'

alias tursiops-cd='cd /Users/simensen/Code/tursiops'

# Docker Compose
function tursiops-docker-compose() (
    if [ -f '.contrail/docker/.env' ]; then
        DOCKER_COMPOSE_ENV_FILE_OPT="--env-file .contrail/docker/.env"
    fi

    if [ -f ".contrail/docker/docker-compose.override.yaml" ]; then
        env CONTRAIL_PROJECT_HOME="${CONTRAIL_PROJECT_HOME:-$PWD}" \
        docker-compose $(echo ${DOCKER_COMPOSE_ENV_FILE_OPT}) \
            -p tursiops \
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
            -p tursiops \
            -f .contrail/docker/docker-compose.common.yaml \
            -f .contrail/docker/docker-compose.common-traefik.yaml \
            -f .contrail/docker/docker-compose.testing.yaml \
            -f .contrail/docker/docker-compose.testing-traefik.yaml \
            -f .contrail/docker/docker-compose.traefik-external.yaml \
            "$@"
    fi
)

# Docker Compose Helpers
alias tursiops-up='tursiops-docker-compose up'
alias tursiops-down='tursiops-docker-compose down'
alias tursiops-restart='tursiops-docker-compose restart'

# Core
alias tursiops-shell='tursiops-docker-compose exec php bash'
alias tursiops-composer='tursiops-docker-compose exec php composer'

# PHP and Composer
alias tursiops-php='tursiops-docker-compose exec php php'
alias tursiops-composer='tursiops-docker-compose exec php composer'
alias tursiops-test-php='tursiops-docker-compose exec php_testing php'

# PHPUnit
alias tursiops-phpunit='tursiops-test-php ./vendor/bin/phpunit'
alias tursiops-phpunit-coverage='tursiops-phpunit --coverage-html=public/coverage'

# Laravel
alias tursiops-artisan='tursiops-php artisan'
alias tursiops-tinker='tursiops-artisan tinker'

# Laravel Testing
alias tursiops-test-artisan='tursiops-test-php artisan --env=testing'

# MySQL
alias tursiops-mysql='tursiops-docker-compose exec -e MYSQL_PWD=password php mysql -h mysql -utursiops tursiops'
alias tursiops-mysqldump='tursiops-docker-compose exec -e MYSQL_PWD=password php mysqldump -h mysql -utursiops tursiops'
alias tursiops-test-mysql='tursiops-docker-compose exec -e MYSQL_PWD=password php_testing mysql -h mysql_testing -utursiops tursiops'
alias tursiops-test-mysqldump='tursiops-docker-compose exec -e MYSQL_PWD=password php_testing mysqldump -h mysql_testing -utursiops tursiops'

function tursiops-mysql-snapshot-create() (
    SNAPSHOT="$1"
    shift
    MYSQL_PWD=password
    tursiops-mysqldump -u root --result-file=database/snapshots/${SNAPSHOT}.sql "$@"
)

function tursiops-mysql-snapshot-load() (
    SNAPSHOT="$1"
    shift
    tursiops-mysql --execute="SET autocommit=0 ; source database/snapshots/${SNAPSHOT}.sql ; COMMIT ;" "$@"
)

function tursiops-test-mysql-snapshot-create() (
    SNAPSHOT="$1"
    shift
    MYSQL_PWD=password
    tursiops-test-mysqldump -u root --result-file=database/snapshots/${SNAPSHOT}.sql "$@"
)

function tursiops-test-mysql-snapshot-load() (
    SNAPSHOT="$1"
    shift
    tursiops-test-mysql --execute="SET autocommit=0 ; source database/snapshots/${SNAPSHOT}.sql ; COMMIT ;" "$@"
)


# Custom
alias tursiops-fresh='tursiops-artisan migrate:fresh'
alias tursiops-test-fresh='tursiops-test-artisan migrate:fresh'
alias tursiops-ide='tursiops-artisan ide-helper:generate && \
tursiops-artisan ide-helper:models -M && \
tursiops-artisan ide-helper:eloquent'
alias tursiops-phpcbf='tursiops-php vendor/bin/phpcbf'
alias tursiops-phpcs='tursiops-php vendor/bin/phpcs'
alias tursiops-psalm='tursiops-php vendor/bin/psalm'
alias tursiops-vapor='tursiops-php vendor/bin/vapor'

function tursiops-run {
    FILE="$1"
    shift
    KERNEL=$(cat <<__KERNEL__
require __DIR__ . '/vendor/autoload.php';
\$app = require __DIR__ . '/bootstrap/app.php';
\$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();
require_once '$FILE';
__KERNEL__
)
    tursiops-php -r "$KERNEL" "$@"
}
