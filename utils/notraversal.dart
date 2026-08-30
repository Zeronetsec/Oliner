// https://github.com/Zeronetsec/Oliner

import 'dart:io';
import 'color.dart';

void NoTraversal(String inputPath) {
    final trimmed = inputPath.trim();
    if (trimmed.contains('..')) {
        print("${color_R}[!] ${color_N}Blocked: ${color_GG}${inputPath}${color_N}");
        print("${color_R}[!] ${color_N}Security Alert: ${color_GG}path traversal attempt detected!${color_N}");
        exit(1);
    }
}

// Copyright (c) 2026 Zeronetsec