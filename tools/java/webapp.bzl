"""
Rule to create a webapp directory.
"""

def _expend_transitive_deps(deps):
    transitive_runtime_deps = []
    for dep in deps:
        if JavaInfo in dep:
            transitive_runtime_deps.append(dep[JavaInfo].transitive_runtime_deps)
        elif hasattr(dep, "files"):  # a jar file
            transitive_runtime_deps.append(dep.files)
    return depset(transitive = transitive_runtime_deps)

def _source_dirname(file):
    src_path_length = len(file.short_path) - len(file.basename)
    return file.short_path[:src_path_length]

def _link_and_append(ctx, file, path, output_dir, files, paths):
    output_file = ctx.actions.declare_file("%s/%s" % (output_dir, path))
    ctx.actions.symlink(
        output = output_file,
        target_file = file,
        progress_message = "Creating symlink to %s at %s." % (output_file.path, file.path),
    )
    files.append(output_file)
    paths.append(path)

def _webapp_impl(ctx):
    output = ctx.actions.declare_directory(ctx.label.name)
    src_path = _source_dirname(output)
    output_dir = "%s_root_dir" % ctx.label.name
    files = []
    paths = []
    for input in ctx.attr.srcs:
        for f in input.files.to_list():
            path = f.path if f.is_source else f.short_path
            if path.startswith(src_path):
                path = path[len(src_path):]
            _link_and_append(ctx, f, path, output_dir, files, paths)

    dep_files = _expend_transitive_deps(ctx.attr.deps).to_list()
    for f in dep_files:
        filename = f.basename
        if f.owner.package:
            package_prefix = f.owner.package.replace("/", "_").replace("=", "_")
            filename = "%s_%s" % (package_prefix, filename)
        path = "WEB-INF/lib/%s" % filename
        _link_and_append(ctx, f, path, output_dir, files, paths)
    output_path = "%s/%s" % (output.dirname, output_dir)

    all_inputs = [f for t in ctx.attr.srcs for f in t.files.to_list()] + dep_files

    ctx.actions.run_shell(
        inputs = files + all_inputs,
        outputs = [output],
        command = "rm -rf %s && cp -R %s %s" % (output.path, output_path, output.path),
    )
    runfiles = ctx.runfiles(files = files + all_inputs)
    return [DefaultInfo(files = depset([output]), runfiles = runfiles)]

webapp = rule(
    implementation = _webapp_impl,
    doc = "Create a webapp directory.",
    attrs = {
        "srcs": attr.label_list(
            allow_empty = False,
            allow_files = True,
        ),
        "deps": attr.label_list(
            allow_empty = True,
        ),
    },
)
