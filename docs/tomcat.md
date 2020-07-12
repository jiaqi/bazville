# [bazville](../README.md) > tomcat

## API

```
load("@bazville//tools/tomcat:tomcat.bzl", "tomcat_binary")
tomcat_binary(name, visibility, app_dir, app_name, version, tomcat_bundle, jvm_opts)
```

The build rule `tomcat_binary` runs a given `webapp` build target, or any build
target that produces a valid web application directory, with tomcat.

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
