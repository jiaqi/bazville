"""
Implement untar, a rule that untar a tar or tar.gz file into a directory.
"""

def _untar_impl(ctx):
    out_dir = ctx.actions.declare_directory(ctx.label.name)
    scripts = []
    tar_files = []
    for tar in ctx.attr.tars:
        for file in tar.files.to_list():
            tar_files.append(file)
            if file.basename.endswith(".tar.gz") or file.extension == "tgz":
                scripts.append("tar -C %s -zxvf %s" % (out_dir.path, file.path))
            elif file.extension == "tar":
                scripts.append("tar -C %s -xvf %s" % (out_dir.path, file.path))
            else:
                fail(msg = "Unexpected file type %s." % file.path, attr = "tars")
    ctx.actions.run_shell(
        inputs = tar_files,
        outputs = [out_dir],
        progress_message = "Untaring files to directory %s." % out_dir,
        command = "%s" % ("; ".join(scripts)),
    )
    return [DefaultInfo(files = depset([out_dir]))]

untar = rule(
    implementation = _untar_impl,
    doc = "Untar a tar or tar.gz files into a directory.",
    attrs = {
        "tars": attr.label_list(
            allow_empty = False,
            allow_files = [".tar", ".tar.gz", ".tgz"],
        ),
    },
)
