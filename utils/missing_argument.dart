import 'dart:io';
import 'color.dart';

void MissingArgument() {
    print("${R}[!] ${N}Missing argument!");
    print("${R}[!] ${N}Try: ${GG}oliner --help${N}");
    exit(1);
}