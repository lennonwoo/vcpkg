import em
import os
import shutil
import traceback
import zipfile

from subprocess import Popen

from catkin_pkg.packages import find_packages

from rosdep_interface import get_dependencies
from rosdep_interface import rosify_name


CHOCOLATEY_NUSPEC_DIRECTORY = "C:\\Users\\lennon\\Documents\\ROS2_choco"

CHOCOLATEY_INSTALL_PS1_CONTENTS = """\
$ErrorActionPreference = 'Stop';

$packageName= $env:ChocolateyPackageName
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileLocation = Join-Path $toolsDir '{pkg_name}.zip'
$destination = 'c:\\'

$packageArgs = @{{
  packageName   = $packageName
  destination   = $destination
  fileFullPath64  = $fileLocation
}}

# - https://chocolatey.org/docs/helpers-get-chocolatey-unzip
Get-ChocolateyUnzip @packageArgs
"""


def zipdir(path, ziph):
    # ziph is zipfile handle
    for root, dirs, files in os.walk(path):
        for file in files:
            ziph.write(os.path.join(root, file))


def execute_command(cmd, echo_cmd=False, retry=2):
    if echo_cmd:
        print("="*60)
        print(cmd)
        print("="*60)
    p = Popen(cmd)
    out, err = p.communicate()
    result = p.returncode
    if result != 0:
        print("err: {0}".format(err))
        if retry > 0:
            execute_command(cmd, echo_cmd=echo_cmd, retry=retry-1)
        else:
            print("cmd: {0} execute failed".format(cmd))
            exit(0)


def install_build_dependencies(build_deps):
    for dep in build_deps:
        cmd = "choco install {0} -s {1} -y".format(dep, CHOCOLATEY_NUSPEC_DIRECTORY)
        execute_command(cmd)


def build_pkg(pkg_name):
    cmd = "install.bat {0}".format(pkg_name)
    execute_command(cmd)


def pack_chocolatey_package(pkg, execute_deps):
    # 1. Get the nuspec generated from Bloom
    # Assume old dir is the vcpkg root path
    print("execute_deps: {0}".format(execute_deps))
    old_dir = os.getcwd()
    pkg_name = rosify_name(pkg.name)
    nuspec_filename = pkg_name+".nuspec"
    bloom_generated_nuspec_path = os.path.join(old_dir, "ports", pkg_name, nuspec_filename)

    # 2. change to installed dir
    vcpkg_package_installed_dir = os.path.join(old_dir, "packages", pkg_name+"_x64-windows")
    os.chdir(vcpkg_package_installed_dir)

    shutil.rmtree("nuspec", ignore_errors=True)
    os.mkdir("nuspec")
    os.mkdir(os.path.join("nuspec", "tools"))
    shutil.copy(bloom_generated_nuspec_path, os.path.join("nuspec", nuspec_filename))

    # 3. We install the binary files to opt directory in <vcpkg-root>/packages/<package-specific-dir>
    #    so create a archive
    zipf = zipfile.ZipFile('nuspec\\tools\\{0}.zip'.format(pkg_name), 'w', zipfile.ZIP_DEFLATED)
    zipdir('opt', zipf)
    zipf.close()

    # 4. Generate the nuspec install/uninstall scripts
    os.chdir("nuspec")
    with open("tools\\chocolateyInstall.ps1", "w") as f:
       f.write(CHOCOLATEY_INSTALL_PS1_CONTENTS.format(pkg_name))

    # 4. pack to Chocolatey local archive directory
    cmd = "nuget pack -OutputDirectory {0} {1} -NoDefaultExcludes".format(CHOCOLATEY_NUSPEC_DIRECTORY, nuspec_filename)
    execute_command(cmd)

    # 5. change back to vcpkg root path
    os.chdir(old_dir)


def handle_package(pkg):
    print("="*60)
    print("="*20+ "Handling with package: {0}".format(pkg) +"="*20)
    print("="*60)
    directory = os.path.join("ports", pkg)
    p = find_packages(directory)
    p = p['.']
    execute_deps, build_deps, all_depends = get_dependencies(p)
    install_build_dependencies(all_depends)
    build_pkg(pkg)
    pack_chocolatey_package(p, execute_deps)


def main():
    with open("topological_pkgs.txt") as f:
        pkgs = [pkg.strip() for pkg in f.readlines()]
    with open('finished_pkgs.txt', 'r') as f:
        finished_pkgs = [p.strip() for p in f.readlines()]

    old_dir = os.getcwd()
    done_pkgs = []
    try:
        for p in pkgs:
            if p not in finished_pkgs:
                handle_package(p)
                done_pkgs.append(p)
                # exit(0)
    except Exception:
        print(traceback.format_exc())
    finally:
        os.chdir(old_dir)
        with open('finished_pkgs.txt', 'a') as f:
            for p in done_pkgs:
                f.write(p+"\n")


def improve():
    handle_package("ros-dashing-ros-workspace")


if __name__ == "__main__":
    main()
    # improve()