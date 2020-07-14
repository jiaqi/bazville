# [bazville](../README.md) > tomcat_binary

## API

```
load("@bazville//tools/tomcat:tomcat.bzl", "tomcat_binary")
tomcat_binary(
    name,
    visibility,
    app_dir,
    app_name,
    version,
    tomcat_bundle,
    jvm_opts
)
```

The build rule `tomcat_binary` runs a given `webapp` build target, or any build
target that produces a valid web application directory, with tomcat. It does so
by creating a valid `catalina base` file structure and running a Java process
with JVM options that point to it.

The build rule requires symlink so this following line needs to be added to the
`.bazelrc` file under workspace root.

```
build --experimental_allow_unresolved_symlinks
```

## Arguemnts

| Name | Required? | type | Default value | Example |
| ---- | --------- | ---- | ------------- | -------- |
| `name` | Yes | String | | `mytomcatserver` |
| `visibility` | No | Label array | `[]` | `[ "//visibility:public" ]` |
| `app_dir` | Yes | Label | | `:mywebapp` |
| `app_name` | No | string | `ROOT` | `myapp` |
| `version` | No | number | 9 | `8` |
| `tomcat_bundle` | Yes | Label | | `@bazville//tools/tomcat:tomcat_8` |
| `jvm_opts` | No | String array | `[]` | `["-Dval=value", "-ea"]` |

### app_dir

When a web application build target is defined with [`webapp`](./webapp.md),
we can set `app_dir` to point to the build target of the web application.
For example:

```
webapp(
    name = "webapp",
    srcs = glob(["WEB-INF/**"]) + [ ":favicon.png" ],
    deps = [":serverlib"],
)

tomcat_binary(
    name = "tomcat",
    app_dir = ":webapp",
    tomcat_bundle = "@bazville//tools/tomcat:tomcat_9",
)
```

However `app_dir` does not always have to be a `webapp` target. Any target
that produces a single output directory with a standard Java web application
structure works here.

### app_name

The name of the directory placed under `<catalina base>/webapps/`. The default
value `ROOT` makes the application root application.

### version

The version of tomcat to run the application with. The value must be `7`, `8`,
`9` or `10` with default value `9`.

### tomcat_bundle

Due to the limitation of the implementation, `tomcat_binary` build rule
requires user to specify the location of the installtion target for now.
The value must be `@bazville//tools/tomcat:tomcat_9` when `version` is not
specified. When version is specified, the value must change accordingly.

The prefix `@bazville` comes from the `bazville` repository definition in the
`WORKPLACE` file.

```
git_repository(
    name = "bazville",
    remote = "https://github.com/jiaqi/bazville.git",
    tag = "v_0_0_2",
)
```

If the repository name is not `bazville`, the target prefix should change
accordingly.

### jvm_opts

Users can specify additional JVM flags with attribute `jvm_opts`. This is
useful when you want the local version to run with local specific features.