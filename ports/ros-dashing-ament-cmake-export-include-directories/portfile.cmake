include(vcpkg_common_functions)

set(VCPKG_BUILD_TYPE release)

vcpkg_from_github(

    OUT_SOURCE_PATH SOURCE_PATH
    REPO gsoc-bloom-windows/ament_cmake-release
    REF vcpkg/ros-dashing-ament-cmake-export-include-directories_0.7.3-3_10
    SHA512 8c473d03cd4ddeb67ff4d3763e1d4a5d276339911b21cd504569b037e62070cef446914cd989b3541c93d7b1cc1c25bf4d274c58ee04a4ffe5f86e20e12cca56
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DCMAKE_INSTALL_PREFIX=c:\opt\rosdashing
        -DCMAKE_PREFIX_PATH=c:\opt\rosdashing
)

vcpkg_install_cmake()

file(INSTALL ${SOURCE_PATH}/license.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/ros-dashing-ament-cmake-export-include-directories RENAME copyright)
file(INSTALL ${SOURCE_PATH}/include/ros-dashing-ament-cmake-export-include-directories_for_vcpkg.h DESTINATION ${CURRENT_PACKAGES_DIR}/include)
