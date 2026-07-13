// https://github.com/Zeronetsec/Oliner

import 'dart:io';
import '../console/command_interface.dart';

class Uwu implements Command {
    @override void execute(List<String> args) {
        final faces = [
            "(｡◕‿◕｡)",
            "(≧◡≦)",
            "ʕ•ᴥ•ʔ",
            "(・ω・)",
            "(๑˃ᴗ˂)ﻭ",
            "(ง'̀-'́)ง",
            "(=^･ω･^=)",
        ];

        const double delayInSeconds = 0.2;
        const int durationInSeconds = 5;

        final int delayMs = (delayInSeconds * 1000).toInt();
        final stopwatch = Stopwatch()..start();

        stdout.write("\x1b[?25l");
        while (
            stopwatch.elapsed.inSeconds < durationInSeconds
        ) {
            for (var face in faces) {
                if (
                    stopwatch.elapsed.inSeconds >= durationInSeconds
                ) {
                    break;
                }
                stdout.write("\r${face}\x1b[K");
                sleep(Duration(milliseconds: delayMs));
            }
        }

        stopwatch.stop();
        stdout.write("\x1b[?25h");
        print("");
    }
}

// Copyright (c) 2026 Zeronetsec