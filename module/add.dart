// https://github.com/Zeronetsec/Oliner

import 'dart:io';
import '../console/command_interface.dart';
import '../utils/color.dart';
import '../utils/missing_argument.dart';
import '../utils/notraversal.dart';
import '../utils/root.dart';

class Add implements Command {
    @override void execute(List<String> args) {
        if (args.length < 2) {
            MissingArgument();
        }

        var targetPath = args[1];
        NoTraversal(targetPath);

        if (!targetPath.endsWith('.txtx')) {
            targetPath = "${targetPath}.txtx";
        }

        final file = File(
            '${Root}/data/user_data/${targetPath}',
        );

        String dataToWrite = "";
        if (args.length >= 3) {
            dataToWrite = args[2];
        } else {
            stdout.write("${color_N}Addline: ${color_GG}");
            final input = stdin.readLineSync();

            if (
                input == null ||
                input.trim().isEmpty
            ) {
                print("${color_R}[!] ${color_N}Input cannot be empty!");
                print("${color_R}[!] ${color_N}Canceled!");
                exit(1);
            }
            dataToWrite = input.trim();
        }

        try {
            if (!file.existsSync()) {
                file.createSync(recursive: true);
            }

            final currentContent = file.readAsStringSync();
            if (
                currentContent.isEmpty ||
                currentContent.endsWith('\n')
            ) {
                file.writeAsStringSync(
                    "${dataToWrite}\n",
                    mode: FileMode.append,
                );
            } else {
                file.writeAsStringSync(
                    "\n${dataToWrite}\n",
                    mode: FileMode.append,
                );
            }
            print("${color_GG}[+] ${color_N}Successfully added to: ${color_GG}data/user_data/${targetPath}${color_N}");
            return;
        } catch (e) {
            print("${color_R}[!] ${color_N}Error writing to file: ${color_GG}${e}${color_N}");
            exit(1);
        }
    }
}

// Copyright (c) 2026 Zeronetsec