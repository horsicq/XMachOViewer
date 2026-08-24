if(TARGET Qt6::Core OR TARGET Qt6::Widgets)
    set(XMACHOVIEWER_QT_MAJOR 6)
elseif(TARGET Qt5::Core OR TARGET Qt5::Widgets)
    set(XMACHOVIEWER_QT_MAJOR 5)
else()
    find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core)
    set(XMACHOVIEWER_QT_MAJOR ${QT_VERSION_MAJOR})
endif()

set(XMACHOVIEWER_QT_COMPONENTS
    Widgets
    Concurrent
    Network
    PrintSupport
    OpenGL
    Svg
    Sql
    LinguistTools
)

if(XMACHOVIEWER_QT_MAJOR EQUAL 5)
    list(APPEND XMACHOVIEWER_QT_COMPONENTS Script ScriptTools)
    find_package(Qt5 REQUIRED COMPONENTS ${XMACHOVIEWER_QT_COMPONENTS})
elseif(XMACHOVIEWER_QT_MAJOR GREATER_EQUAL 6)
    list(APPEND XMACHOVIEWER_QT_COMPONENTS Qml)
    find_package(Qt${XMACHOVIEWER_QT_MAJOR} REQUIRED COMPONENTS ${XMACHOVIEWER_QT_COMPONENTS})

    if(NOT TARGET Qt5::Widgets)
        add_library(Qt5::Widgets INTERFACE IMPORTED)
        set_property(TARGET Qt5::Widgets PROPERTY
            INTERFACE_LINK_LIBRARIES Qt${XMACHOVIEWER_QT_MAJOR}::Widgets
        )
    endif()
endif()

file(STRINGS "${CMAKE_CURRENT_LIST_DIR}/../release_version.txt" X_PROJECT_VERSION)
project(XMachOViewer VERSION ${X_PROJECT_VERSION} LANGUAGES CXX)
option(USE_DIE "Enable Detect It Easy integration" ON)

# The root intentionally delegates project() to this directory. Set the CPack
# components explicitly so they cannot inherit CMake's implicit 0.1.1 project.
set(CPACK_PACKAGE_VERSION_MAJOR "${PROJECT_VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${PROJECT_VERSION_MINOR}")
set(CPACK_PACKAGE_VERSION_PATCH "${PROJECT_VERSION_PATCH}")

set(X_COMPANYNAME "ntinfo")
set(X_PROJECTNAME "XMachOViewer")
set(X_MAINTAINER "horsicq@gmail.com")
set(X_DESCRIPTION "XMachOViewer is a Mach-O viewer")
set(X_HOMEPAGE "https://horsicq.github.io/")
set(X_ORIGINAL_FILENAME "xmachoviewer")

set(XMACHOVIEWER_DEP_ROOT "" CACHE PATH
    "Dependency root (a recursive checkout's dep directory or a shared _mylibs tree)"
)
if(NOT XMACHOVIEWER_DEP_ROOT)
    if(EXISTS "${CMAKE_CURRENT_LIST_DIR}/../dep/build_tools/cmake")
        set(XMACHOVIEWER_DEP_ROOT "${CMAKE_CURRENT_LIST_DIR}/../dep")
    elseif(EXISTS "${CMAKE_CURRENT_LIST_DIR}/../dep/build_tools/cmake")
        set(XMACHOVIEWER_DEP_ROOT "${CMAKE_CURRENT_LIST_DIR}/../dep")
    else()
        message(FATAL_ERROR
            "XMachOViewer dependencies were not found. Clone the repository with "
            "--recursive, provide dep, or set XMACHOVIEWER_DEP_ROOT."
        )
    endif()
endif()
get_filename_component(XMACHOVIEWER_DEP_ROOT
    "${XMACHOVIEWER_DEP_ROOT}" ABSOLUTE
)
message(STATUS "XMachOViewer dependency root: ${XMACHOVIEWER_DEP_ROOT}")

option(XMACHOVIEWER_PORTABLE_LAYOUT
    "Install a relocatable application tree instead of a system layout"
    OFF
)

if(NOT DEFINED MACOSX_BUNDLE_GUI_IDENTIFIER OR "${MACOSX_BUNDLE_GUI_IDENTIFIER}" STREQUAL "")
    set(MACOSX_BUNDLE_GUI_IDENTIFIER "com.ntinfo.xmachoviewer")
endif()
set(BUNDLE_ID_OPTION "${MACOSX_BUNDLE_GUI_IDENTIFIER}")

# The data root comes from the shared rule, which mirrors the hardcoded search
# order in XOptions::convertPathName(). This block used to compute it by hand and
# got the Linux case wrong: CMAKE_INSTALL_LIBDIR is the multiarch
# lib/x86_64-linux-gnu on Debian/Ubuntu, which is not searched. Because it also
# pre-empted cpp_standart_setup.cmake's `if(NOT DEFINED X_RESOURCES)`, every
# _mylibs helper that installs to ${X_RESOURCES} inherited the wrong root too.
include(${CMAKE_CURRENT_LIST_DIR}/../dep/build_tools/cmake/x_data_destination.cmake)

if(XMACHOVIEWER_PORTABLE_LAYOUT)
    # Portable build: everything next to the executable, on every platform.
    set(X_RESOURCES ".")
else()
    x_data_install_destination(X_RESOURCES)
endif()

if(UNIX AND NOT APPLE)
    include(GNUInstallDirs)
    set(CPACK_DEBIAN_PACKAGE_SHLIBDEPS ON)
    if(XMACHOVIEWER_QT_MAJOR EQUAL 5)
        list(APPEND X_DEBIAN_PACKAGE_DEPENDS "libqt5sql5-sqlite")
    else()
        list(APPEND X_DEBIAN_PACKAGE_DEPENDS "libqt6sql6-sqlite")
    endif()
    set(X_DEBIAN_COPYRIGHT_FILE "${CMAKE_CURRENT_LIST_DIR}/../LICENSE")
