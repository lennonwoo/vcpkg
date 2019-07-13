include(vcpkg_common_functions)

set(VCPKG_BUILD_TYPE release)

vcpkg_from_github(

    OUT_SOURCE_PATH SOURCE_PATH
    REPO gsoc-bloom-windows/ament_cmake-release
    REF vcpkg/ros-dashing-ament-cmake-gmock_0.7.3-3_10
    SHA512 ddeec4d13d234c38c281cb7154fadd9a86e82506daccb147373e68ee584e6f6fa0ad5511c68a7489a811dc1d35f6219a6c6bff4c965fdaa78a780ca7564ee349
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DCMAKE_INSTALL_PREFIX=c:\\opt\\rosdashing
        -DCMAKE_PREFIX_PATH=c:\\opt\\rosdashing
)

vcpkg_install_cmake()

file(INSTALL ${SOURCE_PATH}/license.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/ros-dashing-ament-cmake-gmock RENAME copyright)
file(INSTALL ${SOURCE_PATH}/include/ros-dashing-ament-cmake-gmock_for_vcpkg.h DESTINATION ${CURRENT_PACKAGES_DIR}/include)
