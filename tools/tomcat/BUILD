load("//tools/base:wget.bzl", "wget")
load("//tools/base:untar.bzl", "untar")

package(default_visibility = ["//visibility:public"])

wget(
    name = "apache-tomcat-7.0.104.tar.gz",
    url = "http://dist.cyclopsgroup.org/download/tomcat/apache-tomcat-7.0.104.tar.gz",
)

untar(
    name = "tomcat-7",
    tars = [":tomcat-7.0.104.tar.gz"],
)

wget(
    name = "tomcat-8.5.56.tar.gz",
    url = "http://dist.cyclopsgroup.org/download/tomcat/apache-tomcat-8.5.56.tar.gz",
)

untar(
    name = "tomcat-8",
    tars = [":tomcat-8.5.56.tar.gz"],
)

wget(
    name = "tomcat-9.0.36.tar.gz",
    url = "http://dist.cyclopsgroup.org/download/tomcat/apache-tomcat-9.0.36.tar.gz",
)

untar(
    name = "tomcat-9",
    tars = [":tomcat-9.0.36.tar.gz"],
)

wget(
    name = "tomcat-10.0.0-M6.tar.gz",
    url = "http://dist.cyclopsgroup.org/download/tomcat/apache-tomcat-10.0.0-M6.tar.gz",
)

untar(
    name = "tomcat-10",
    tars = [":tomcat-10.0.0-M6.tar.gz"],
)

exports_files([
    "run_tomcat_script.template",
    "context.xml",
])
