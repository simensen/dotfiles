function flando () (
    ssh -t vagrant@fool "cd $PWD 2>/dev/null && lando "$@" || echo Not in a lando site"
)
