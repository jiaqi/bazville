# Bazville > webapp

The `webapp` build rule create a file directory structure that reflects a
standard Java web application.

## Relative paths

In the `BUILD` file below,

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
`BUILD` file are copied into the root of the web application directory. If your
web application requires a `web.xml` file, you would need to include it under
the `WEB-INF` folder.

## Absolute paths
