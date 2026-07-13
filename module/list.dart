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
            print("${R}[!] ${N}Folder: ${GG}data/user_data ${N}not found!");
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

                    print("${N}${indent}${R}- ${B}${folderName} ${DG}(${CC}${stats['folders']} folder${DG}, ${CC}${stats['files']} file${DG})${N}");
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

                    String infoText = "${YY}empty${N}";
                    if (
                        contentStats['links']! > 0 &&
                        contentStats['codes']! > 0
                    ) {
                        infoText = "${CC}${contentStats['links']} link${DG}, ${CC}${contentStats['codes']} code${N}";
                    } else if (contentStats['links']! > 0) {
                        infoText = "${CC}${contentStats['links']} link${N}";
                    } else if (contentStats['codes']! > 0) {
                        infoText = "${CC}${contentStats['codes']} code${N}";
                    }
                    print("${indent}${R}› ${GG}${fileName} ${DG}(${infoText}${DG})${N}");
                }
            }
        } catch (e) {
            print("${R}[!] ${N}Failed reading folder: ${GG}${dir.path}${N}");
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