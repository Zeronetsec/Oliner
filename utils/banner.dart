// https://github.com/Zeronetsec/Oliner

import 'dart:io';
import 'color.dart';
import 'root.dart';

void Banner() {
    try {
        final file = File('${Root}/data/banner.txt');
        if (!file.existsSync()) {
            print("${color_R}[!] ${color_N}Error loading banner!");
            exit(1);
        }

        final data = file.readAsStringSync();
        print("${color_B}${data}${color_N}");
    } catch (_) {
        print("${color_R}[!] ${color_N}Error loading banner!");
        exit(1);
    }
}

// Copyright (c) 2026 Zeronetsec