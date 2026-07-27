function install::installer() {
    (
        cd "${opt}/${targetins}"
        install::getinstall \
            "
                command dart compile exe \
                    ${targetins}.dart \
                    -o ${targetins}
            " \
            "Compiling: ${GG}${targetins}${N}"
    )
}; readonly -f install::installer