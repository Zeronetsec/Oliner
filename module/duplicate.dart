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

        print("${B}[*] ${N}Scanning duplicates: ${GG}data/user_data/${targetPath} ${DG}(${WW}AutoRemove: ${GG}${autoRemove ? '${GG}true' : '${YY}false'}${DG})${N}");
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
                print("${R}[!] ${N}Error reading directory: ${GG}${e}${N}");
                exit(1);
            }
        } else if (targetFile.existsSync()) {
            _processFile(targetFile, autoRemove);
        } else {
            print("${R}[!] ${N}Path: ${GG}${targetPath} ${N}not found as file or folder!");
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
                            "  ${DG}└── ${WW}line ${i + 1}: ${GG}${trimmed}${N}",
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

                print("${N}File: ${GG}${shortPath}${N}");
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
                    print("${GG}[+] ${N}Cleaned up.${N}");
                    return;
                } else {
                    print("");
                    print("${YY}[!] ${N}Found duplicate!");
                }
            }
        } catch (_) {}
    }
}

// Copyright (c) 2026 Zeronetsec