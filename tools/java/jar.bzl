"""
Rule to create a jar or war file with jar command.
"""

def _jar_impl(ctx):
    jar_name = ctx.attr.file_name
    if jar_name == "":
        jar_name = "%s.jar" % ctx.label.name
    jar = ctx.actions.declare_file(jar_name)

    script = ctx.actions.declare_file("%s_jar.sh" % ctx.label.name)
    ctx.actions.expand_template(
        template = ctx.file._jar_cmd_template,
        output = script,
        substitutions = {
            "%{output_file}": jar.path,
            "%{root_dir}": ctx.file.src.path,
        },
        is_executable = True,
    )
    ctx.actions.run_shell(
        inputs = [script, ctx.file.src],
        outputs = [jar],
        command = script.path,
    )
    return [DefaultInfo(files = depset([jar]))]

jar = rule(
    implementation = _jar_impl,
    doc = "Create a jar or war archive.",
    attrs = {
        "src": attr.label(
            mandatory = True,
            allow_single_file = True,
        ),
        "file_name": attr.string(default = ""),
        "_jar_cmd_template": attr.label(
            default = Label("//tools/java:jar_cmd.template"),
            allow_single_file = True,
        ),
    },
)
