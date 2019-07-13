include(vcpkg_common_functions)

set(VCPKG_BUILD_TYPE release)

vcpkg_from_github(

    OUT_SOURCE_PATH SOURCE_PATH
    REPO gsoc-bloom-windows/ament_cmake-release
    REF vcpkg/ros-dashing-ament-cmake-export-interfaces_0.7.3-3_10
    SHA512 f694328335bfe1b4d7b016711baba4c5f463ae6bdaedb78cfe252fd5aa2a9b1addacd45fbbaaef58fcdb2293c45ef99d4792464fc0c19295faf3c1cf3fdc627e
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DCMAKE_INSTALL_PREFIX=c:\\opt\\rosdashing
        -DCMAKE_PREFIX_PATH=c:\\opt\\rosdashing
)

vcpkg_install_cmake()

file(INSTALL ${SOURCE_PATH}/license.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/ros-dashing-ament-cmake-export-interfaces RENAME copyright)
file(INSTALL ${SOURCE_PATH}/include/ros-dashing-ament-cmake-export-interfaces_for_vcpkg.h DESTINATION ${CURRENT_PACKAGES_DIR}/include)
