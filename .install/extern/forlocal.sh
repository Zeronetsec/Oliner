function install::extern::forlocal() {
    if [[ -d "${root}/.privdat" ]]; then
        command rm -rf "${root}/data/user_data"
        command mv \
            "${root}/.privdat" \
            "${root}/data/user_data"
    fi
}