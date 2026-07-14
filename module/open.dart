// https://github.com/Zeronetsec/Oliner

import 'dart:io';
import '../console/command_interface.dart';
import '../utils/color.dart';
import '../utils/missing_argument.dart';
import '../utils/notraversal.dart';
import '../utils/root.dart';

class Open implements Command {
    @override void execute(List<String> args) {
        if (args.length < 3) {
            MissingArgument();
        }

        var targetPath = args[1].trim();
        final targetKey = args[2].trim();

        NoTraversal(targetPath);
        if (
            !targetPath.endsWith('.txtx')
        ) targetPath = "${targetPath}.txtx";

        final file = File(
            '${Root}/data/user_data/${targetPath}',
        );

        if (!file.existsSync()) {
            print("${R}[!] ${N}File ${GG}data/user_data/${targetPath} ${N}not found!");
            exit(1);
        }

        String? customCommand;
        for (int i = 3; i < args.length; i++) {
            if (
                args[i] == '--with' &&
                i + 1 < args.length
            ) {
                customCommand = args[i + 1];
                break;
            }
        }

        try {
            final lines = file.readAsLinesSync();
            final parserRegex = RegExp(
                r'^([^:]+):\s*(link|code)\(([^)]+)\)(?:\.msg\(([^)]+)\))?',
            );

            String? foundValue;
            String? foundType;

            for (var line in lines) {
                var trimmed = line.trim();
                if (
                    trimmed.contains('#') &&
                    !trimmed.startsWith('#')
                ) {
                    trimmed = trimmed.substring(
                        0, trimmed.indexOf('#')
                    ).trim();
                }

                final match = parserRegex.firstMatch(
                    trimmed,
                );

                if (match != null) {
                    final key = match.group(1)?.trim() ?? '';
                    if (key == targetKey) {
                        foundType = match.group(2);
                        foundValue = match.group(3);
                        break;
                    }
                }
            }

            if (
                foundValue == null ||
                foundType == null
            ) {
                print("${R}[!] ${N}Key: ${GG}${targetKey} ${N}not found in this file!");
                exit(1);
            }

            if (foundType == 'code') {
                print("${R}[!] ${N}Access Denied!");
                print("${R}[!] ${N}Cannot open type: ${B}code()${N}");
                exit(1);
            }

            print("${B}[*] ${N}Opening: ${GG}${foundValue}${N}");

            if (customCommand != null) {
                _runCustomCommand(
                    customCommand, foundValue,
                );
            } else {
                _runDefaultOpen(foundValue);
            }
        } catch (e) {
            print("${R}[!] ${N}Error processing request: ${GG}${e}${N}");
            exit(1);
        }
    }

    void _runDefaultOpen(String value) {
        final isTermux = Platform.environment.containsKey(
            'PREFIX',
        ) || File(
            '/system/bin/app_process',
        ).existsSync();

        final command = isTermux ?
            'termux-open' :
            'xdg-open';

        try {
            Process.runSync(command, [value]);
        } catch (_) {
            try {
                Process.runSync('xdg-open', [value]);
            } catch (err) {
                print("${R}[!] ${N}Failed to open system default browser/opener!");
                exit(1);
            }
        }
    }

    void _runCustomCommand(String template, String value) {
        final trimmedTemplate = template.trim();
        final dangerousCharacters = [
            ';', '&&',
            '||', '|', '`',
            '\$', '\n', '\r',
        ];

        for (var char in dangerousCharacters) {
            if (trimmedTemplate.contains(char)) {
                print("${R}[!] ${N}Security Alert!");
                print("${R}[!] ${N}Dangerous char: ${GG}${char} ${N}detected!");
                exit(1);
            }
        }

        final fullCmd = trimmedTemplate.replaceAll(
            '{}', value,
        );

        Process.runSync('bash', ['-c', fullCmd]);
    }
}

// Copyright (c) 2026 Zeronetsec