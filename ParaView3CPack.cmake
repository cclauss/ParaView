# setup CPack

# This ensures that CMake doesn't add the install rules to install the
# system libraries. We add them to one of the components we install.
SET (CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP 1)
INCLUDE(InstallRequiredSystemLibraries)
IF (CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS)
  INSTALL(FILES ${CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS}
    DESTINATION ${PV_EXE_INSTALL}
    PERMISSIONS OWNER_WRITE OWNER_READ OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ
    COMPONENT Runtime)

  # Install the runtimes to the lib dir as well since python modules are
  # installed in that directory and the manifest files need to present there as
  # well.
  INSTALL(FILES ${CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS}
    DESTINATION ${PV_INSTALL_LIB_DIR}
    PERMISSIONS OWNER_WRITE OWNER_READ OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ
    COMPONENT Runtime)
ENDIF (CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS)

# Set up a CPack project config file so that we can build either the paraview command
# line tools .tar.gz file or the client application (bundle) .dmg file on the Mac.
# CPACK_INSTALL_CMAKE_PROJECTS is set in the CPACK_PROJECT_CONFIG_FILE file based
# on which CPack generator is used...
#
CONFIGURE_FILE("${CMAKE_CURRENT_SOURCE_DIR}/ParaView3CPackOptions.cmake.in"
  "${CMAKE_CURRENT_BINARY_DIR}/ParaView3CPackOptions.cmake" @ONLY)
SET(CPACK_PROJECT_CONFIG_FILE "${CMAKE_CURRENT_BINARY_DIR}/ParaView3CPackOptions.cmake")

# Change the default ON/OFF settings for these CPack generators on the Mac so that a
# plain old "cpack" or "make package" invocation on the Mac builds both the command
# line tools .tar.gz and the bundle .dmg file all at once... but nothing else.
#
IF(APPLE)
  SET(CPACK_BINARY_TBZ2 OFF)
  SET(CPACK_BINARY_DRAGNDROP ON)
  SET(CPACK_BINARY_PACKAGEMAKER OFF)
  SET(CPACK_BINARY_STGZ OFF)
ENDIF(APPLE)

SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "ParaView is a scientific visualization tool")
SET(CPACK_PACKAGE_VENDOR "Kitware Inc.")
SET(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/License_v1.2.txt")
SET(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/License_v1.2.txt")
SET(CPACK_PACKAGE_VERSION_MAJOR "${PARAVIEW_VERSION_MAJOR}")
SET(CPACK_PACKAGE_VERSION_MINOR "${PARAVIEW_VERSION_MINOR}")
SET(CPACK_PACKAGE_VERSION_PATCH "${PARAVIEW_VERSION_PATCH}")
SET(CPACK_PACKAGE_INSTALL_DIRECTORY "ParaView ${PARAVIEW_VERSION_MAJOR}.${PARAVIEW_VERSION_MINOR}.${PARAVIEW_VERSION_PATCH}")
SET(CPACK_SOURCE_PACKAGE_FILE_NAME "paraview-${PARAVIEW_VERSION_FULL}")

IF (CMAKE_SYSTEM_PROCESSOR MATCHES "unknown")
  SET (CMAKE_SYSTEM_PROCESSOR "x86")
ENDIF (CMAKE_SYSTEM_PROCESSOR MATCHES "unknown")
IF(NOT DEFINED CPACK_SYSTEM_NAME)
  SET(CPACK_SYSTEM_NAME ${CMAKE_SYSTEM_NAME}-${CMAKE_SYSTEM_PROCESSOR})
ENDIF(NOT DEFINED CPACK_SYSTEM_NAME)
IF(${CPACK_SYSTEM_NAME} MATCHES Windows)
  IF(CMAKE_CL_64)
    SET(CPACK_SYSTEM_NAME win64-${CMAKE_SYSTEM_PROCESSOR})
  ELSE(CMAKE_CL_64)
    SET(CPACK_SYSTEM_NAME win32-${CMAKE_SYSTEM_PROCESSOR})
  ENDIF(CMAKE_CL_64)
ENDIF(${CPACK_SYSTEM_NAME} MATCHES Windows)
IF(NOT DEFINED CPACK_PACKAGE_FILE_NAME)
  SET(CPACK_PACKAGE_FILE_NAME "${CPACK_SOURCE_PACKAGE_FILE_NAME}-${CPACK_SYSTEM_NAME}")
ENDIF(NOT DEFINED CPACK_PACKAGE_FILE_NAME)
SET(CPACK_PACKAGE_EXECUTABLES "paraview" "ParaView")
IF(WIN32 AND NOT UNIX)
  # There is a bug in NSI that does not handle full unix paths properly. Make
  # sure there is at least one set of four (4) backlasshes.
  SET(CPACK_PACKAGE_ICON "${ParaView_SOURCE_DIR}/Applications/Client\\\\ParaViewLogo.png")
  SET(CPACK_NSIS_INSTALLED_ICON_NAME "bin\\\\paraview.exe")
  SET(CPACK_NSIS_DISPLAY_NAME "${CPACK_PACKAGE_INSTALL_DIRECTORY} a cross-platform, open-source visualization system")
  SET(CPACK_NSIS_PACKAGE_NAME "${CPACK_PACKAGE_INSTALL_DIRECTORY}")
  SET(CPACK_NSIS_HELP_LINK "http://www.paraview.org")
  SET(CPACK_NSIS_URL_INFO_ABOUT "http://www.kitware.com")
  SET(CPACK_NSIS_CONTACT "webmaster@paraview.org")
  SET(CPACK_NSIS_MODIFY_PATH OFF)
  SET(CPACK_NSIS_MUI_ICON "${ParaView_SOURCE_DIR}/Applications/Client\\\\paraqlogo.ico")
  SET(CPACK_NSIS_MUI_UNIICON "${ParaView_SOURCE_DIR}/Applications/Client\\\\paraqlogo.ico")
  # set the package header icon for MUI
  SET(CPACK_PACKAGE_ICON "${ParaView_SOURCE_DIR}/Applications/Client\\\\ParaViewLogo.png")
  
ELSE(WIN32 AND NOT UNIX)
  SET(CPACK_STRIP_FILES "")
  SET(CPACK_SOURCE_STRIP_FILES "")
  IF (NOT APPLE)
    SET(CPACK_GENERATOR TGZ)
  ENDIF (NOT APPLE)
ENDIF(WIN32 AND NOT UNIX)
INCLUDE(CPack)
