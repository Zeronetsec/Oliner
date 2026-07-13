// https://github.com/Zeronetsec/Oliner

import 'dart:io';
import 'color.dart';

void InvalidOption(String input) {
    print("${R}[!] ${N}Invalid option: ${GG}${input}${N}");
    print("${R}[!] ${N}Try: ${GG}oliner --help${N}");
    exit(1);
}

// Copyright (c) 2026 Zeronetsec