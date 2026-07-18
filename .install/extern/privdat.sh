function install::extern::privdat() {
    if [[ -d "${root}/.privdat" ]]; then
        echo -e "${B}[*] ${N}Setting up private data..."
        command rm -rf "${root}/data/user_data"
        command mv \
            "${root}/.privdat" \
            "${root}/data/user_data"
    fi
}