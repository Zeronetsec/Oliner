// https://github.com/Zeronetsec/Oliner

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
            print("${color_R}[!] ${color_N}Error reading config!");
            print("${color_R}[!] ${color_N}Directory: ${color_GG}metadata ${color_N}not found!");
            exit(1);
        }

        print("${color_N}Usage: ${color_GG}oliner ${color_CC}<option> [<args>]${color_N}");
        print("");
        print("${color_N}Available options:");

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
                        final formattedArgs = hp.args.isNotEmpty ?
                            " ${hp.args}" :
                            "";

                        print("    ${color_DG}* ${color_GG}${hp.command}${color_CC}${formattedArgs}${color_N}");
                        print("    ${color_DG}└── ${color_WW}${hp.description}${color_N}");
                    } catch (_) {
                        continue;
                    }
                }
            }
        } catch (err) {
            print("${color_R}[!] ${color_N}Error reading config: ${color_GG}${err}${color_N}");
            exit(1);
        }
    }
}

// Copyright (c) 2026 Zeronetsec