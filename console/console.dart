import 'dart:io';
import 'command_interface.dart';
import '../module/exportmod.dart';
import '../utils/missing_argument.dart';
import '../utils/invalid_option.dart';

void Console(List<String> args) {
    if (args.isEmpty) {
        MissingArgument();
    }

    final commands = <String, Command>{
        '--version': Version(),
        '--help': Help(),
        '--uwu': Uwu(),
        '--list': ModList(),
        '--show': Show(),
        '--add': Add(),
        '--mkdir': Mkdir(),
        '--remove': Remove(),
        '--rmkey': Rmkey(),
        '--search': Search(),
        '--duplicate': Duplicate(),
        '--export': Export(),
        '--import': Import(),
        '--rename': Rename(),
        '--move': Move(),
        '--open': Open(),
        '--copy': Copy(),
        '--mvkey': Mvkey(),
        '--cpkey': Cpkey(),
    };

    final fargs = args[0];
    final cmd = commands[fargs];

    if (cmd != null) {
        cmd.execute(args);
    } else {
        InvalidOption(fargs);
    }
}