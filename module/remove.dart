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
                print("${GG}[+] ${N}Successfully removed folder: ${GG}data/user_data/${inputPath}${N}");
                return;
            } 

            if (targetFile.existsSync()) {
                targetFile.deleteSync();
                print("${GG}[+] ${N}Successfully removed file: ${GG}${filePathString}${N}");
                return;
            }

            print("${R}[!] ${N}Path: ${GG}data/user_data/${inputPath} ${N}not found as file or folder!");
            exit(1);
        } catch (e) {
            print("${R}[!] ${N}Error deleting target: ${GG}${e}${N}");
            exit(1);
        }
    }
}