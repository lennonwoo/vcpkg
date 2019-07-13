include(vcpkg_common_functions)

set(VCPKG_BUILD_TYPE release)

vcpkg_from_github(

    OUT_SOURCE_PATH SOURCE_PATH
    REPO gsoc-bloom-windows/ament_cmake-release
    REF vcpkg/ros-dashing-ament-cmake-target-dependencies_0.7.3-3_10
    SHA512 f6c0731435b459b46a47d281a7c3db6e77d6edcd7ccf28afeea30a22fd56088f3847e5fe7570df794c0dbc02eb07f94be498eda9a8d9caba311e2d5899b25317
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DCMAKE_INSTALL_PREFIX=c:\\opt\\rosdashing
        -DCMAKE_PREFIX_PATH=c:\\opt\\rosdashing
)

vcpkg_install_cmake()

file(INSTALL ${SOURCE_PATH}/license.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/ros-dashing-ament-cmake-target-dependencies RENAME copyright)
file(INSTALL ${SOURCE_PATH}/include/ros-dashing-ament-cmake-target-dependencies_for_vcpkg.h DESTINATION ${CURRENT_PACKAGES_DIR}/include)
