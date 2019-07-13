include(vcpkg_common_functions)

set(VCPKG_BUILD_TYPE release)

vcpkg_from_github(

    OUT_SOURCE_PATH SOURCE_PATH
    REPO gsoc-bloom-windows/ament_cmake-release
    REF vcpkg/ros-dashing-ament-cmake-pytest_0.7.3-3_10
    SHA512 881667db04958a0fc42bbcdda2becd8aa3f6d04cc36327b6623ffddcd492ddcebe0fa167fc08fe259cafad7d2fad1c0aa501c6afd6f6d3f5c6ef19779445b9ee
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DCMAKE_INSTALL_PREFIX=c:\\opt\\rosdashing
        -DCMAKE_PREFIX_PATH=c:\\opt\\rosdashing
)

vcpkg_install_cmake()

file(INSTALL ${SOURCE_PATH}/license.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/ros-dashing-ament-cmake-pytest RENAME copyright)
file(INSTALL ${SOURCE_PATH}/include/ros-dashing-ament-cmake-pytest_for_vcpkg.h DESTINATION ${CURRENT_PACKAGES_DIR}/include)
