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
                print("${R}[!] ${N}Destination folder: ${GG}data/user_data/${destInput} ${N}already exists!");
                exit(1);
            }
            try {
                final parentDir = destDir.parent;
                if (!parentDir.existsSync()) {
                    parentDir.createSync(recursive: true);
                }

                sourceDir.renameSync(destDir.path);
                print("${GG}[+] ${N}Successfully moved folder to: ${GG}data/user_data/${destInput}${N}");
                return;
            } catch (e) {
                print("${R}[!] ${N}Error moving folder: ${GG}${e}${N}");
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
                print("${R}[!] ${N}Destination file: ${GG}data/user_data/${destFilePath} ${N}already exists!");
                exit(1);
            }
            try {
                final parentDir = destFile.parent;
                if (!parentDir.existsSync()) {
                    parentDir.createSync(recursive: true);
                }

                sourceFile.renameSync(destFile.path);
                print("${GG}[+] ${N}Successfully moved file to: ${GG}data/user_data/${destFilePath}${N}");
                return;
            } catch (e) {
                print("${R}[!] ${N}Error moving file: ${GG}${e}${N}");
                exit(1);
            }
            return;
        }
        print("${R}[!] ${N}Source path: ${GG}${sourceInput} ${N}not found as file or folder!");
        exit(1);
    }
}