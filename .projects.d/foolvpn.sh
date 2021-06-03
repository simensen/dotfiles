function foolvpn-up() (
    set +o allexport
    FOOLVPN_USERNAME="$(jq -r '.username' $HOME/.config/foolvpn/credentials.json)"
    FOOLVPN_PASSWORD="$(jq -r '.password' $HOME/.config/foolvpn/credentials.json)"
    echo "Connecting as $FOOLVPN_USERNAME"
    printf '%s' "$FOOLVPN_PASSWORD" | sudo openconnect vpn.foolhq.com --user="$FOOLVPN_USERNAME" --passwd-on-stdin --authgroup="Split Tunnel" "$@"
)

function foolvpn-down() (
    echo kill vpn
)

function foolvpn() (
    mkdir -p $HOME/.config/foolvpn
    if [ ! -f $HOME/.config/foolvpn/credentials.json ]; then
        unset -v FOOLVPN_USERNAME
        unset -v FOOLVPN_PASSWORD
        set +o allexport
        read -r 'FOOLVPN_USERNAME?Please enter your username: '
        IFS= read -rs 'FOOLVPN_PASSWORD?Please enter your password: '
        echo
        printf '{"username":"%s","password":"%s"}\n' "$FOOLVPN_USERNAME" "$FOOLVPN_PASSWORD" > $HOME/.config/foolvpn/credentials.json
        chmod 400 $HOME/.config/foolvpn/credentials.json
    fi
    CMD="$1"
    shift
    if [ "$CMD" = "up" ]; then
        foolvpn-up "$@"
    fi
    if [ "$CMD" = "down" ]; then
        foolvpn-down "$@"
    fi
)
