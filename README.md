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
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
http_archive(
    name = "bazville",
    sha256 = "902e1fee3d2cf2b1df479b486545c859d9ad3edecc0895559ca49bc58b10c9ad",
    strip_prefix = "bazville-v_0_0_2",
    urls = ["https://github.com/jiaqi/bazville/archive/v_0_0_2.zip"],
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

Now you can run the web application with tomcat in bazel.

```
bazel run myapp:tomcat_server
```

For more details, checkout [Java web application](docs/webapp.md) and
[Tomcat](docs/tomcat.md) pages.

Refer to [angular-on-java](https://github.com/jiaqi/angular-on-java) project
for
[a full example](https://github.com/jiaqi/angular-on-java/blob/master/java/org/cyclopsgroup/aoj/server/BUILD).

## Context

The official support of Java web application in Bazel is
[bazelbuild/rules_appengine](https://github.com/bazelbuild/rules_appengine),
which comes with a number of problems as discussed in
[a blog post](https://blog.cyclopsgroup.org/2020/03/spring-angular-and-other-reasons-i-like.html).
After some wrestling I realized I can not manage to have appengine rule
accurately serve my needs. Since there doesn't seem to be another option, I
decided to go ahead and create one.

With bazville I was able to change the demo project
[jiaqi/angular-on-java](https://github.com/jiaqi/angular-on-java) to build web
application correctly without assuming it runs in appengine, and run it with
Tomcat in bazel. [This page](docs/vs_appengine.md) compares bazville with
rules_appengine.
