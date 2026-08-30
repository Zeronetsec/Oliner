// https://github.com/Zeronetsec/Oliner

import 'dart:io';
import '../console/command_interface.dart';
import '../utils/color.dart';
import '../utils/missing_argument.dart';
import '../utils/notraversal.dart';
import '../utils/root.dart';

class Mvkey implements Command {
    @override void execute(List<String> args) {
        if (args.length < 4) {
            MissingArgument();
        }

        var sourcePath = args[1].trim();
        final keyToMove = args[2].trim();

        var targetPath = args[3].trim();
        final newKey = args.length >= 5 ?
            args[4].trim() :
            null;

        NoTraversal(sourcePath);
        NoTraversal(targetPath);

        if (
            !sourcePath.endsWith('.txtx')
        ) sourcePath = "${sourcePath}.txtx";

        if (
            !targetPath.endsWith('.txtx')
        ) targetPath = "${targetPath}.txtx";

        final sourceFile = File(
            '${Root}/data/user_data/${sourcePath}',
        );

        final targetFile = File(
            '${Root}/data/user_data/${targetPath}',
        );

        if (!sourceFile.existsSync()) {
            print("${color_R}[!] ${color_N}Source file: ${color_GG}data/user_data/${sourcePath} ${color_N}not found!");
            exit(1);
        }

        try {
            final sourceLines = sourceFile.readAsLinesSync();
            final List<String> updatedSourceLines = [];
            String? extractedLine;

            final keyRegex = RegExp(
                '^' + RegExp.escape(keyToMove) + r'\s*:',
            );

            for (var line in sourceLines) {
                var trimmed = line.trim();
                if (
                    trimmed.contains('#') &&
                    !trimmed.startsWith('#')
                ) {
                    trimmed = trimmed.substring(
                        0, trimmed.indexOf('#'),
                    ).trim();
                }

                if (keyRegex.hasMatch(trimmed)) {
                    extractedLine = line;
                    continue;
                }
                updatedSourceLines.add(line);
            }

            if (extractedLine == null) {
                print("${color_R}[!] ${color_N}Key: ${color_GG}${keyToMove} ${color_N}not found in ${color_GG}${sourcePath}${color_N}");
                exit(1);
            }

            String lineToInsert = extractedLine;
            if (newKey != null) {
                lineToInsert = extractedLine.replaceFirst(
                    RegExp(
                        '^' + RegExp.escape(
                            keyToMove,
                        ),
                    ), newKey,
                );
            }

            final targetParent = targetFile.parent;
            if (!targetParent.existsSync()) {
                targetParent.createSync(recursive: true);
            }

            if (updatedSourceLines.isEmpty) {
                sourceFile.writeAsStringSync("");
            } else {
                sourceFile.writeAsStringSync(
                    updatedSourceLines.join('\n') + '\n',
                );
            }

            String targetContent = "";
            if (targetFile.existsSync()) {
                targetContent = targetFile.readAsStringSync();
            }

            if (
                targetContent.isNotEmpty &&
                !targetContent.endsWith('\n')
            ) {
                targetContent += '\n';
            }

            targetContent += lineToInsert.trim() + '\n';
            targetFile.writeAsStringSync(targetContent);

            final finalKeyName = newKey ?? keyToMove;
            print("${color_GG}[+] ${color_N}Successfully moved key: ${color_GG}${keyToMove} ${color_N}from ${color_GG}${sourcePath} ${color_N}to ${color_GG}${targetPath} ${color_N} as ${color_GG}${finalKeyName}${color_N}");
            return;
        } catch (e) {
            print("${color_R}[!] ${color_N}Error moving key data: ${color_GG}${e}${color_N}");
            exit(1);
        }
    }
}

// Copyright (c) 2026 Zeronetsec