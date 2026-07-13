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
            print("${R}[!] ${N}File ${GG}data/user_data/${targetPath} ${N}not found!");
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
                print("${R}[!] ${N}Key: ${GG}${keyToRemove} ${N}not found in this file!");
                exit(1);
            }

            if (updatedLines.isEmpty) {
                file.writeAsStringSync("");
            } else {
                file.writeAsStringSync(
                    updatedLines.join('\n') + '\n',
                );
            }
            print("${GG}[+] ${N}Successfully removed key: ${GG}${keyToRemove} ${N}from ${GG}data/user_data/${targetPath}${N}");
            return;
        } catch (e) {
            print("${R}[!] ${N}Error modifying file: ${GG}${e}${N}");
            exit(1);
        }
    }
}