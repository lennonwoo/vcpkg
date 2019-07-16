include(vcpkg_common_functions)

set(VCPKG_BUILD_TYPE release)

vcpkg_from_github(

    OUT_SOURCE_PATH SOURCE_PATH
    REPO gsoc-bloom-windows/ament_package-release
    REF vcpkg/ros-dashing-ament-package_0.7.0-3_10
    SHA512 757cb463b7e1797b64c6d3487d33e9892690f946c4c205e977b9492d30f2673f5517718a53cc7f4dda63fff244407b2175e6d06136945c39d7f30e547e476362
)

find_package(PythonInterp 3)

if (${PYTHONINTERP_FOUND})
    set(SETUP_INSTALL_PREFIX "${SOURCE_PATH}/C/opt/ros/dashing")
    set(SETUP_INSTALL_PYTHONPATH "${SETUP_INSTALL_PREFIX}/Lib/site-packages")
    file(TO_NATIVE_PATH "${SETUP_INSTALL_PREFIX}" SETUP_INSTALL_PREFIX)
    file(TO_NATIVE_PATH "${SETUP_INSTALL_PYTHONPATH}" SETUP_INSTALL_PYTHONPATH)

    # make the Lib
    file(MAKE_DIRECTORY ${SETUP_INSTALL_PYTHONPATH})
    set(INSTALL_CMD
        ${CMAKE_COMMAND} -E env PYTHONPATH=${SETUP_INSTALL_PYTHONPATH}
        ${PYTHON_EXECUTABLE}
        setup.py
        egg_info --egg-base .
        build --build-base build
        install --prefix ${SETUP_INSTALL_PREFIX}
        --record install.log
        --single-version-externally-managed
        )

    message(STATUS "CURRENT_PACKAGES_DIR: ${CURRENT_PACKAGES_DIR}")
    message(STATUS "SETUP_INSTALL_PYTHONPATH: ${SETUP_INSTALL_PYTHONPATH}")
    message(STATUS "SETUP_INSTALL_PREFIX: ${SETUP_INSTALL_PREFIX}")
    message(STATUS "INSTALL_CMD: ${INSTALL_CMD}")
    execute_process(
        COMMAND ${INSTALL_CMD}
        WORKING_DIRECTORY ${SOURCE_PATH}
    )
endif()

# file(INSTALL ${SOURCE_PATH}/license.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/ros-dashing-ament-package RENAME copyright)
# file(INSTALL ${SOURCE_PATH}/include/ros-dashing-ament-package_for_vcpkg.h DESTINATION ${CURRENT_PACKAGES_DIR}/include)
