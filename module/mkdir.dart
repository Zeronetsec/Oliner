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
            print("${R}[!] ${N}Folder: ${GG}data/user_data/${targetPath} ${N}already exists!");
            exit(1);
        }

        try {
            directory.createSync(recursive: true);
            print("${GG}[+] ${N}Successfully created folder: ${GG}data/user_data/${targetPath}${N}");
            return;
        } catch (e) {
            print("${R}[!] ${N}Error creating folder: ${GG}${e}${N}");
            exit(1);
        }
    }
}