#!/bin/sh

echo "Cloning repositories..."

CODE=$HOME/Code
DFLYDEV=$CODE/dflydev
LARAVEL=$CODE/laravel
SITES=$CODE/sites
CLIENTS=$CODE/clients
BLACKFIRE=$CODE/blackfire

pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

__derive_repo_dir() {
    echo "$(basename "$1" .git)"
}

__derive_repo_url() {
    echo "git@github.com:$1.git"
}

__derive_fork_repo_url() {
    ID="$1"
    REPO_DIR="$2"
    USERNAME="$(echo "$ID" | cut -f1 -d:)"
    REPOSITORY="$(echo "$ID" | cut -s -f2 -d:)"

    echo "git@github.com:$USERNAME/${REPOSITORY:=$REPO_DIR}.git"
}

__derive_remote_name() {
    echo "$(echo "$1" | cut -f2 -d: | cut -f1 -d/)"
}

__sync_remote() (
    DIR="$1"
    REMOTE="$2"
    URL="$3"

    pushd "$DIR"
    CURRENT_URL="$(git remote get-url "$REMOTE" 2>/dev/null)"
    if [ "$CURRENT_URL" != "$URL" ]
    then
        if [ ! -z "$CURRENT_URL" ]
        then
            printf " * renaming original remote \"${REMOTE}\" to \"${REMOTE}-$$\""
            git remote rename "${REMOTE}" "${REMOTE}-$$" 2>/dev/null || printf ' FAILED'
            echo
        fi
        printf " * adding remote \"${REMOTE}\" (${URL})"
        git remote add "${REMOTE}" "${URL}" 2>/dev/null || printf ' FAILED'
        echo
    fi
    popd
)

__clone() (
    ALIAS="$1"
    ORIGIN="$(__derive_repo_url "$ALIAS")"
    DIR="${2:-$CODE}"
    shift; shift

    echo "Cloning ${ALIAS}"

    REPO_DIR="$(__derive_repo_dir "$ORIGIN")"

    if [ -e "$DIR/$REPO_DIR/.git" ]
    then
        __sync_remote "$DIR/$REPO_DIR" origin "$ORIGIN"
    elif [ -e "$DIR/$REPO_DIR" ]
    then
        pushd "$DIR/$REPO_DIR"
        git init . >/dev/null 2>&1
        git remote add origin "$ORIGIN" >/dev/null 2>&1
        git fetch origin 2>/dev/null

        if [ ! -z "$(git branch -a | grep origin/main)" ]
        then
            printf " * checking out main"
            git checkout -b main --track origin/main >/dev/null 2>&1 && \
                git rebase origin/main >/dev/null 2>&1 \
                || printf ' FAILED'
            echo
        elif [ ! -z "$(git branch -a | grep origin/master)" ]
        then
            printf " * checking out master"
            git checkout -b master --track origin/master >/dev/null 2>&1 && \
                git rebase origin/master >/dev/null 2>&1 \
                || printf ' FAILED'
            echo
        fi

        popd
    else
        printf " * cloning \"${ORIGIN}\""
        mkdir -p "$DIR"
        git clone $ORIGIN $DIR/$REPO_DIR 2>/dev/null || printf ' FAILED'
        echo
    fi

    for FORK in "$@"
    do
        FORK_URL=$(__derive_fork_repo_url "$FORK" "$REPO_DIR")

        __sync_remote "$DIR/$REPO_DIR" "$(__derive_remote_name "$FORK_URL")" "$FORK_URL"
    done
)

clone() (
    ORIGIN="$1"
    shift;

    __clone "$ORIGIN" "$CODE" "$@"
)

clone_dflydev() (
    ORIGIN="$1"
    shift;

    __clone "$ORIGIN" "$DFLYDEV" "$@"
)

clone_laravel() (
    ORIGIN="$1"
    shift;

    __clone "$ORIGIN" "$LARAVEL" "$@"
)

clone_site() (
    ORIGIN="$1"
    shift;

    __clone "$ORIGIN" "$SITES" "$@"
)

clone_client() (
    CLIENT="$1"
    ORIGIN="$2"
    shift;

    __clone "$ORIGIN" "$CLIENTS/$CLIENT" "$@"
)

clone_blackfire() (
    ORIGIN="$1"
    shift;

    __clone "$ORIGIN" "$BLACKFIRE" "$@"
)

#
# Clone a GitHub repo in the appropriate directory
#
# "username/repo" is always the first argument and will be treated as origin.
#
# All additional arguments are treated as forks. Forks can be just a username
# or they can be a username and the name of the fork if it is different.
#
# In all cases, the username will be the name of any additional remotes.
#
# A simple example would be username "simensen" having a fork of "laravel/valet"
# where the fork is named "simensen/valet".
#
# $ clone_laravel laravel/valet simensen
#
# * origin	git@github.com:laravel/valet.git (fetch)
# * origin	git@github.com:laravel/valet.git (push)
# * simensen	git@github.com:simensen/laravel-valet.git (fetch)
# * simensen	git@github.com:simensen/laravel-valet.git (push)
#
# For example, username "simensen" has a fork of "laravel/framework" but is
# named "simensen/laravel-framework".
#
# To treat "laravel/framework" as "origin" and to treat
# "simensen/laravel-framework" as "simensen", the
# following would be used:
#
# $ clone_laravel laravel/laravel simensen:laravel-framework
#
# * origin	git@github.com:laravel/framework.git (fetch)
# * origin	git@github.com:laravel/framework.git (push)
# * simensen	git@github.com:simensen/laravel-framework.git (fetch)
# * simensen	git@github.com:simensen/laravel-framework.git (push)
#

# Sites

# Valet will be parked in this directory

clone_site dflydev/beausimensen
clone_site dflydev/dflydev
clone_site dflydev/ninjacraft
clone_site dflydev/ninjagrl.com
clone_site dflydev/prdeploy
clone_site thatpodcast/thatpodcast


# Clients

clone_site dflydev/app.cpapdropship.com
clone_site homeownership-wa/whrc-portal dflydev tighten:washington-homeownership-resource-center


# dflydev tools

clone dflydev/traefik-development


# dflydev projects

clone_dflydev dflydev/dflydev-fig-cookies simensen


# dflydev projects (without forks... yet...)

clone_dflydev dflydev/check-runs-action
clone_dflydev dflydev/contrail
clone_dflydev dflydev/dflydev-dot-access-data


# Laravel

clone_laravel laravel/docs simensen:laravel-docs
clone_laravel laravel/framework simensen:laravel-framework
clone_laravel laravel/laravel simensen
clone_laravel laravel/vapor-cli simensen
clone_laravel laravel/vapor-core simensen
clone_laravel laravel/valet simensen:laravel-valet


# Blackfire

clone_blackfire blackfireio/metrics simensen:blackfireio-metrics
clone_blackfire blackfireio/docs simensen:blackfireio-docs


# OSS projects
clone EventSaucePHP/EventSauce simensen
