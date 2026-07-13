// https://github.com/Zeronetsec/Oliner

import 'dart:io';
import '../console/command_interface.dart';
import '../utils/color.dart';
import '../utils/missing_argument.dart';
import '../utils/notraversal.dart';
import '../utils/root.dart';

class Show implements Command {
    @override void execute(List<String> args) {
        if (args.length < 2) {
            MissingArgument();
        }

        final targetPath = args[1];
        NoTraversal(targetPath);

        final file = File(
            '${Root}/data/user_data/${targetPath}.txtx',
        );

        if (!file.existsSync()) {
            print("${R}[!] ${N}File: ${GG}data/user_data/${targetPath} ${N}not found!");
            exit(1);
        }

        try {
            final lines = file.readAsLinesSync();
            String? globalMessage;
            final globalRegex = RegExp(r'<(.*)>');

            for (var line in lines) {
                final trimmed = line.trim();
                final match = globalRegex.firstMatch(trimmed);
                if (match != null) {
                    globalMessage = match.group(1);
                    break;
                }
            }

            if (
                globalMessage != null &&
                globalMessage.isNotEmpty
            ) {
                print("${DG}[${YY}${globalMessage}${DG}]${N}");
                print("");
            }

            final parserRegex = RegExp(
                r'^([^:]+):\s*(link|code)\(([^)]+)\)(?:\.msg\(([^)]+)\))?',
            );

            for (var line in lines) {
                var trimmed = line.trim();
                if (
                    trimmed.startsWith('#') ||
                    trimmed.isEmpty ||
                    trimmed.startsWith('<')
                ) {
                    continue;
                }

                if (trimmed.contains('#')) {
                    final hashIndex = trimmed.indexOf('#');
                    trimmed = trimmed.substring(
                        0, hashIndex,
                    ).trim();
                }

                final match = parserRegex.firstMatch(
                    trimmed,
                );

                if (match != null) {
                    final key = match.group(1)?.trim() ?? '';
                    final type = match.group(2) ?? '';
                    final value = match.group(3) ?? '';
                    final msg = match.group(4) ?? '';

                    final msgPart = msg.isNotEmpty ?
                        " ${DG}(${CC}${msg}${DG})" :
                        "";

                    if (type == 'link') {
                        print("${N}${key}: ${GG}${value}${msgPart}${N}");
                    } else if (type == 'code') {
                        print("${N}${key}: ${B}${value}${msgPart}${N}");
                    }
                }
            }
        } catch (e) {
            print("${R}[!] ${N}Error parsing file: ${GG}${e}${N}");
            exit(1);
        }
    }
}

// Copyright (c) 2026 Zeronetsec