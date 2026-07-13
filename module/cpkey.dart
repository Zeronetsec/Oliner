import 'dart:io';
import '../console/command_interface.dart';
import '../utils/color.dart';
import '../utils/missing_argument.dart';
import '../utils/notraversal.dart';
import '../utils/root.dart';

class Cpkey implements Command {
    @override void execute(List<String> args) {
        if (args.length < 4) {
            MissingArgument();
        }

        var sourcePath = args[1].trim();
        final keyToCopy = args[2].trim();

        var targetPath = args[3].trim();
        final newKey = args.length >= 5 ? args[4].trim() : null;

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
            print("${R}[!] ${N}Source file: ${GG}data/user_data/${sourcePath} ${N}not found!");
            exit(1);
        }

        try {
            final sourceLines = sourceFile.readAsLinesSync();
            String? extractedLine;

            final keyRegex = RegExp(
                '^' + RegExp.escape(keyToCopy) + r'\s*:',
            );

            for (var line in sourceLines) {
                var trimmed = line.trim();
                if (
                    trimmed.contains('#') &&
                    !trimmed.startsWith('#')
                ) {
                    trimmed = trimmed.substring(
                        0, trimmed.indexOf('#')
                    ).trim();
                }

                if (keyRegex.hasMatch(trimmed)) {
                    extractedLine = line;
                    break;
                }
            }

            if (extractedLine == null) {
                print("${R}[!] ${N}Key: ${GG}${keyToCopy} ${N}not found in ${GG}${sourcePath}${N}!");
                exit(1);
            }

            String lineToInsert = extractedLine;
            if (newKey != null) {
                lineToInsert = extractedLine.replaceFirst(
                    RegExp(
                        '^' + RegExp.escape(keyToCopy),
                    ), newKey,
                );
            }

            final targetParent = targetFile.parent;
            if (!targetParent.existsSync()) {
                targetParent.createSync(recursive: true);
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

            final finalKeyName = newKey ?? keyToCopy;
            print("${GG}[+] ${N}Successfully copied key: ${GG}${keyToCopy} ${N}from ${GG}${sourcePath} ${N}to ${GG}${targetPath} ${N}as ${GG}${finalKeyName}${N}");
            return;
        } catch (e) {
            print("${R}[!] ${N}Error copying key data: ${GG}${e}${N}");
            exit(1);
        }
    }
}