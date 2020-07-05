"""
Implement wget, a build rule that downloads files with wget.
"""

def _wget_impl(ctx):
    out_file = ctx.outputs.file
    url = ctx.attr.url
    wget_cmd = "wget -O %s.tmp %s" % (out_file.path, url)
    mv_cmd = "mv %s.tmp %s" % (out_file.path, out_file.path)
    ctx.actions.run_shell(
        outputs = [out_file],
        progress_message = "Downloading file from %s." % url,
        command = "%s && %s" % (wget_cmd, mv_cmd),
    )

wget = rule(
    implementation = _wget_impl,
    doc = "Download a file with wget command.",
    attrs = {
        "url": attr.string(
            doc = "URL to download the file from.",
            mandatory = True,
        ),
    },
    outputs = {
        "file": "f_%{name}",
    },
)
