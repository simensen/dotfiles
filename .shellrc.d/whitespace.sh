whitespace() {
    echo "$@" | sed 's/ /·/g;s/\t/￫/g;s/\r/§/g;s/$/¶/g'
}
