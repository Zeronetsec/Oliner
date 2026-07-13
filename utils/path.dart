// https://github.com/Zeronetsec/Oliner

import 'dart:io';

class Path {
    static String getAbsolutePath(String path) {
        if (path.startsWith('/')) return path;
        return Directory.current.path + '/' + path;
    }
}

// Copyright (c) 2026 Zeronetsec