endif()

set(X_RESOURCE_DIR "${CMAKE_CURRENT_LIST_DIR}/../res")
set(X_WINDOWS_ICON "${X_RESOURCE_DIR}/windows/main.ico")
set(X_WINDOWS_RESOURCE_RC_IN "${X_RESOURCE_DIR}/windows/resource.rc.in")
set(X_WINDOWS_RESOURCE_ICON_RC_IN "${X_RESOURCE_DIR}/windows/resource_icon.rc.in")
set(X_WINDOWS_RESOURCE_RC "${X_RESOURCE_DIR}/windows/resource.rc")
set(X_WINDOWS_RESOURCE_ICON_RC "${X_RESOURCE_DIR}/windows/resource_icon.rc")
set(X_MACOS_ICON "${X_RESOURCE_DIR}/macos/main.icns")
set(X_MACOS_INFO_PLIST_IN "${X_RESOURCE_DIR}/macos/Info.plist.in")
set(X_MACOS_INFO_PLIST "${X_RESOURCE_DIR}/macos/Info.plist")

set(XMACHOVIEWER_DEPLOY_INIT "${XMACHOVIEWER_DEP_ROOT}/build_tools/cmake/deploy_init.cmake")
if(EXISTS "${XMACHOVIEWER_DEPLOY_INIT}"
   AND EXISTS "${X_WINDOWS_RESOURCE_RC_IN}"
   AND EXISTS "${X_WINDOWS_RESOURCE_ICON_RC_IN}"
   AND EXISTS "${X_MACOS_ICON}"
   AND EXISTS "${X_MACOS_INFO_PLIST_IN}")
    include("${XMACHOVIEWER_DEPLOY_INIT}")
else()
    message(STATUS "Skipping deploy_init.cmake because packaging resource templates are missing")
endif()

set(XMACHOVIEWER_TRANSLATION_HELPER "${XMACHOVIEWER_DEP_ROOT}/build_tools/cmake/deploy_translation.cmake")
if(EXISTS "${XMACHOVIEWER_TRANSLATION_HELPER}")
    include("${XMACHOVIEWER_TRANSLATION_HELPER}")

    set(XMACHOVIEWER_TS_FILES
        "${CMAKE_CURRENT_LIST_DIR}/../translations/xmachoviewer_ar.ts"
        "${CMAKE_CURRENT_LIST_DIR}/../translations/xmachoviewer_bn.ts"
        "${CMAKE_CURRENT_LIST_DIR}/../translations/xmachoviewer_de.ts"
        "${CMAKE_CURRENT_LIST_DIR}/../translations/xmachoviewer_es.ts"
        "${CMAKE_CURRENT_LIST_DIR}/../translations/xmachoviewer_fa.ts"
        "${CMAKE_CURRENT_LIST_DIR}/../translations/xmachoviewer_fr.ts"
        "${CMAKE_CURRENT_LIST_DIR}/../translations/xmachoviewer_he.ts"
        "${CMAKE_CURRENT_LIST_DIR}/../translations/xmachoviewer_id.ts"
        "${CMAKE_CURRENT_LIST_DIR}/../translations/xmachoviewer_it.ts"
        "${CMAKE_CURRENT_LIST_DIR}/../translations/xmachoviewer_ja.ts"
        "${CMAKE_CURRENT_LIST_DIR}/../translations/xmachoviewer_ko.ts"
        "${CMAKE_CURRENT_LIST_DIR}/../translations/xmachoviewer_pl.ts"
        "${CMAKE_CURRENT_LIST_DIR}/../translations/xmachoviewer_pt_BR.ts"
        "${CMAKE_CURRENT_LIST_DIR}/../translations/xmachoviewer_pt_PT.ts"
        "${CMAKE_CURRENT_LIST_DIR}/../translations/xmachoviewer_ru.ts"
        "${CMAKE_CURRENT_LIST_DIR}/../translations/xmachoviewer_sq.ts"
        "${CMAKE_CURRENT_LIST_DIR}/../translations/xmachoviewer_sv.ts"
        "${CMAKE_CURRENT_LIST_DIR}/../translations/xmachoviewer_tr.ts"
        "${CMAKE_CURRENT_LIST_DIR}/../translations/xmachoviewer_uk.ts"
        "${CMAKE_CURRENT_LIST_DIR}/../translations/xmachoviewer_vi.ts"
        "${CMAKE_CURRENT_LIST_DIR}/../translations/xmachoviewer_zh.ts"
        "${CMAKE_CURRENT_LIST_DIR}/../translations/xmachoviewer_zh_TW.ts"
    )

    # The plain leaf, like every other project: the resolver prepends X_RESOURCES.
    deploy_add_translations(
        TARGET_NAME xmachoviewer_translations
        ADD_TO_ALL
        SOURCE_DIRS "${CMAKE_CURRENT_LIST_DIR}"
        TS_FILES ${XMACHOVIEWER_TS_FILES}
        INSTALL_DESTINATION lang
    )
endif()

# Add compiled C/C++ dependencies before gui/ enables AUTOMOC and the MSVC
# Qt 5.15 compatibility include for C++ sources.
add_subdirectory("${XMACHOVIEWER_DEP_ROOT}/XCppfilt" XCppfilt)
add_subdirectory("${XMACHOVIEWER_DEP_ROOT}/XCapstone" XCapstone)
add_subdirectory("${XMACHOVIEWER_DEP_ROOT}/XArchive" XArchive)
add_subdirectory("${XMACHOVIEWER_DEP_ROOT}/XYara" XYara)
add_subdirectory(gui)
