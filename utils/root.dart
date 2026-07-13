import 'dart:io';

String get Root => File(
    Platform.resolvedExecutable,
).parent.path;