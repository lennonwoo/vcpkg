include(vcpkg_common_functions)

set(VCPKG_BUILD_TYPE release)

vcpkg_from_github(

    OUT_SOURCE_PATH SOURCE_PATH
    REPO gsoc-bloom-windows/ament_cmake-release
    REF vcpkg/ros-dashing-ament-cmake-gtest_0.7.3-3_10
    SHA512 2ee184a79f05f5aea041628f0261c2febdb9138fe63e1605aeb4d2c519ca8d19b4f6d0af15977c026f882912aab1e0548b55d08f190d0543ed1cfc5ee89eb6af
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DCMAKE_INSTALL_PREFIX=c:\\opt\\rosdashing
        -DCMAKE_PREFIX_PATH=c:\\opt\\rosdashing
)

vcpkg_install_cmake()

file(INSTALL ${SOURCE_PATH}/license.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/ros-dashing-ament-cmake-gtest RENAME copyright)
file(INSTALL ${SOURCE_PATH}/include/ros-dashing-ament-cmake-gtest_for_vcpkg.h DESTINATION ${CURRENT_PACKAGES_DIR}/include)
