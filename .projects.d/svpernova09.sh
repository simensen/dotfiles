alias svpernova09-rehash='. /Users/simensen/.dotfiles/.projects.d/svpernova09.sh'

alias svpernova09-cd='cd /Users/simensen/Code/sites/svpernova09'

# Docker Compose
function svpernova09-docker-compose() (
    if [ -f '.contrail/docker/.env' ]; then
        DOCKER_COMPOSE_ENV_FILE_OPT="--env-file .contrail/docker/.env"
    fi

    if [ -f ".contrail/docker/docker-compose.override.yaml" ]; then
        env CONTRAIL_PROJECT_HOME="${CONTRAIL_PROJECT_HOME:-$PWD}" \
        docker-compose $(echo ${DOCKER_COMPOSE_ENV_FILE_OPT}) \
            -p svpernova09 \
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
            -p svpernova09 \
            -f .contrail/docker/docker-compose.common.yaml \
            -f .contrail/docker/docker-compose.common-traefik.yaml \
            -f .contrail/docker/docker-compose.testing.yaml \
            -f .contrail/docker/docker-compose.testing-traefik.yaml \
            -f .contrail/docker/docker-compose.traefik-external.yaml \
            "$@"
    fi
)

# Docker Compose Helpers
alias svpernova09-up='svpernova09-docker-compose up'
alias svpernova09-down='svpernova09-docker-compose down'
alias svpernova09-restart='svpernova09-docker-compose restart'

# Core
alias svpernova09-shell='svpernova09-docker-compose exec php bash'
alias svpernova09-composer='svpernova09-docker-compose exec php composer'

# PHP and Composer
alias svpernova09-php='svpernova09-docker-compose exec php php'
alias svpernova09-composer='svpernova09-docker-compose exec php composer'
alias svpernova09-test-php='svpernova09-docker-compose exec php_testing php'

# PHPUnit
alias svpernova09-phpunit='svpernova09-test-php ./vendor/bin/phpunit'
alias svpernova09-phpunit-coverage='svpernova09-phpunit --coverage-html=public/coverage'

# Laravel
alias svpernova09-artisan='svpernova09-php artisan'
alias svpernova09-tinker='svpernova09-artisan tinker'

# Laravel Testing
alias svpernova09-test-artisan='svpernova09-test-php artisan --env=testing'

# MySQL
alias svpernova09-mysql='svpernova09-docker-compose exec -e MYSQL_PWD=password php mysql -h mysql -usvpernova09 svpernova09'
alias svpernova09-mysqldump='svpernova09-docker-compose exec -e MYSQL_PWD=password php mysqldump -h mysql -usvpernova09 svpernova09'
alias svpernova09-test-mysql='svpernova09-docker-compose exec -e MYSQL_PWD=password php_testing mysql -h mysql_testing -usvpernova09 svpernova09'
alias svpernova09-test-mysqldump='svpernova09-docker-compose exec -e MYSQL_PWD=password php_testing mysqldump -h mysql_testing -usvpernova09 svpernova09'

function svpernova09-mysql-snapshot-create() (
    SNAPSHOT="$1"
    shift
    MYSQL_PWD=password
    svpernova09-mysqldump -u root --result-file=database/snapshots/${SNAPSHOT}.sql "$@"
)

function svpernova09-mysql-snapshot-load() (
    SNAPSHOT="$1"
    shift
    svpernova09-mysql --execute="SET autocommit=0 ; source database/snapshots/${SNAPSHOT}.sql ; COMMIT ;" "$@"
)

function svpernova09-test-mysql-snapshot-create() (
    SNAPSHOT="$1"
    shift
    MYSQL_PWD=password
    svpernova09-test-mysqldump -u root --result-file=database/snapshots/${SNAPSHOT}.sql "$@"
)

function svpernova09-test-mysql-snapshot-load() (
    SNAPSHOT="$1"
    shift
    svpernova09-test-mysql --execute="SET autocommit=0 ; source database/snapshots/${SNAPSHOT}.sql ; COMMIT ;" "$@"
)


# Custom
alias svpernova09-fresh='svpernova09-artisan migrate:fresh'

function svpernova09-run {
    FILE="$1"
    shift
    KERNEL=$(cat <<__KERNEL__
require __DIR__ . '/vendor/autoload.php';
\$app = require __DIR__ . '/bootstrap/app.php';
\$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();
require_once '$FILE';
__KERNEL__
)
    svpernova09-php -r "$KERNEL" "$@"
}
