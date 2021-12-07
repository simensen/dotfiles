function essh_run () (
    ESSH_HOST="vagrant@evergiven"

    CANDIDATE_DIR="$(pwd)"
    while [ -n "$CANDIDATE_DIR" -a "$CANDIDATE_DIR" != '/' ]; do
        if [ -f "${CANDIDATE_DIR}/.essh" ]; then
            break
        fi

        CANDIDATE_DIR="$(dirname "$CANDIDATE_DIR")"
    done

    if [ -n "$CANDIDATE_DIR" -a "$CANDIDATE_DIR" != '/' ]; then
        . "${CANDIDATE_DIR}/.essh"
    fi

    ssh -o LogLevel=QUIET -t -t "$ESSH_HOST" "if test -d $PWD; then cd $PWD && "$@"; else echo 'Path $PWD does not exist on $ESSH_HOST'; fi"
)
