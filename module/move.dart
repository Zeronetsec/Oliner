// https://github.com/Zeronetsec/Oliner

import 'dart:io';
import '../console/command_interface.dart';
import '../utils/color.dart';
import '../utils/missing_argument.dart';
import '../utils/notraversal.dart';
import '../utils/root.dart';

class Move implements Command {
    @override void execute(List<String> args) {
        if (args.length < 3) {
            MissingArgument();
        }

        final sourceInput = args[1].trim();
        final destInput = args[2].trim();

        NoTraversal(sourceInput);
        NoTraversal(destInput);

        final sourceDir = Directory(
            '${Root}/data/user_data/${sourceInput}',
        );

        final destDir = Directory(
            '${Root}/data/user_data/${destInput}',
        );

        if (sourceDir.existsSync()) {
            if (destDir.existsSync()) {
                print("${color_R}[!] ${color_N}Destination folder: ${color_GG}data/user_data/${destInput} ${color_N}already exists!");
                exit(1);
            }
            try {
                final parentDir = destDir.parent;
                if (!parentDir.existsSync()) {
                    parentDir.createSync(recursive: true);
                }

                sourceDir.renameSync(destDir.path);
                print("${color_GG}[+] ${color_N}Successfully moved folder to: ${color_GG}data/user_data/${destInput}${color_N}");
                return;
            } catch (e) {
                print("${color_R}[!] ${color_N}Error moving folder: ${color_GG}${e}${color_N}");
                exit(1);
            }
        }

        final sourceFilePath = sourceInput.endsWith(
            '.txtx',
        ) ? sourceInput : '${sourceInput}.txtx';

        final destFilePath = destInput.endsWith(
            '.txtx',
        ) ? destInput : '${destInput}.txtx';

        final sourceFile = File(
            '${Root}/data/user_data/${sourceFilePath}',
        );

        final destFile = File(
            '${Root}/data/user_data/${destFilePath}',
        );

        if (sourceFile.existsSync()) {
            if (destFile.existsSync()) {
                print("${color_R}[!] ${color_N}Destination file: ${color_GG}data/user_data/${destFilePath} ${color_N}already exists!");
                exit(1);
            }
            try {
                final parentDir = destFile.parent;
                if (!parentDir.existsSync()) {
                    parentDir.createSync(recursive: true);
                }

                sourceFile.renameSync(destFile.path);
                print("${color_GG}[+] ${color_N}Successfully moved file to: ${color_GG}data/user_data/${destFilePath}${color_N}");
                return;
            } catch (e) {
                print("${color_R}[!] ${color_N}Error moving file: ${color_GG}${e}${color_N}");
                exit(1);
            }
            return;
        }
        print("${color_R}[!] ${color_N}Source path: ${color_GG}${sourceInput} ${color_N}not found as file or folder!");
        exit(1);
    }
}

// Copyright (c) 2026 Zeronetsec