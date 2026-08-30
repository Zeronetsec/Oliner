// https://github.com/Zeronetsec/Oliner

import 'dart:io';
import '../console/command_interface.dart';
import '../utils/color.dart';
import '../utils/root.dart';

class ModList implements Command {
    @override void execute(List<String> args) {
        final baseDir = Directory(
            '${Root}/data/user_data',
        );

        if (!baseDir.existsSync()) {
            print("${color_R}[!] ${color_N}Folder: ${color_GG}data/user_data ${color_N}not found!");
            exit(1);
        }
        _renderDirectory(baseDir, 0);
    }

    void _renderDirectory(Directory dir, int depth) {
        final indent = '  ' * depth;
        try {
            final entities = dir.listSync();
            for (var entity in entities) {
                if (entity is Directory) {
                    final stats = _getFolderStats(entity);
                    final folderName = entity.uri.pathSegments[
                        entity.uri.pathSegments.length - 2
                    ];

                    print("${color_N}${indent}${color_R}- ${color_B}${folderName} ${color_DG}(${color_CC}${stats['folders']} folder${color_DG}, ${color_CC}${stats['files']} file${color_DG})${color_N}");
                    _renderDirectory(entity, depth + 1);
                }
                else if (
                    entity is File &&
                    entity.path.endsWith('.txtx')
                ) {
                    final fileName = entity.uri.pathSegments.last.replaceAll(
                        '.txtx', '',
                    );

                    final contentStats = _parseTxtxContent(entity);

                    String infoText = "${color_YY}empty${color_N}";
                    if (
                        contentStats['links']! > 0 &&
                        contentStats['codes']! > 0
                    ) {
                        infoText = "${color_CC}${contentStats['links']} link${color_DG}, ${color_CC}${contentStats['codes']} code${color_N}";
                    } else if (contentStats['links']! > 0) {
                        infoText = "${color_CC}${contentStats['links']} link${color_N}";
                    } else if (contentStats['codes']! > 0) {
                        infoText = "${color_CC}${contentStats['codes']} code${color_N}";
                    }
                    print("${color_N}${indent}${color_R}› ${color_GG}${fileName} ${color_DG}(${infoText}${color_DG})${color_N}");
                }
            }
        } catch (e) {
            print("${color_R}[!] ${color_N}Failed reading folder: ${color_GG}${dir.path}${color_N}");
            exit(1);
        }
    }

    Map<String, int> _getFolderStats(Directory dir) {
        int folders = 0;
        int files = 0;

        try {
            final allEntities = dir.listSync(
                recursive: true,
            );

            for (var entity in allEntities) {
                if (entity is Directory) {
                    folders++;
                } else if (
                    entity is File &&
                    entity.path.endsWith('.txtx')
                ) {
                    files++;
                }
            }
        } catch (_) {}
        return {'folders': folders, 'files': files};
    }

    Map<String, int> _parseTxtxContent(File file) {
        int links = 0;
        int codes = 0;

        final linkRegex = RegExp(r'.*:\s*link\(.*\)$');
        final codeRegex = RegExp(r'.*:\s*code\(.*\)$');

        try {
            final lines = file.readAsLinesSync();
            for (var line in lines) {
                final trimmed = line.trim();

                if (linkRegex.hasMatch(trimmed)) {
                    links++;
                }
                else if (codeRegex.hasMatch(trimmed)) {
                    codes++;
                }
            }
        } catch (_) {}
        return {'links': links, 'codes': codes};
    }
}

// Copyright (c) 2026 Zeronetsec