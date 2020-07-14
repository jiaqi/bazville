# [bazville](../README.md) > jar

## API

```
load("@bazville//tools/java:jar.bzl", "jar")
jar(name, visibility, src, file_name)
```

The `jar` build rule wraps a given directory into a single jar file. With
`file_name` attribute specified, this build rule can be used to create war file
, ear file or any file in the same format of jar file.

## Argument

| Name | Required? | type | Default value | Example |
| ---- | --------- | ---- | ------------- | -------- |
| `name` | Yes | String | | `appbundle` |
| `visibility` | No | Label array | `[]` | `[ "//visibility:public" ]` |
| `src` | Yes | Label | | `:mywebapp` | 
| `file_name` | No | String | `<target name>.jar` | `appbundle.war` | 

### src

The `jar` build rule takes one input build target with a single output
directory. The jar file is created from the root directory of the this build
target.

### file_name

By default the output file name is `<target name>.jar` but users can override
the output name by setting `file_name` attribute.
