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
            stdout.write("${N}Addline: ${GG}");
            final input = stdin.readLineSync();

            if (
                input == null ||
                input.trim().isEmpty
            ) {
                print("${R}[!] ${N}Input cannot be empty!");
                print("${R}[!] ${N}Canceled!");
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
            print("${GG}[+] ${N}Successfully added to: ${GG}data/user_data/${targetPath}${N}");
            return;
        } catch (e) {
            print("${R}[!] ${N}Error writing to file: ${GG}${e}${N}");
            exit(1);
        }
    }
}