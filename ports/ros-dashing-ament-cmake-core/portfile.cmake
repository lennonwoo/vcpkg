include(vcpkg_common_functions)

set(VCPKG_BUILD_TYPE release)

vcpkg_from_github(

    OUT_SOURCE_PATH SOURCE_PATH
    REPO gsoc-bloom-windows/ament_cmake-release
    REF vcpkg/ros-dashing-ament-cmake-core_0.7.3-3_10
    SHA512 cf675392b663e84e144e851956ec58936ad85a0ca7d661d95c4429fa4e171767649bb3bbab7f51b21feae05a9bd14647ee377f62daacfc5734f59fe1b6c1302c
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DCMAKE_INSTALL_PREFIX=c:\\opt\\rosdashing
        -DCMAKE_PREFIX_PATH=c:\\opt\\rosdashing
)

vcpkg_install_cmake()

file(INSTALL ${SOURCE_PATH}/license.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/ros-dashing-ament-cmake-core RENAME copyright)
file(INSTALL ${SOURCE_PATH}/include/ros-dashing-ament-cmake-core_for_vcpkg.h DESTINATION ${CURRENT_PACKAGES_DIR}/include)
