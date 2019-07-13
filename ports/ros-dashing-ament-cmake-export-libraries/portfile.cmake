include(vcpkg_common_functions)

set(VCPKG_BUILD_TYPE release)

vcpkg_from_github(

    OUT_SOURCE_PATH SOURCE_PATH
    REPO gsoc-bloom-windows/ament_cmake-release
    REF vcpkg/ros-dashing-ament-cmake-export-libraries_0.7.3-3_10
    SHA512 c3e86f276f2f95166a41617b8121ec74a2c60b4780d896e8c9ada66057dd252d4a3decdef4214d0794ecb8b10244aef8a894e5eb1277dda48fe4052b0189b411
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DCMAKE_INSTALL_PREFIX=c:\\opt\\rosdashing
        -DCMAKE_PREFIX_PATH=c:\\opt\\rosdashing
)

vcpkg_install_cmake()

file(INSTALL ${SOURCE_PATH}/license.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/ros-dashing-ament-cmake-export-libraries RENAME copyright)
file(INSTALL ${SOURCE_PATH}/include/ros-dashing-ament-cmake-export-libraries_for_vcpkg.h DESTINATION ${CURRENT_PACKAGES_DIR}/include)
