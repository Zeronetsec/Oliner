// https://github.com/Zeronetsec/Oliner

import 'dart:io';
import '../console/command_interface.dart';
import '../utils/color.dart';
import '../utils/missing_argument.dart';
import '../utils/notraversal.dart';
import '../utils/root.dart';

class Search implements Command {
    @override void execute(List<String> args) {
        if (args.length < 2) {
            MissingArgument();
        }

        final keyword = args[1].trim().toLowerCase();
        var targetPath = "";

        if (args.length >= 3) {
            targetPath = args[2].trim();
            NoTraversal(targetPath);
        }

        final baseSearchPath = '${Root}/data/user_data/${targetPath}';
        final targetDir = Directory(baseSearchPath);

        final isPathWithExtension = targetPath.endsWith('.txtx');
        final targetFile = File(
            isPathWithExtension ?
            baseSearchPath :
            '${baseSearchPath}.txtx',
        );

        print("${B}[*] ${N}Searching for: ${GG}${keyword} ${N}in ${GG}data/user_data/${targetPath}${N}");
        print("");

        int totalMatches = 0;
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
                        totalMatches += _searchInFile(
                            entity, keyword,
                        );
                    }
                }
            } catch (e) {
                print("${R}[!] ${N}Error reading directory: ${GG}${e}${N}");
                exit(1);
            }
        } else if (targetFile.existsSync()) {
            totalMatches += _searchInFile(
                targetFile, keyword,
            );
        } else {
            print("${R}[!] ${N}Path: ${GG}${targetPath} ${N}not found as file or folder!");
            exit(1);
        }
        print("");
        print("${B}[*] ${N}Total found: ${GG}${totalMatches}${N}");
        return;
    }

    int _searchInFile(File file, String keyword) {
        int matchesCount = 0;
        bool fileHeaderPrinted = false;

        try {
            final lines = file.readAsLinesSync();
            final globalRegex = RegExp(r'<(.*)>');
            final parserRegex = RegExp(
                r'^([^:]+):\s*(link|code)\(([^)]+)\)(?:\.msg\(([^)]+)\))?',
            );

            for (int i = 0; i < lines.length; i++) {
                var line = lines[i];
                var trimmed = line.trim();

                if (
                    trimmed.contains('#') &&
                    !trimmed.startsWith('#')
                ) {
                    final hashIndex = trimmed.indexOf('#');
                    trimmed = trimmed.substring(
                        0, hashIndex,
                    ).trim();
                }

                final globalMatch = globalRegex.firstMatch(
                    trimmed,
                );

                if (globalMatch != null) {
                    final currentGlobalMsg = globalMatch.group(
                        1,
                    ) ?? "";

                    if (
                        currentGlobalMsg.toLowerCase().contains(
                            keyword,
                        )
                    ) {
                        if (!fileHeaderPrinted) {
                            print("${N}File: ${GG}${file.path.replaceAll('${Root}/data/user_data/', '')}${N}");
                            fileHeaderPrinted = true;
                        }
                        print("  ${DG}└── ${WW}line ${i + 1}: ${WW}globalmsg match: ${YY}${currentGlobalMsg}${N}");
                        matchesCount++;
                    }
                    continue;
                }

                if (
                    trimmed.startsWith('#') ||
                    trimmed.isEmpty
                ) {
                    continue;
                }

                final match = parserRegex.firstMatch(
                    trimmed,
                );

                if (match != null) {
                    final key = match.group(1)?.trim() ?? '';
                    final type = match.group(2) ?? '';
                    final value = match.group(3) ?? '';
                    final msg = match.group(4) ?? '';

                    if (
                        key.toLowerCase().contains(keyword) ||
                        value.toLowerCase().contains(keyword) ||
                        msg.toLowerCase().contains(keyword)
                    ) {
                        if (!fileHeaderPrinted) {
                            print("${N}File: ${GG}${file.path.replaceAll('${Root}/data/user_data/', '')}${N}");
                            fileHeaderPrinted = true;
                        }

                        final msgPart = msg.isNotEmpty ?
                            " ${DG}(${CC}${msg}${DG})" :
                            "";
                        final valueColor = (type == 'link') ? GG : B;

                        print("  ${DG}└── ${WW}line ${i + 1}: ${GG}match ${DG}-> ${WW}${key}: ${valueColor}${value}${msgPart}${N}");
                        matchesCount++;
                    }
                }
            }
        } catch (_) {}
        return matchesCount;
    }
}

// Copyright (c) 2026 Zeronetsec