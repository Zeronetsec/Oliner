// https://github.com/Zeronetsec/Oliner

import 'dart:io';
import 'color.dart';

void MissingArgument() {
    print("${R}[!] ${N}Missing argument!");
    print("${R}[!] ${N}Try: ${GG}oliner --help${N}");
    exit(1);
}

// Copyright (c) 2026 Zeronetsec