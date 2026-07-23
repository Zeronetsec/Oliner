function install::extern::privdat() {
    if [[ -d "${root}/.privdat" ]]; then
        echo -e "${B}[*] ${N}Setting up private data..."
        command rm -rf "${root}/data/user_data"
        command cp -r \
            "${root}/.privdat" \
            "${root}/data/user_data"
    fi
}; readonly -f install::extern::privdat