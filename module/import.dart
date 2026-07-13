// https://github.com/Zeronetsec/Oliner

import 'dart:io';
import '../console/command_interface.dart';
import '../utils/color.dart';
import '../utils/missing_argument.dart';
import '../utils/notraversal.dart';
import '../utils/root.dart';

class Import implements Command {
    @override void execute(List<String> args) {
        if (args.length < 2) {
            MissingArgument();
        }

        var zipPath = args[1].trim();
        NoTraversal(zipPath);

        if (zipPath.startsWith('~')) {
            final home = Platform.environment['HOME'] ?? '';
            zipPath = zipPath.replaceFirst('~', home);
        }

        final zipFile = File(zipPath);
        if (!zipFile.existsSync()) {
            print("${R}[!] ${N}Zip file: ${GG}${zipPath} ${N}not found!");
            exit(1);
        }

        String targetExtractPath = '${Root}/data/user_data';
        for (int i = 2; i < args.length; i++) {
            if (
                args[i] == '--outsave' &&
                i + 1 < args.length
            ) {
                final customFolder = args[i + 1].trim();
                NoTraversal(customFolder);
                targetExtractPath = '${Root}/data/user_data/${customFolder}';
                break;
            }
        }

        final baseDir = Directory('${Root}/data/user_data');
        if (!baseDir.existsSync()) {
            baseDir.createSync(recursive: true);
        }

        print("${B}[*] ${N}Extracting: ${GG}${zipPath}${N}");

        try {
            final result = Process.runSync(
                'unzip',
                [
                    '-o',
                    zipFile.absolute.path,
                    '-d',
                    targetExtractPath,
                ],
            );

            if (result.exitCode == 0) {
                print("${GG}[+] ${N}Successfully imported to: ${GG}${targetExtractPath}/${N}");
                return;
            } else {
                print("${R}[!] ${N}Error: ${GG}${result.stderr}${N}");
                exit(1);
            }
        } catch (e) {
            print("${R}[!] ${N}Failed to execute unzip command!");
            exit(1);
        }
    }
}

// Copyright (c) 2026 Zeronetsec