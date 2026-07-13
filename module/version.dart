import 'dart:io';
import '../console/command_interface.dart';
import '../utils/color.dart';

class Version implements Command {
    static const String name = 'Oliner';
    static const String version = 'v0.1';
    static const String creator = 'Zeronetsec';
    static const String homepage = 'https://github.com/Zeronetsec/Oliner';

    @override void execute(List<String> args) {
        print("${N}Name: ${GG}${name}");
        print("${N}Version: ${GG}${version}${N}");
        print("${N}Creator: ${GG}${creator}${N}");
        print("${N}Homepage: ${GG}${homepage}${N}");
    }
}