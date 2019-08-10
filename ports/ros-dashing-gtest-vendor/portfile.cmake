include(vcpkg_common_functions)

set(VCPKG_BUILD_TYPE release)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO gsoc-bloom-windows/googletest-release
    REF vcpkg/ros-dashing-gtest-vendor_1.8.9000-10_10
)

set(ROS_BASE_PATH "C:/opt/ros/dashing")
file(TO_NATIVE_PATH "${ROS_BASE_PATH}" ROS_BASE_PATH)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
		-DAMENT_PREFIX_PATH=${ROS_BASE_PATH}
)

vcpkg_install_cmake()
