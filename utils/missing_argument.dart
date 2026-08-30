// https://github.com/Zeronetsec/Oliner

import 'dart:io';
import 'color.dart';

void MissingArgument() {
    print("${color_R}[!] ${color_N}Missing argument!");
    print("${color_R}[!] ${color_N}Try: ${color_GG}oliner --help${color_N}");
    exit(1);
}

// Copyright (c) 2026 Zeronetsec