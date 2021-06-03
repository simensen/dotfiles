function elando () (
    ELANDO_HOST="vagrant@evergiven"

    CANDIDATE_DIR="$(pwd)"
    while [ -n "$CANDIDATE_DIR" -a "$CANDIDATE_DIR" != '/' ]; do
        echo "... checking ${CANDIDATE_DIR}"
        if [ -f "${CANDIDATE_DIR}/.elando" ]; then
            break
        fi

        CANDIDATE_DIR="$(dirname "$CANDIDATE_DIR")"
    done

    if [ -n "$CANDIDATE_DIR" -a "$CANDIDATE_DIR" != '/' ]; then
        . "${CANDIDATE_DIR}/.elando"
    fi

    ssh -t "$ELANDO_HOST" "cd $PWD 2>/dev/null && lando "$@" || echo Not in a lando site"
)
