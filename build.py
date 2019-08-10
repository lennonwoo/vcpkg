import em
import os
import shutil
import traceback
import zipfile

from subprocess import Popen


CHOCOLATEY_NUSPEC_DIRECTORY = "C:\\Users\\lennon\\Documents\\ROS2_choco"

CHOCOLATEY_INSTALL_PS1_CONTENTS = """\
$ErrorActionPreference = 'Stop';

$packageName= $env:ChocolateyPackageName
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileLocation = Join-Path $toolsDir archive.zip
$destination = 'c:\\opt\\ros\\dashing'

$packageArgs = @{
  packageName   = $packageName
  destination   = $destination
  fileFullPath64  = $fileLocation
}

# - https://chocolatey.org/docs/helpers-get-chocolatey-unzip
Get-ChocolateyUnzip @packageArgs
"""

CHOCOLATEY_UNINSTALL_PS1_CONTENTS = """\
$ErrorActionPreference = 'Stop';
$packageName= $env:ChocolateyPackageName
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$rootDir    = "$(Split-Path -parent $toolsDir)"
$listFile = Join-Path $rootDir archive.zip.txt

# Remove the uncompress file from archive.zip.txt
Get-Content $listFile | Foreach-Object { 
    if ($_) {
        Remove-Item $_

        # Remove the parent directory if the foler is empty
        $basePath = "$(Split-Path -parent $_)"
        while ( (Get-ChildItem $basePath | Measure-Object).Count -eq 0) {
            Remove-Item $basePath
            $basePath = "$(Split-Path -parent $basePath)"
        }
    }
}
"""


def zipdir(path, ziph, execlude_file_names):
    # ziph is zipfile handle
    for root, dirs, files in os.walk(path):
        for file in files:
            if file not in execlude_file_names:
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


def install_build_dependencies(dir):
    dependencies_config_file = os.path.join(dir, "build_dependencies.config")
    cmd = "choco install {0} -s {1} -y".format(dependencies_config_file, CHOCOLATEY_NUSPEC_DIRECTORY)
    execute_command(cmd)


def build_pkg(pkg_name):
    cmd = "install.bat {0}".format(pkg_name)
    execute_command(cmd)


def pack_chocolatey_package(pkg_name):
    # 1. Get the nuspec generated from Bloom
    # Assume old dir is the vcpkg root path
    old_dir = os.getcwd()
    nuspec_filename = pkg_name+".nuspec"
    bloom_generated_nuspec_path = os.path.join(old_dir, "ports", pkg_name, nuspec_filename)

    # 2. change to installed dir and clean tree
    vcpkg_package_installed_dir = os.path.join(old_dir, "packages", pkg_name+"_x64-windows")
    os.chdir(vcpkg_package_installed_dir)

    # 3. create the archive of built binary files in current directory
    zip_filename = "archive.zip"
    zipf = zipfile.ZipFile(zip_filename, 'w', zipfile.ZIP_DEFLATED)
    execlude_file_names = [
        "CONTROL",
        "BUILD_INFO",
        zip_filename,
    ]
    zipdir('.', zipf, execlude_file_names)
    zipf.close()

    # 4. create a directory named nuspec, then copy nuspec templates and zip archive this directory
    shutil.rmtree("nuspec", ignore_errors=True)
    os.mkdir("nuspec")
    os.mkdir(os.path.join("nuspec", "tools"))
    shutil.copy(bloom_generated_nuspec_path, os.path.join("nuspec", nuspec_filename))
    shutil.copy(zip_filename, "nuspec\\tools\\archive.zip")

    # 5. Generate the nuspec install/uninstall scripts
    os.chdir("nuspec")
    with open("tools\\chocolateyInstall.ps1", "w") as f:
       f.write(CHOCOLATEY_INSTALL_PS1_CONTENTS)
    with open("tools\\chocolateyUninstall.ps1", "w") as f:
       f.write(CHOCOLATEY_UNINSTALL_PS1_CONTENTS)

    # 6. pack to Chocolatey local archive directory
    cmd = "nuget pack -OutputDirectory {0} {1} -NoDefaultExcludes".format(CHOCOLATEY_NUSPEC_DIRECTORY, nuspec_filename)
    execute_command(cmd)

    # 7. change back to vcpkg root path
    os.chdir(old_dir)


def handle_package(pkg_name):
    print("="*60)
    print("="*20+ "Handling with package: {0}".format(pkg_name) +"="*20)
    print("="*60)
    directory = os.path.join("ports", pkg_name)
    install_build_dependencies(directory)
    build_pkg(pkg_name)
    pack_chocolatey_package(pkg_name)


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
    except Exception:
        print(traceback.format_exc())
    finally:
        os.chdir(old_dir)
        with open('finished_pkgs.txt', 'a') as f:
            for p in done_pkgs:
                f.write(p+"\n")


if __name__ == "__main__":
    main()
