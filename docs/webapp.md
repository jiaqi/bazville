# Bazville > webapp

The `webapp` build rule create a file directory structure that reflects a
standard Java web application.

## Relative paths

In a directory that looks like below

```
$ tree java/com/my/webapp
java/com/my/webapp
├── BUILD
├── WEB-INF
│   ├── web.xml
│   └── jsp
│       └── index.jsp
└── favicon.png
```

the `BUILD` file defines the files to include in the web application,

```
load("@bazville//tools/java:webapp.bzl", "webapp")

webapp(
    name = "webapp",
    srcs = glob(["WEB-INF/**"]) + [
        ":favicon.png",
    ],
    deps = [":serverlib"],
)
```

Files in `WEB-INF` and `favicon.png` under the same source directory of the
`BUILD` file are copied into the root of the web application directory. With
it `bazel` build creates a web application file structure.

```
$ bazel build java/java/com/my/webapp:webapp
...
INFO: Found 1 target...
Target //java/java/com/my/webapp:webapp up-to-date:
  bazel-bin/java/java/com/my/webapp/webapp
INFO: Elapsed time: 0.422s, Critical Path: 0.02s
INFO: 0 processes.
INFO: Build completed successfully, 1 total action

$ tree bazel-bin/java/java/com/my/webapp/webapp
bazel-bin/java/java/com/my/webapp/webapp
├── WEB-INF
│   ├── web.xml -> ...
│   ├── jsp
│   │   └── index.jsp -> ...
```

## Absolute paths

The `webapp` rule can also include static resource specified with absolute
build targets. In such case files are added under web application root
according to their absoluate path.

```
webapp(
    name = "webapp",
    srcs = glob(["WEB-INF/**"]) + [
        "//some/absolute/path:the_file.txt",
    ],
    deps = [":serverlib"],
)
```

In this example `the_file.txt` is added to `<webapp root>/some/absolute/path`
directory.

```
$ tree bazel-bin/java/java/com/my/webapp/webapp
bazel-bin/java/java/com/my/webapp/webapp
├── some
│   └── absolute
│       └── path
│           └── the_file.txt -> ...
```

Since `srcs` can include any build targets, it can include both source files
and build targets such as nodejs web packs or any targets with output files.