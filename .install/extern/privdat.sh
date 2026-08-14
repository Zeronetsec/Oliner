function install::extern::privdat() {
    if [[ -d "${root}/.privdat" ]]; then
        echo -e "${B}[*] ${N}Setting up private data..."
        install::getinstall \
            "command rm -rf ${root}/data/user_data" \
            "Removing: ${GG}${root}/data/user_data${N}"

        install::getinstall \
            "
                command cp -r \
                    ${root}/.privdat \
                    ${root}/data/user_data
            " \
            "Copying: ${GG}${root}/.privdat ${DG}-> ${GG}${root}/data/user_data${N}"
    fi
}; readonly -f install::extern::privdat