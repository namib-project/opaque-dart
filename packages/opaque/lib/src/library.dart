import 'dart:ffi';
import 'dart:io';

import 'ffi/opaque_ffi.dart';

const _opaqueLinuxFileName = "libopaque.so";
const _opaqueWindowsFileName = "libopaque.dll";
const _opaqueMacosFileName = "libopaque.dylib";

const _sodiumLinuxFileName = "libsodium.so";
const _sodiumWindowsFileName = "libsodium.dll";
const _sodiumMacosFileName = "libsodium.dylib";

const _linuxExtension = ".so";
const _windowsExtension = ".dll";
const _macosExtension = ".dylib";

/// This [Exception] is thrown if there is an error loading
/// the shared libopaque library.
///
/// Using an [Exception] instead of an [Error] allows users
/// to provide a fallback or throw their own [Exception]s
/// if libopaque should not be available.
abstract class LoadException implements Exception {
  /// The original [Error] that caused this [Exception].
  final Error? originalError;

  final String libraryName;

  /// Constructor.
  LoadException(this.libraryName, [this.originalError]);

  @override
  String toString() => "could not find a shared $libraryName library.\n$originalError";
}

// TODO: Documentation
class OpaqueLoadException extends LoadException {
  OpaqueLoadException([Error? originalError])
      : super("libopaque", originalError);

  @override
  String toString() => "OpaqueLoadException: ${super.toString()}";
}

class SodiumLoadException extends LoadException {
  SodiumLoadException([Error? originalError])
      : super("libsodium", originalError);

  @override
  String toString() => "SodiumLoadException: ${super.toString()}";
}

/// Checks if a file exists under one of the given [paths] and tries to load it
/// as a [DynamicLibrary].
///
/// If no file can be found under one of the [paths], `null` is returned.
DynamicLibrary? _findLibraryOnFileSystem(List<String> paths) {
  for (final path in paths) {
    final fileExists = File(path).existsSync();
    if (fileExists) {
      return DynamicLibrary.open(path);
    }
  }

  return null;
}

/// Checks first if a library exists under one of the given file [paths], before
/// trying to use the [defaultFileName] for the current platform.
///
/// The [defaultFileName] will be the one used in Flutter apps in most cases.
DynamicLibrary _findLibrary(List<String> paths, String defaultFileName) {
  final library = _findLibraryOnFileSystem(paths);
  
  return library ?? DynamicLibrary.open(defaultFileName);
}

DynamicLibrary loadOpaque() {
  return _loadLibrary("libopaque");
}

DynamicLibrary loadSodium() {
  return _loadLibrary("libsodium");
}

DynamicLibrary _loadLibrary(String filename) {
  try {
    if (Platform.isAndroid) {
      filename += _linuxExtension;
      return DynamicLibrary.open(filename);
    } else if (Platform.isLinux) {
      filename += _linuxExtension;
      final paths = [
        "./$filename",
        "/usr/lib/$filename",
        "/usr/lib/x86_64-linux-gnu/$filename"
      ];
      return _findLibrary(paths, filename);
    } else if (Platform.isWindows) {
      filename += _windowsExtension;
      return DynamicLibrary.open(filename);
    } else if (Platform.isMacOS) {
      filename += _macosExtension;
      return _findLibrary(["./$filename"], filename);
    } else if (Platform.isIOS) {
      return DynamicLibrary.executable();
    }
    
    throw UnsupportedError(
          "Platform ${Platform.operatingSystem} is not supported by opaque-dart.");
  }
  // ignore: avoid_catching_errors
  on ArgumentError catch (error) {
    // We catch the error here contrary to the recommended behavior in order to
    // allow library users to offer OPAQUE functionality in their own libraries
    // with the possibility that no libopaque is available on the given platform.
    throw OpaqueLoadException(error);
  }
}
