include(vcpkg_common_functions)

set(VCPKG_BUILD_TYPE release)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO gsoc-bloom-windows/libyaml_vendor-release
    REF vcpkg/ros-dashing-libyaml-vendor_1.0.0-10_10
)

set(ROS_BASE_PATH "C:/opt/ros/dashing")
file(TO_NATIVE_PATH "${ROS_BASE_PATH}" ROS_BASE_PATH)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DAMENT_PREFIX_PATH=${ROS_BASE_PATH}
)

vcpkg_install_cmake()
