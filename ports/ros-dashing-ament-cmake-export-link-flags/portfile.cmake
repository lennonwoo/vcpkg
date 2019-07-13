include(vcpkg_common_functions)

set(VCPKG_BUILD_TYPE release)

vcpkg_from_github(

    OUT_SOURCE_PATH SOURCE_PATH
    REPO gsoc-bloom-windows/ament_cmake-release
    REF vcpkg/ros-dashing-ament-cmake-export-link-flags_0.7.3-3_10
    SHA512 7984216de8137fcbdc2954e9ff6db0dbfc4ba915ee08c3623b116cd06eda341ae8cbb45acb98a5d496801f1b91ef9676edfdb35e8d47b38811897d1bcd467885
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DCMAKE_INSTALL_PREFIX=c:\opt\rosdashing
        -DCMAKE_PREFIX_PATH=c:\opt\rosdashing
)

vcpkg_install_cmake()

file(INSTALL ${SOURCE_PATH}/license.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/ros-dashing-ament-cmake-export-link-flags RENAME copyright)
file(INSTALL ${SOURCE_PATH}/include/ros-dashing-ament-cmake-export-link-flags_for_vcpkg.h DESTINATION ${CURRENT_PACKAGES_DIR}/include)
