// https://github.com/Zeronetsec/Oliner

import 'dart:io';
import '../console/command_interface.dart';
import '../utils/color.dart';
import '../utils/missing_argument.dart';
import '../utils/notraversal.dart';
import '../utils/root.dart';

class Mkdir implements Command {
    @override void execute(List<String> args) {
        if (args.length < 2) {
            MissingArgument();
        }

        final targetPath = args[1];
        NoTraversal(targetPath);

        final directory = Directory(
            '${Root}/data/user_data/${targetPath}',
        );

        if (directory.existsSync()) {
            print("${color_R}[!] ${color_N}Folder: ${color_GG}data/user_data/${targetPath} ${color_N}already exists!");
            exit(1);
        }

        try {
            directory.createSync(recursive: true);
            print("${color_GG}[+] ${color_N}Successfully created folder: ${color_GG}data/user_data/${targetPath}${color_N}");
            return;
        } catch (e) {
            print("${color_R}[!] ${color_N}Error creating folder: ${color_GG}${e}${color_N}");
            exit(1);
        }
    }
}

// Copyright (c) 2026 Zeronetsec