// https://github.com/Zeronetsec/Oliner

import 'dart:io';
import '../console/command_interface.dart';
import '../utils/color.dart';
import '../utils/missing_argument.dart';
import '../utils/notraversal.dart';
import '../utils/root.dart';

class Remove implements Command {
    @override void execute(List<String> args) {
        if (args.length < 2) {
            MissingArgument();
        }

        final inputPath = args[1];
        NoTraversal(inputPath);

        final targetDir = Directory(
            '${Root}/data/user_data/${inputPath}',
        );

        final filePathString = inputPath.endsWith('.txtx') ?
            'data/user_data/${inputPath}' :
            'data/user_data/${inputPath}.txtx';
        final targetFile = File(filePathString);

        try {
            if (targetDir.existsSync()) {
                targetDir.deleteSync(recursive: true);
                print("${color_GG}[+] ${color_N}Successfully removed folder: ${color_GG}data/user_data/${inputPath}${color_N}");
                return;
            }

            if (targetFile.existsSync()) {
                targetFile.deleteSync();
                print("${color_GG}[+] ${color_N}Successfully removed file: ${color_GG}${filePathString}${color_N}");
                return;
            }

            print("${color_R}[!] ${color_N}Path: ${color_GG}data/user_data/${inputPath} ${color_N}not found as file or folder!");
            exit(1);
        } catch (e) {
            print("${color_R}[!] ${color_N}Error deleting target: ${color_GG}${e}${color_N}");
            exit(1);
        }
    }
}

// Copyright (c) 2026 Zeronetsec