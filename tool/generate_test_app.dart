import 'package:process_run/shell_run.dart';
import 'dart:io';

var testAppDir = 'example/test_app';
var testAppShell = Shell(workingDirectory: testAppDir);
Future main() async {
  await Directory(testAppDir).create(recursive: true);
  await testAppShell.run('''
  dart create --template web . --force
  ''');
}
