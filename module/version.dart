// https://github.com/Zeronetsec/Oliner

import 'dart:io';
import '../console/command_interface.dart';
import '../utils/color.dart';

class Version implements Command {
    static const String name = 'Oliner';
    static const String version = 'v0.1';
    static const String creator = 'Zeronetsec';
    static const String homepage = 'https://github.com/Zeronetsec/Oliner';

    @override void execute(List<String> args) {
        print("${color_N}Name: ${color_GG}${name}${color_N}");
        print("${color_N}Version: ${color_GG}${version}${color_N}");
        print("${color_N}Creator: ${color_GG}${creator}${color_N}");
        print("${color_N}Homepage: ${color_GG}${homepage}${color_N}");
    }
}

// Copyright (c) 2026 Zeronetsec