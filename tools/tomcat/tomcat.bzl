"""
Bazel build rule for running war file with tomcat.
"""

load("//tools/base:tomcat_constants.bzl", "TOMCAT_VERSIONS")

def _link_file(ctx, src_path, dest_path):
    dest_file = ctx.actions.declare_file(dest_path)
    ctx.actions.symlink(output = dest_file, target = src_path)
    return dest_file

def _create_webapp(ctx):
    if not ctx.attr.is_app_dir:
        dest_path = "%s.tmp/webapps/%s.war"
        return _link_file(ctx, ctx.file.war_file.path, dest_path), ctx.file.war_file

    dest_dir = "%s.tmp/webapps/%s" % (ctx.label.name, ctx.attr.app_name)
    dest_file = ctx.actions.declare_directory(dest_dir)

    commands = [
        "rm -rf %s" % dest_file.path,
        "cp -R %s %s" % (ctx.file.app_dir.path, dest_file.path),
    ]
    ctx.actions.run_shell(
        inputs = [ctx.file.app_dir, ctx.file._context_xml],
        outputs = [dest_file],
        command = " && ".join(commands),
    )

    return dest_file, ctx.file.app_dir

def _create_tomcat_base(ctx):
    tomcat_home = "%s/%s" % (ctx.file.tomcat_bundle.path, ctx.attr.tomcat_bundle_path)
    output_files = [ctx.file.tomcat_bundle]
    for name in ["server.xml", "tomcat-users.xml", "web.xml", "logging.properties"]:
        source = "%s/conf/%s" % (tomcat_home, name)
        dest = "%s.tmp/conf/%s" % (ctx.label.name, name)
        output_files.append(_link_file(ctx, source, dest))

    context_xml = ctx.actions.declare_file("%s.tmp/conf/Catalina/localhost/%s.xml" % (ctx.label.name, ctx.attr.app_name))
    ctx.actions.symlink(output = context_xml, target = ctx.file._context_xml)
    output_files.append(context_xml)

    webapp, webapp_input = _create_webapp(ctx)
    output_files += [webapp, webapp_input]

    tomcat_base = ctx.actions.declare_directory(ctx.label.name)
    commands = [
        "mkdir -p %{b}",
        "cp -R %{b}.tmp/conf %{b}/conf",
        "cp -R %{b}.tmp/webapps %{b}/webapps",
    ]
    ctx.actions.run_shell(
        inputs = output_files,
        outputs = [tomcat_base],
        command = "; ".join(commands).replace("%{b}", tomcat_base.path),
    )
    output_files.append(tomcat_base)
    return tomcat_base, output_files

def _create_execution_script(ctx, tomcat_base):
    script = ctx.actions.declare_file("%s-run.sh" % ctx.label.name)
    tomcat_home = "%s/%s" % (ctx.file.tomcat_bundle.short_path, ctx.attr.tomcat_bundle_path)
    ctx.actions.expand_template(
        template = ctx.file._run_script_template,
        output = script,
        substitutions = {
            "%{java_cmd}": ctx.file._java.path,
            "%{catalina_home}": tomcat_home,
            "%{catalina_base}": tomcat_base.short_path,
            "%{jvm_opts}": " ".join(ctx.attr.jvm_opts),
        },
        is_executable = True,
    )
    return script

def _tomcat_binary_impl(ctx):
    tomcat_base, output_files = _create_tomcat_base(ctx)
    script = _create_execution_script(ctx, tomcat_base)
    runfiles = ctx.runfiles([ctx.file._java, ctx.file._context_xml] + output_files)
    return [DefaultInfo(
        executable = script,
        runfiles = runfiles,
        files = depset([tomcat_base]),
    )]

_tomcat_binary = rule(
    implementation = _tomcat_binary_impl,
    attrs = {
        "war_file": attr.label(
            allow_single_file = True,
        ),
        "app_dir": attr.label(
            allow_single_file = True,
        ),
        "app_name": attr.string(
            mandatory = True,
        ),
        "is_app_dir": attr.bool(
            mandatory = True,
        ),
        "jvm_opts": attr.string_list(
            mandatory = True,
        ),
        "tomcat_bundle": attr.label(
            mandatory = True,
            allow_single_file = True,
        ),
        "tomcat_bundle_path": attr.string(
            mandatory = True,
        ),
        "_java": attr.label(
            default = Label("@bazel_tools//tools/jdk:java"),
            allow_single_file = True,
        ),
        "_run_script_template": attr.label(
            default = Label("//tools/tomcat:run_tomcat_script.template"),
            allow_single_file = True,
        ),
        "_context_xml": attr.label(
            default = Label("//tools/tomcat:context.xml"),
            allow_single_file = True,
        ),
    },
    executable = True,
)

def tomcat_binary(
        name,
        visibility = None,
        war_file = None,
        app_dir = None,
        app_name = "ROOT",
        version = 9,
        tomcat_bundle = None,
        jvm_opts = []):
    if war_file == None and app_dir == None:
        fail("war_file or app_dir must be specified.")

    if war_file != None and app_dir != None:
        fail("Only one of war_file and app_dir should be specified.")

    path = TOMCAT_VERSIONS[version]
    if path == None:
        fail("Invalid version %s, these versions are acceptable: %s." % (version, TOMCAT_VERSIONS.keys))

    if tomcat_bundle == None:
        tomcat_bundle = "//tools/tomcat:tomcat_%s" % version

    return _tomcat_binary(
        name = name,
        visibility = visibility,
        war_file = war_file,
        app_name = app_name,
        app_dir = app_dir,
        is_app_dir = (war_file == None),
        jvm_opts = jvm_opts,
        tomcat_bundle = tomcat_bundle,
        tomcat_bundle_path = path,
    )
