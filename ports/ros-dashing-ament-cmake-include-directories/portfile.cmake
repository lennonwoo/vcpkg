include(vcpkg_common_functions)

set(VCPKG_BUILD_TYPE release)

vcpkg_from_github(

    OUT_SOURCE_PATH SOURCE_PATH
    REPO gsoc-bloom-windows/ament_cmake-release
    REF vcpkg/ros-dashing-ament-cmake-include-directories_0.7.3-3_10
    SHA512 d7c362507ba601a362df8d63d1657fb6a06d1ecc362efb6023f8187b44492aaa45a32aff54dfc3fbe60b3a74015be32b8a52970d837b39997c11cc131b6c3ea5
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DCMAKE_INSTALL_PREFIX=c:\\opt\\rosdashing
        -DCMAKE_PREFIX_PATH=c:\\opt\\rosdashing
)

vcpkg_install_cmake()

file(INSTALL ${SOURCE_PATH}/license.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/ros-dashing-ament-cmake-include-directories RENAME copyright)
file(INSTALL ${SOURCE_PATH}/include/ros-dashing-ament-cmake-include-directories_for_vcpkg.h DESTINATION ${CURRENT_PACKAGES_DIR}/include)
