include(vcpkg_common_functions)

set(VCPKG_BUILD_TYPE release)

vcpkg_from_github(

    OUT_SOURCE_PATH SOURCE_PATH
    REPO gsoc-bloom-windows/ros_workspace-release
    REF vcpkg/ros-dashing-ros-workspace_0.7.1-3_10
    SHA512 0612ac6aeda5c67cd61cb9d7d85d3a1a5d256bb3266ece7240cd3432ea060eb75840629dc09dd2a25acb16384463150336ac2c79cd16ba6a907399f529c7e529
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DCMAKE_INSTALL_PREFIX=c:\\opt\\ros\\dashing
        -DAMENT_PREFIX_PATH=c:\\opt\\ros\\dashing
)

vcpkg_install_cmake()

file(INSTALL ${SOURCE_PATH}/license.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/ros-dashing-ros-workspace RENAME copyright)
file(INSTALL ${SOURCE_PATH}/include/ros-dashing-ros-workspace_for_vcpkg.h DESTINATION ${CURRENT_PACKAGES_DIR}/include)

