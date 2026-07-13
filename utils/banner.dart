// https://github.com/Zeronetsec/Oliner

import 'dart:io';
import 'color.dart';
import 'root.dart';

void Banner() {
    try {
        final file = File('${Root}/data/banner.txt');
        if (!file.existsSync()) {
            print("${R}[!] ${N}Error loading banner!");
            exit(1);
        }

        final data = file.readAsStringSync();
        print("${B}${data}${N}");
    } catch (_) {
        print("${R}[!] ${N}Error loading banner!");
        exit(1);
    }
}

// Copyright (c) 2026 Zeronetsec