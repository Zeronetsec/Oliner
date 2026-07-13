import 'dart:io';

class Path {
    static String getAbsolutePath(String path) {
        if (path.startsWith('/')) return path;
        return Directory.current.path + '/' + path;
    }
}