include(vcpkg_common_functions)

set(VCPKG_BUILD_TYPE release)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO gsoc-bloom-windows/ros_testing-release
    REF vcpkg/ros-dashing-ros2test_0.1.0-6_10
)

find_package(PythonInterp 3)

if (${PYTHONINTERP_FOUND})
    set(SETUP_INSTALL_PREFIX "${CURRENT_PACKAGES_DIR}/opt/ros/dashing")
    set(SETUP_INSTALL_PYTHONPATH "${SETUP_INSTALL_PREFIX}/Lib/site-packages")
    file(TO_NATIVE_PATH "${SETUP_INSTALL_PREFIX}" SETUP_INSTALL_PREFIX)
    file(TO_NATIVE_PATH "${SETUP_INSTALL_PYTHONPATH}" SETUP_INSTALL_PYTHONPATH)

    # make the directory
    file(MAKE_DIRECTORY ${SETUP_INSTALL_PYTHONPATH})
    set(INSTALL_CMD
        # if we want to use install --prefix, we must use following line to set PYTHONPATH
        ${CMAKE_COMMAND} -E env PYTHONPATH=${SETUP_INSTALL_PYTHONPATH}
        ${PYTHON_EXECUTABLE}
        setup.py
        egg_info --egg-base .
        build --build-base build
        install --prefix ${SETUP_INSTALL_PREFIX}
        --record install.log
        --single-version-externally-managed
        )

    execute_process(
        COMMAND ${INSTALL_CMD}
        WORKING_DIRECTORY ${SOURCE_PATH}
    )
else()
    message(FATAL_ERROR "Python executable not fould, stop building")
endif()