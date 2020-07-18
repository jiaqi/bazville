# [bazville](../README.md) > Compare with rules_appengine

The official support of Java web application in Bazel is
[bazelbuild/rules_appengine](https://github.com/bazelbuild/rules_appengine).
This table below explains how bazville works differently from rules_appengine.

|   | rules_appengine | bazville |
| - | --------------- | -------- |
| Requires appengine.xml | Yes | No |
| Requires web.xml | No | No |
| Adds appengine jar libraries to webapp | Yes | No |
| Runs with | Google appengine | Tomcat |
| `//a/static:file.js` goes to | `<root>/file.js` | `<root>/a/static/file.js` |
| `@npm//:node_modules/a/file.js` goes to | `<root>/file.js` | `<root>/external/npm/node_modules/a/file.js` |

A key difference is that `bazville` preserves the file structure of sources in
a web application, while `rules_appengine` flattens out all the files, places
them to the root of the web application, and ignores their original file
structure. Files with the same name from multiple locations would collide with
`rules_appengine` and be handled correctly by `bazville`.