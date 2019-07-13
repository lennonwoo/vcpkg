include(vcpkg_common_functions)

set(VCPKG_BUILD_TYPE release)

vcpkg_from_github(

    OUT_SOURCE_PATH SOURCE_PATH
    REPO gsoc-bloom-windows/ament_cmake-release
    REF vcpkg/ros-dashing-ament-cmake-libraries_0.7.3-3_10
    SHA512 ed79ac70227eaf7c8514ea7c4139b28d0051bfb37c5b6686b69316186e89de605be1864f6e00c43c682c871fc997a8010b5a89ad9a837f3c97ed4763c5a00412
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DCMAKE_INSTALL_PREFIX=c:\opt\rosdashing
        -DCMAKE_PREFIX_PATH=c:\opt\rosdashing
)

vcpkg_install_cmake()

file(INSTALL ${SOURCE_PATH}/license.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/ros-dashing-ament-cmake-libraries RENAME copyright)
file(INSTALL ${SOURCE_PATH}/include/ros-dashing-ament-cmake-libraries_for_vcpkg.h DESTINATION ${CURRENT_PACKAGES_DIR}/include)
