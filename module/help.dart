import 'dart:convert';
import 'dart:io';
import '../console/command_interface.dart';
import '../utils/color.dart';
import '../utils/banner.dart';
import '../utils/birthday.dart';
import '../utils/root.dart';

class Helper {
    final String command;
    final String description;
    final String args;

    Helper({
        required this.command,
        required this.description,
        required this.args,
    });

    factory Helper.fromJson(Map<String, dynamic> json) {
        return Helper(
            command: json['Command'] ??
            json['command'] ??
            '',
            description: json['Description'] ??
            json['description'] ??
            '',
            args: json['Args'] ??
            json['args'] ??
            '',
        );
    }
}

class Help implements Command {
    @override void execute(List<String> args) {
        Banner();
        Birthday();

        final metadataDir = Directory('${Root}/metadata');
        if (!metadataDir.existsSync()) {
            print("${R}[!] ${N}Error reading config!");
            print("${R}[!] ${N}Directory: ${GG}metadata ${N}not found!");
            exit(1);
        }

        print("${N}Usage: ${GG}oliner ${CC}<option> [<args>]${N}");
        print("");
        print("${N}Available options:");

        try {
            final files = metadataDir
                .listSync()
                .where(
                    (file) => file.path.endsWith(
                        '.json',
                    ),
                )
                .toList();

            for (var fileEntity in files) {
                if (fileEntity is File) {
                    try {
                        final content = fileEntity.readAsStringSync();
                        final Map<String, dynamic> jsonData = jsonDecode(content);
                        final hp = Helper.fromJson(jsonData);
                        final formattedArgs = hp.args.isNotEmpty ? " ${hp.args}" : "";

                        print("    ${DG}* ${GG}${hp.command}${CC}${formattedArgs}${N}");
                        print("    ${DG}└── ${WW}${hp.description}${N}");
                    } catch (_) {
                        continue;
                    }
                }
            }
        } catch (err) {
            print("${R}[!] ${N}Error reading config: ${GG}${err}${N}");
            exit(1);
        }
    }
}