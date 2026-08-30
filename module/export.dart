// https://github.com/Zeronetsec/Oliner

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
            print("${color_R}[!] ${color_N}Folder: ${color_GG}${sourcePath} ${color_N}does not exist!");
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

        print("${color_B}[*] ${color_N}Archiving: ${color_GG}${sourcePath}${color_N}");

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
                print("${color_GG}[+] ${color_N}Successfully exported to: ${color_GG}${outputPath}${color_N}");
                return;
            } else {
                print("${color_R}[!] ${color_N}Error: ${color_GG}${result.stderr}${color_N}");
                exit(1);
            }
        } catch (e) {
            print("${color_R}[!] ${color_N}Failed to execute zip command!");
            exit(1);
        }
    }
}

// Copyright (c) 2026 Zeronetsec