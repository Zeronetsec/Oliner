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
            print("${color_R}[!] ${color_N}File: ${color_GG}data/user_data/${targetPath} ${color_N}not found!");
            exit(1);
        }

        try {
            final lines = file.readAsLinesSync();
            List<String> globalMessages = [];
            final globalRegex = RegExp(r'<(.*)>');
            for (var line in lines) {
                final trimmed = line.trim();
                final match = globalRegex.firstMatch(trimmed);
                if (match != null) {
                    final msg = match.group(1);
                    if (msg != null && msg.isNotEmpty) {
                        globalMessages.add(msg);
                    }
                }
            }

            if (globalMessages.isNotEmpty) {
                for (var message in globalMessages) {
                    print("${color_DG}[${color_YY}${message}${color_DG}]${color_N}");
                }
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
                        " ${color_DG}(${color_CC}${msg}${color_DG})" :
                        "";

                    if (type == 'link') {
                        print("${color_N}${key}: ${color_GG}${value}${msgPart}${color_N}");
                    } else if (type == 'code') {
                        print("${color_N}${key}: ${color_B}${value}${msgPart}${color_N}");
                    }
                }
            }
        } catch (e) {
            print("${color_R}[!] ${color_N}Error parsing file: ${color_GG}${e}${color_N}");
            exit(1);
        }
    }
}

// Copyright (c) 2026 Zeronetsec