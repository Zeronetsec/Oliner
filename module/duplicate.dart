// https://github.com/Zeronetsec/Oliner

import 'dart:io';
import '../console/command_interface.dart';
import '../utils/color.dart';
import '../utils/missing_argument.dart';
import '../utils/notraversal.dart';
import '../utils/root.dart';

class Duplicate implements Command {
    @override void execute(List<String> args) {
        var targetPath = "";
        bool autoRemove = false;

        for (int i = 1; i < args.length; i++) {
            if (args[i] == '--autoremove') {
                autoRemove = true;
            } else if (targetPath.isEmpty) {
                targetPath = args[i].trim();
            }
        }

        if (targetPath.isNotEmpty) {
            NoTraversal(targetPath);
        }

        final baseSearchPath = '${Root}/data/user_data/${targetPath}';
        final targetDir = Directory(baseSearchPath);

        final isPathWithExtension = targetPath.endsWith(
            '.txtx',
        );

        final targetFile = File(
            isPathWithExtension ?
            baseSearchPath :
            '${baseSearchPath}.txtx',
        );

        print("${color_B}[*] ${color_N}Scanning duplicates: ${color_GG}data/user_data/${targetPath} ${color_DG}(${color_WW}AutoRemove: ${color_GG}${autoRemove ? '${color_GG}true' : '${color_YY}false'}${color_DG})${color_N}");
        print("");

        if (targetDir.existsSync()) {
            try {
                final entities = targetDir.listSync(
                    recursive: true,
                );

                for (var entity in entities) {
                    if (
                        entity is File &&
                        entity.path.endsWith('.txtx')
                    ) {
                        _processFile(entity, autoRemove);
                    }
                }
            } catch (e) {
                print("${color_R}[!] ${color_N}Error reading directory: ${color_GG}${e}${color_N}");
                exit(1);
            }
        } else if (targetFile.existsSync()) {
            _processFile(targetFile, autoRemove);
        } else {
            print("${color_R}[!] ${color_N}Path: ${color_GG}${targetPath} ${color_N}not found as file or folder!");
            exit(1);
        }
    }

    void _processFile(File file, bool autoRemove) {
        try {
            final lines = file.readAsLinesSync();
            final List<String> cleanLines = [];
            final Set<String> seenData = {};
            final List<String> duplicateReports = [];
            bool hasDuplicate = false;

            final parserRegex = RegExp(
                r'^([^:]+):\s*(link|code)\(([^)]+)\)(?:\.msg\(([^)]+)\))?',
            );

            for (int i = 0; i < lines.length; i++) {
                var line = lines[i];
                var trimmed = line.trim();

                if (
                    trimmed.isEmpty ||
                    trimmed.startsWith('#') ||
                    trimmed.startsWith('<')
                ) {
                    cleanLines.add(line);
                    continue;
                }

                var contentToCheck = trimmed;
                if (contentToCheck.contains('#')) {
                    final hashIndex = contentToCheck.indexOf('#');
                    contentToCheck = contentToCheck.substring(
                        0, hashIndex,
                    ).trim();
                }

                final match = parserRegex.firstMatch(contentToCheck);
                if (match != null) {
                    final uniqueKey = contentToCheck.toLowerCase();
                    if (seenData.contains(uniqueKey)) {
                        hasDuplicate = true;
                        duplicateReports.add(
                            "  ${color_DG}└── ${color_WW}line ${i + 1}: ${color_GG}${trimmed}${color_N}",
                        );
                        if (autoRemove) continue;
                    } else {
                        seenData.add(uniqueKey);
                    }
                }
                cleanLines.add(line);
            }

            if (hasDuplicate) {
                final shortPath = file.path.replaceAll(
                    '${Root}/data/user_data/', '',
                );

                print("${color_N}File: ${color_GG}${shortPath}${color_N}");
                print(duplicateReports.join('\n'));

                if (autoRemove) {
                    if (cleanLines.isEmpty) {
                        file.writeAsStringSync("");
                    } else {
                        file.writeAsStringSync(
                            cleanLines.join('\n') + '\n',
                        );
                    }
                    print("");
                    print("${color_GG}[+] ${color_N}Cleaned up.");
                    return;
                } else {
                    print("");
                    print("${color_YY}[!] ${color_N}Found duplicate!");
                }
            }
        } catch (_) {}
    }
}

// Copyright (c) 2026 Zeronetsec