# app_browser_utils

Placeholder for browser (`package:web`) app utilities. It has no library
yet: nothing to depend on. Browser helpers live in
[browser_utils.dart](https://github.com/tekartik/browser_utils.dart)
(`tekartik_browser_utils`).

## Content

- `example/test_app`: a bare web app (`dart create --template web`) used to
  try things in a browser, with an unused file drop zone experiment
  (`web/file_drop_zone.dart`, `dart:html`, not imported by `main.dart`).
- `tool/generate_test_app.dart`: re-creates `example/test_app` from the
  template.
- `tool/run_ci.dart`: the CI checks (`packageRunCi` of `dev_build`).
