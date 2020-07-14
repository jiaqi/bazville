# bazville

## Overview

Bazville offers several [Bazel](https://bazel.build) build rules that Bazel doesn't provide natively.

- [Java web application](docs/webapp.md)
- [Run web application with Tomcat](docs/tomcat.md)
- [Jar and war](docs/jar.md)

## Installation

The latest version of bazville is `0.0.2`. Therefore to include bazville, add
following to your `WORKSPACE` file.

```
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

git_repository(
    name = "bazville",
    remote = "https://github.com/jiaqi/bazville.git",
    tag = "v_0_0_2",
)
```

## Web application and Tomcat

The primary reason of Bazville is to build Java web application with static
content from other build rules, and run it with Bazel. For example in the
`BUILD` file,

```
load("@bazville//tools/java:webapp.bzl", "webapp")

webapp(
    name = "webapp",
    srcs = glob(["WEB-INF/**"]) + [
        ":favicon.png",
        "//other/static:file",
        "//some/npm:packages",
    ],
    deps = [":serverlib"],
)
```

The build target above creates a web application directory that can run with
the following tomcat build target.

```
load("@bazville//tools/tomcat:tomcat.bzl", "tomcat_binary")
tomcat_binary(
    name = "tomcat_server",
    app_dir = ":webapp",
    tomcat_bundle = "@bazville//tools/tomcat:tomcat_9",
)
```

For more details, checkout [Java web application](docs/webapp.md) and
[Tomcat](docs/tomcat.md) pages.

Refer to [angular-on-java](https://github.com/jiaqi/angular-on-java) project
for
[a full example](https://github.com/jiaqi/angular-on-java/blob/master/java/org/cyclopsgroup/aoj/server/BUILD).
