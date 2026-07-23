function install::installer() {
    if [[ "${__BACKUP__}" == true && -d "${opt}/oliner" ]]; then
        (
            cd "${opt}"
            install::getinstall \
                "
                    command zip -r \
                        oliner_${bkdate}.bak.zip \
                        oliner
                " \
                "Backup: ${GG}${opt}/oliner ${DG}-> ${GG}${opt}/oliner_${bkdate}.bak.zip${N}"
            cd
        )
    fi

    if [[ -d "${opt}/oliner" ]]; then
        install::getinstall \
            "command rm -rf ${opt}/oliner" \
            "Removing old source..."
    fi

    install::getinstall \
        "command mv ${root} ${opt}/oliner" \
        "Moving: ${GG}${root} ${DG}-> ${GG}${opt}/oliner${N}"

    (
        cd "${opt}/oliner"
        install::getinstall \
            "
                command dart compile \
                exe oliner.dart \
                -o oliner
            " \
            "Building: ${GG}oliner${N}"
    )

    install::getinstall \
        "
            command ln -sf \
                ${opt}/oliner/oliner \
                ${bin}/oliner
        " \
        "Symlink: ${GG}${opt}/oliner/oliner ${DG}-> ${GG}${bin}/oliner${N}"
}; readonly -f install::installer