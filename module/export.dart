import 'dart:io';
import '../console/command_interface.dart';
import '../utils/color.dart';
import '../utils/missing_argument.dart';
import '../utils/notraversal.dart';
import '../utils/path.dart';
import '../utils/root.dart';

class Export implements Command {
    @override void execute(List<String> args) {
        if (args.length < 2) {
            MissingArgument();
        }

        final targetFolder = args[1].trim();
        NoTraversal(targetFolder);

        final sourcePath = '${Root}/data/user_data/${targetFolder}';
        final sourceDir = Directory(sourcePath);

        if (!sourceDir.existsSync()) {
            print("${R}[!] ${N}Folder: ${GG}${sourcePath} ${N}does not exist!");
            exit(1);
        }

        String outputPath = "${targetFolder}.zip";
        for (int i = 2; i < args.length; i++) {
            if (args[i] == '--out' && i + 1 < args.length) {
                outputPath = args[i + 1].trim();
                break;
            }
        }

        if (outputPath.startsWith('~')) {
            final home = Platform.environment['HOME'] ?? '';
            outputPath = outputPath.replaceFirst('~', home);
        }

        print("${B}[*] ${N}Archiving: ${GG}${sourcePath}${N}");

        try {
            final result = Process.runSync(
                'zip', 
                [
                    '-r',
                    '-q',
                    Path.getAbsolutePath(outputPath),
                    targetFolder,
                ],
                workingDirectory: '${Root}/data/user_data',
            );

            if (result.exitCode == 0) {
                print("${GG}[+] ${N}Successfully exported to: ${GG}${outputPath}${N}");
                return;
            } else {
                print("${R}[!] ${N}Error: ${GG}${result.stderr}${N}");
                exit(1);
            }
        } catch (e) {
            print("${R}[!] ${N}Failed to execute zip command!");
            exit(1);
        }
    }
}