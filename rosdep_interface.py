from rosdep2 import create_default_installer_context
from rosdep2.catkin_support import get_catkin_view
from rosdep2.lookup import ResolutionError
import rosdep2.catkin_support

def resolve_more_for_os(rosdep_key, view, installer, os_name, os_version):
    """
    Resolve rosdep key to dependencies and installer key.
    (This was copied from rosdep2.catkin_support)

    :param os_name: OS name, e.g. 'ubuntu'
    :returns: resolved key, resolved installer key, and default installer key

    :raises: :exc:`rosdep2.ResolutionError`
    """
    d = view.lookup(rosdep_key)
    ctx = create_default_installer_context()
    os_installers = ctx.get_os_installer_keys(os_name)
    default_os_installer = ctx.get_default_os_installer_key(os_name)
    inst_key, rule = d.get_rule_for_platform(os_name, os_version,
                                             os_installers,
                                             default_os_installer)
    assert inst_key in os_installers
    return installer.resolve(rule), inst_key, default_os_installer

view_cache = {}


def get_view(os_name, os_version, ros_distro):
    global view_cache
    key = os_name + os_version + ros_distro
    if key not in view_cache:
        value = get_catkin_view(ros_distro, os_name, os_version, False)
        view_cache[key] = value
    return view_cache[key]

def resolve_rosdep_key(
        key,
        os_name,
        os_version,
        ros_distro=None,
        ignored=None,
        retry=True
):
    ignored = ignored or []
    ctx = create_default_installer_context()
    try:
        installer_key = ctx.get_default_os_installer_key(os_name)
    except KeyError:
        raise Exception("Could not determine the installer for '{0}'"
                            .format(os_name))
    installer = ctx.get_installer(installer_key)
    ros_distro = ros_distro
    view = get_view(os_name, os_version, ros_distro)
    try:
        return resolve_more_for_os(key, view, installer, os_name, os_version)
    except (KeyError, ResolutionError) as exc:
        # print("Key: {0} doesn't fit vcpkg".format(key))
        return None, None, None
        debug(traceback.format_exc())
        if key in ignored:
            return None, None, None
        if isinstance(exc, KeyError):
            error("Could not resolve rosdep key '{0}'".format(key))
            returncode = code.GENERATOR_NO_SUCH_ROSDEP_KEY
        else:
            error("Could not resolve rosdep key '{0}' for distro '{1}':"
                  .format(key, os_version))
            info(str(exc), use_prefix=False)
            returncode = code.GENERATOR_NO_ROSDEP_KEY_FOR_DISTRO
        if retry:
            error("Try to resolve the problem with rosdep and then continue.")
            if maybe_continue():
                update_rosdep()
                invalidate_view_cache()
                return resolve_rosdep_key(key, os_name, os_version, ros_distro,
                                          ignored, retry=True)
        BloomGenerator.exit("Failed to resolve rosdep key '{0}', aborting."
                            .format(key), returncode=returncode)

def resolve_dependencies(
        keys,
        os_name,
        os_version,
        ros_distro=None,
        peer_packages=None,
):
    ros_distro = ros_distro
    peer_packages = peer_packages or []

    resolved_keys = {}
    keys = [k.name for k in keys]
    for key in keys:
        resolved_key, installer_key, default_installer_key = \
            resolve_rosdep_key(key, os_name, os_version, ros_distro,
                               peer_packages, retry=True)
        # Do not compare the installer key here since this is a general purpose function
        # They installer is verified in the OS specific generator, when the keys are pre-checked.
        if resolved_key is None:
            resolved_key = ""
        resolved_keys[key] = resolved_key
    return resolved_keys


def get_dependencies(package):
    package.evaluate_conditions( {
        'ROS_VERSION': 2,
        'ROS_DISTRO': 'dashing',
    })
    depends = [
        dep for dep in (package.run_depends + package.buildtool_export_depends)
        if dep.evaluated_condition]
    build_depends = [
        dep for dep in (package.build_depends + package.buildtool_depends + package.test_depends)
        if dep.evaluated_condition]
    unresolved_keys = [
        dep for dep in (depends + build_depends + package.replaces + package.conflicts)
        if dep.evaluated_condition]


    resolved_deps = resolve_dependencies(unresolved_keys, 'windows',
                                         '10', 'dashing',
                                         [] + [d.name for d in package.replaces + package.conflicts])

    depends = sorted(
        list(format_depends(depends, resolved_deps))
    )
    build_depends = sorted(
        list(format_depends(build_depends, resolved_deps))
    )
    if package.name == 'ros_workspace':
        build_depends.append('ros-dashing-ament-package')
        depends.append('ros-dashing-ament-package')
    elif package.name not in ['ament_package', 'ros_workspace', 'ament_cmake_core']:
        build_depends.append('ros-dashing-ros-workspace')
        depends.append('ros-dashing-ros-workspace')

    all_depends = set(depends + build_depends)
    
    return depends, build_depends, all_depends

def rosify_name(name, ros_distro="dashing"):
    return "-".join(["ros", "dashing", name]).replace("_", "-")

def format_depends(depends, resolved_deps):
    formatted = []
    for d in depends:
        for resolved_dep in resolved_deps[d.name]:
            if resolved_dep != "" and "opensplice" not in resolved_dep and "connext" not in resolved_dep:
                formatted.append(resolved_dep)
    return formatted
