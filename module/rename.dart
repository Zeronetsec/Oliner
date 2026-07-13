// https://github.com/Zeronetsec/Oliner

import 'dart:io';
import '../console/command_interface.dart';
import '../utils/color.dart';
import '../utils/missing_argument.dart';
import '../utils/notraversal.dart';
import '../utils/root.dart';

class Rename implements Command {
    @override void execute(List<String> args) {
        if (args.length < 3) {
            MissingArgument();
        }

        final oldInput = args[1].trim();
        final newInput = args[2].trim();

        NoTraversal(oldInput);
        NoTraversal(newInput);

        final oldDir = Directory(
            '${Root}/data/user_data/${oldInput}',
        );

        final newDir = Directory(
            '${Root}/data/user_data/${newInput}',
        );

        if (oldDir.existsSync()) {
            if (newDir.existsSync()) {
                print("${R}[!] ${N}Destination folder: ${GG}data/user_data/${newInput} ${N}already exists!");
                exit(1);
            }

            try {
                oldDir.renameSync(newDir.path);
                print("${GG}[+] ${N}Successfully renamed folder to: ${GG}data/user_data/${newInput}${N}");
                return;
            } catch (e) {
                print("${R}[!] ${N}Error renaming folder: ${GG}${e}${N}");
                exit(1);
            }
        }

        final oldFilePath = oldInput.endsWith('.txtx') ?
            oldInput :
            '${oldInput}.txtx';

        final newFilePath = newInput.endsWith('.txtx') ?
            newInput :
            '${newInput}.txtx';

        final oldFile = File(
            '${Root}/data/user_data/${oldFilePath}',
        );

        final newFile = File(
            '${Root}/data/user_data/${newFilePath}',
        );

        if (oldFile.existsSync()) {
            if (newFile.existsSync()) {
                print("${R}[!] ${N}Destination file: ${GG}data/user_data/${newFilePath} ${N}already exists!");
                exit(1);
            }

            try {
                final parentDir = newFile.parent;
                if (!parentDir.existsSync()) {
                    parentDir.createSync(recursive: true);
                }
                oldFile.renameSync(newFile.path);
                print("${GG}[+] ${N}Successfully renamed file to: ${GG}data/user_data/${newFilePath}${N}");
                return;
            } catch (e) {
                print("${R}[!] ${N}Error renaming file: ${GG}${e}${N}");
                exit(1);
            }
            return;
        }
        print("${R}[!] ${N}Source path: ${GG}${oldInput} ${N}not found as file or folder!");
        exit(1);
    }
}

// Copyright (c) 2026 Zeronetsec