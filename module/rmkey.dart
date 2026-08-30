// https://github.com/Zeronetsec/Oliner

import 'dart:io';
import '../console/command_interface.dart';
import '../utils/color.dart';
import '../utils/missing_argument.dart';
import '../utils/notraversal.dart';
import '../utils/root.dart';

class Rmkey implements Command {
    @override void execute(List<String> args) {
        if (args.length < 3) {
            MissingArgument();
        }

        var targetPath = args[1];
        final keyToRemove = args[2].trim();
        NoTraversal(targetPath);

        if (!targetPath.endsWith('.txtx')) {
            targetPath = "${targetPath}.txtx";
        }

        final file = File(
            '${Root}/data/user_data/${targetPath}',
        );

        if (!file.existsSync()) {
            print("${color_R}[!] ${color_N}File ${color_GG}data/user_data/${targetPath} ${color_N}not found!");
            exit(1);
        }

        try {
            final lines = file.readAsLinesSync();
            final List<String> updatedLines = [];
            bool isKeyFound = false;

            final keyRegex = RegExp(
                '^' + RegExp.escape(keyToRemove) + r'\s*:',
            );

            for (var line in lines) {
                final trimmed = line.trim();
                if (keyRegex.hasMatch(trimmed)) {
                    isKeyFound = true;
                    continue;
                }
                updatedLines.add(line);
            }

            if (!isKeyFound) {
                print("${color_R}[!] ${color_N}Key: ${color_GG}${keyToRemove} ${color_N}not found in this file!");
                exit(1);
            }

            if (updatedLines.isEmpty) {
                file.writeAsStringSync("");
            } else {
                file.writeAsStringSync(
                    updatedLines.join('\n') + '\n',
                );
            }
            print("${color_GG}[+] ${color_N}Successfully removed key: ${color_GG}${keyToRemove} ${color_N}from ${color_GG}data/user_data/${targetPath}${color_N}");
            return;
        } catch (e) {
            print("${color_R}[!] ${color_N}Error modifying file: ${color_GG}${e}${color_N}");
            exit(1);
        }
    }
}

// Copyright (c) 2026 Zeronetsec