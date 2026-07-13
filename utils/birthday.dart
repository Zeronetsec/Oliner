// https://github.com/Zeronetsec/Oliner

import 'color.dart';

void Birthday() {
    final birthDate = "07-13";

    final nowTime = DateTime.now();
    final month = nowTime.month.toString().padLeft(2, '0');
    final day = nowTime.day.toString().padLeft(2, '0');
    final now = "${month}-${day}";

    if (now == birthDate) {
        print("${R}› ${N}Happy birthday for ${GG}oliner ${N}🎉");
        print("");
    }
}

// Copyright (c) 2026 Zeronetsec