function install::extern::privdat() {
    if [[ -d "${root}/.privdat" ]]; then
        echo -e "${color_B}[*] ${color_N}Setting up private data..."
        install::getinstall \
            "command rm -rf ${root}/data/user_data" \
            "Removing: ${color_GG}${root}/data/user_data${color_N}"

        install::getinstall \
            "
                command cp -r \
                    ${root}/.privdat \
                    ${root}/data/user_data
            " \
            "Copying: ${color_GG}${root}/.privdat ${color_DG}-> ${color_GG}${root}/data/user_data${color_N}"
    fi
}; readonly -f install::extern::privdat