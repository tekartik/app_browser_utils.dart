library test_menu;

import 'package:tekartik_test_menu_browser/test_menu_mdl_browser.dart';

import 'file_drop_zone.dart';
//import '

Future main() async {
  await initTestMenuBrowser();
menu('drop_zone', () {
  var dropZone = FileDropZoneWidget();
  item('init', () {
    dropZone.init();
  });
  item('dispose', () {
    dropZone.dispose();
  });
});
  item('write hola', () async {
    write('Hola');
    //write('RESULT prompt: ${await prompt()}');
  });
  item('prompt', () async {
    write('RESULT prompt: ${await prompt('Some text please then [ENTER]')}');
  });
  item('js console.log', () {
    jsTest('testConsoleLog');
  });
  item('crash', () {
    throw 'Hi';
  });
  menu('sub', () {
    item('write hi', () => write('hi'));
  });
}
