load("//tools/base:wget.bzl", "wget")
load("//tools/base:untar.bzl", "untar")
load("//tools/base:tomcat_constants.bzl", "TOMCAT_VERSIONS")

package(default_visibility = ["//visibility:public"])

wget(
    name = "tomcat_7.tar.gz",
    url = "http://dist.cyclopsgroup.org/download/tomcat/%s.tar.gz" % TOMCAT_VERSIONS[7],
)

untar(
    name = "tomcat_7",
    tars = [":tomcat_7.tar.gz"],
)

wget(
    name = "tomcat_8.tar.gz",
    url = "http://dist.cyclopsgroup.org/download/tomcat/%s.tar.gz" % TOMCAT_VERSIONS[8],
)

untar(
    name = "tomcat_8",
    tars = [":tomcat_8.tar.gz"],
)

wget(
    name = "tomcat_9.tar.gz",
    url = "http://dist.cyclopsgroup.org/download/tomcat/%s.tar.gz" % TOMCAT_VERSIONS[9],
)

untar(
    name = "tomcat_9",
    tars = [":tomcat_9.tar.gz"],
)

wget(
    name = "tomcat_10.tar.gz",
    url = "http://dist.cyclopsgroup.org/download/tomcat/%s.tar.gz" % TOMCAT_VERSIONS[10],
)

untar(
    name = "tomcat_10",
    tars = [":tomcat_10.tar.gz"],
)

exports_files([
    "run_tomcat_script.template",
    "context.xml",
])
