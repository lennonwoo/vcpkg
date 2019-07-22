from subprocess import Popen

with open("topological_pkgs.txt") as f:
    pkgs = [pkg.strip() for pkg in f.readlines()]
    for p in pkgs:
        cmd = "install.bat {0}".format(p)
        p = Popen(cmd)
        out, err = p.communicate()
        result = p.returncode
        if result != 0:
            exit(0)
