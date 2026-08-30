function install::installer() {
    (
        cd "${opt}/${targetins}"
        install::getinstall \
            "
                command dart compile exe \
                    ${targetins}.dart \
                    -o ${targetins}
            " \
            "Compiling: ${color_GG}${targetins}${color_N}"
    )
}; readonly -f install::installer