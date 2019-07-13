include(vcpkg_common_functions)

set(VCPKG_BUILD_TYPE release)

vcpkg_from_github(

    OUT_SOURCE_PATH SOURCE_PATH
    REPO gsoc-bloom-windows/ament_cmake-release
    REF vcpkg/ros-dashing-ament-cmake_0.7.3-3_10
    SHA512 fbd73288d9c8dbff59cc84e711da76f45fd5159a4b2a3933a86fd4b0db0f003875b019b42f6351b3b4417a6b8b2b121716d8c4da9bd06d440b065338fc9ac9cf
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DCMAKE_INSTALL_PREFIX=c:\\opt\\rosdashing
        -DCMAKE_PREFIX_PATH=c:\\opt\\rosdashing
)

vcpkg_install_cmake()

file(INSTALL ${SOURCE_PATH}/license.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/ros-dashing-ament-cmake RENAME copyright)
file(INSTALL ${SOURCE_PATH}/include/ros-dashing-ament-cmake_for_vcpkg.h DESTINATION ${CURRENT_PACKAGES_DIR}/include)
