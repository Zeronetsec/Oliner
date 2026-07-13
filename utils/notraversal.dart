// https://github.com/Zeronetsec/Oliner

import 'dart:io';
import 'color.dart';

void NoTraversal(String inputPath) {
    final trimmed = inputPath.trim();
    if (trimmed.contains('..') || trimmed.startsWith('/')) {
        print("${R}[!] ${N}Blocked: ${GG}${inputPath}${N}");
        print("${R}[!] ${N}Security Alert: ${GG}path traversal attempt detected!${N}");
        exit(1);
    }
}

// Copyright (c) 2026 Zeronetsec