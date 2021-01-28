alias beausimensen-rehash='. /Users/simensen/.dotfiles/shell/.projects.d/beausimensen'

alias beausimensen-cd='cd /Users/simensen/Code/beausimensen'

# Docker Compose
function beausimensen-docker-compose() (
    if [ -f '.contrail/docker/.env' ]; then
        DOCKER_COMPOSE_ENV_FILE_OPT="--env-file .contrail/docker/.env"
    fi

    if [ -f ".contrail/docker/docker-compose.override.yaml" ]; then
        env CONTRAIL_PROJECT_HOME="${CONTRAIL_PROJECT_HOME:-$PWD}" \
        docker-compose $(echo ${DOCKER_COMPOSE_ENV_FILE_OPT}) \
            -p beausimensen \
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
            -p beausimensen \
            -f .contrail/docker/docker-compose.common.yaml \
            -f .contrail/docker/docker-compose.common-traefik.yaml \
            -f .contrail/docker/docker-compose.testing.yaml \
            -f .contrail/docker/docker-compose.testing-traefik.yaml \
            -f .contrail/docker/docker-compose.traefik-external.yaml \
            "$@"
    fi
)

# Docker Compose Helpers
alias beausimensen-up='beausimensen-docker-compose up'
alias beausimensen-down='beausimensen-docker-compose down'
alias beausimensen-restart='beausimensen-docker-compose restart'

# Core
alias beausimensen-shell='beausimensen-docker-compose exec php bash'
alias beausimensen-composer='beausimensen-docker-compose exec php composer'

# PHP and Composer
alias beausimensen-php='beausimensen-docker-compose exec php php'
alias beausimensen-composer='beausimensen-docker-compose exec php composer'
alias beausimensen-test-php='beausimensen-docker-compose exec php_testing php'

# PHPUnit
alias beausimensen-phpunit='beausimensen-test-php ./vendor/bin/phpunit'
alias beausimensen-phpunit-coverage='beausimensen-phpunit --coverage-html=public/coverage'

# Laravel
alias beausimensen-artisan='beausimensen-php artisan'
alias beausimensen-tinker='beausimensen-artisan tinker'

# Laravel Testing
alias beausimensen-test-artisan='beausimensen-test-php artisan --env=testing'

# MySQL
alias beausimensen-mysql='beausimensen-docker-compose exec -e MYSQL_PWD=password php mysql -h mysql -ubeausimensen beausimensen'
alias beausimensen-mysqldump='beausimensen-docker-compose exec -e MYSQL_PWD=password php mysqldump -h mysql -ubeausimensen beausimensen'
alias beausimensen-test-mysql='beausimensen-docker-compose exec -e MYSQL_PWD=password php_testing mysql -h mysql_testing -ubeausimensen beausimensen'
alias beausimensen-test-mysqldump='beausimensen-docker-compose exec -e MYSQL_PWD=password php_testing mysqldump -h mysql_testing -ubeausimensen beausimensen'

function beausimensen-mysql-snapshot-create() (
    SNAPSHOT="$1"
    shift
    MYSQL_PWD=password
    beausimensen-mysqldump -u root --result-file=database/snapshots/${SNAPSHOT}.sql "$@"
)

function beausimensen-mysql-snapshot-load() (
    SNAPSHOT="$1"
    shift
    beausimensen-mysql --execute="SET autocommit=0 ; source database/snapshots/${SNAPSHOT}.sql ; COMMIT ;" "$@"
)

function beausimensen-test-mysql-snapshot-create() (
    SNAPSHOT="$1"
    shift
    MYSQL_PWD=password
    beausimensen-test-mysqldump -u root --result-file=database/snapshots/${SNAPSHOT}.sql "$@"
)

function beausimensen-test-mysql-snapshot-load() (
    SNAPSHOT="$1"
    shift
    beausimensen-test-mysql --execute="SET autocommit=0 ; source database/snapshots/${SNAPSHOT}.sql ; COMMIT ;" "$@"
)


# Custom
alias beausimensen-dusk='beausimensen-test-artisan dusk'
alias beausimensen-fresh='beausimensen-artisan migrate:fresh'
alias beausimensen-test-fresh='beausimensen-artisan migrate:fresh'
alias beausimensen-ide='beausimensen-artisan ide-helper:generate && \
beausimensen-artisan ide-helper:models -M && \
beausimensen-artisan ide-helper:eloquent'
alias beausimensen-phpcbf='beausimensen-php vendor/bin/phpcbf'
alias beausimensen-phpcs='beausimensen-php vendor/bin/phpcs'
alias beausimensen-psalm='beausimensen-php vendor/bin/psalm --no-cache'
alias beausimensen-vapor='beausimensen-php vendor/bin/vapor'

function beausimensen-run {
    FILE="$1"
    shift
    KERNEL=$(cat <<__KERNEL__
require __DIR__ . '/vendor/autoload.php';
\$app = require __DIR__ . '/bootstrap/app.php';
\$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();
require_once '$FILE';
__KERNEL__
)
    beausimensen-php -r "$KERNEL" "$@"
}