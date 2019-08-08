include(vcpkg_common_functions)

set(VCPKG_BUILD_TYPE release)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO gsoc-bloom-windows/demos-release
    REF vcpkg/ros-dashing-quality-of-service-demo-cpp_0.7.8-6_10
)

set(ROS_BASE_PATH "C:/opt/ros/dashing")
file(TO_NATIVE_PATH "${ROS_BASE_PATH}" ROS_BASE_PATH)
set(ENV{DESTDIR} ${CURRENT_PACKAGES_DIR})

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DCMAKE_INSTALL_PREFIX=${ROS_BASE_PATH}
        -DAMENT_PREFIX_PATH=${ROS_BASE_PATH}
)

vcpkg_install_cmake()
