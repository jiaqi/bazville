# bazville

Bazville offers several Bazel build rules that Bazel doesn't provide natively.

- [Java web application](docs/webapp.md)
- [Run web application with Tomcat](docs/tomcat.md)
- [Download with wget](docs/wget.md)
- [Untar](docs/untar.md)

The latest version of bazville is `0.0.2`. Therefore to include bazville, add following to your
`WORKSPACE` file.

```
git_repository(
    name = "bazville",
    remote = "https://github.com/jiaqi/bazville.git",
    tag = "v_0_0_2",
)
```
