include("${XMACHOVIEWER_DEP_ROOT}/build_tools/cmake/cpp_standart_setup.cmake")

add_definitions(-DUSE_ARCHIVE)
add_definitions(-DUSE_YARA)

include("${XMACHOVIEWER_DEP_ROOT}/archive_widget/archive_widget.cmake")
include("${XMACHOVIEWER_DEP_ROOT}/XAboutWidget/xaboutwidget.cmake")
include("${XMACHOVIEWER_DEP_ROOT}/XStyles/xstyles.cmake")

find_package(Threads REQUIRED)

set(XMACHOVIEWER_GUI_TARGET XMachOViewer)
set(XMACHOVIEWER_GUI_SOURCES
    ${ARCHIVE_WIDGET_SOURCES}
    ${XABOUTWIDGET_SOURCES}
    ${XSTYLES_SOURCES}
    dialogabout.cpp
    dialogabout.h
    dialogabout.ui
    dialogoptions.cpp
    dialogoptions.h
    dialogoptions.ui
    guimainwindow.cpp
    guimainwindow.h
    guimainwindow.ui
    main_gui.cpp
    "${CMAKE_CURRENT_LIST_DIR}/../../res/resources_gui.qrc"
)

if(WIN32 AND EXISTS "${X_WINDOWS_RESOURCE_ICON_RC}")
    list(APPEND XMACHOVIEWER_GUI_SOURCES "${X_WINDOWS_RESOURCE_ICON_RC}")
endif()

if(APPLE AND EXISTS "${X_MACOS_ICON}")
    set_source_files_properties("${X_MACOS_ICON}" PROPERTIES
        MACOSX_PACKAGE_LOCATION "Resources"
    )
    list(APPEND XMACHOVIEWER_GUI_SOURCES "${X_MACOS_ICON}")
endif()

add_executable(${XMACHOVIEWER_GUI_TARGET} WIN32
    ${XMACHOVIEWER_GUI_SOURCES}
)

set_target_properties(${XMACHOVIEWER_GUI_TARGET} PROPERTIES
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE TRUE
    MACOSX_BUNDLE_GUI_IDENTIFIER "${MACOSX_BUNDLE_GUI_IDENTIFIER}"
    OUTPUT_NAME "${X_ORIGINAL_FILENAME}"
)

if(APPLE AND EXISTS "${X_MACOS_INFO_PLIST}")
    set_target_properties(${XMACHOVIEWER_GUI_TARGET} PROPERTIES
        MACOSX_BUNDLE_INFO_PLIST "${X_MACOS_INFO_PLIST}"
    )
endif()

target_include_directories(${XMACHOVIEWER_GUI_TARGET} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})

target_link_libraries(${XMACHOVIEWER_GUI_TARGET} PRIVATE
    bzip2
    lzma
    zlib
    ppmd
    capstone
    cppfilt
    yara
    Qt${XMACHOVIEWER_QT_MAJOR}::Widgets
    Qt${XMACHOVIEWER_QT_MAJOR}::Concurrent
    Qt${XMACHOVIEWER_QT_MAJOR}::Network
    Qt${XMACHOVIEWER_QT_MAJOR}::PrintSupport
    Qt${XMACHOVIEWER_QT_MAJOR}::OpenGL
    Qt${XMACHOVIEWER_QT_MAJOR}::Svg
    Qt${XMACHOVIEWER_QT_MAJOR}::Sql
    Threads::Threads
)

if(XMACHOVIEWER_QT_MAJOR EQUAL 5)
    target_link_libraries(${XMACHOVIEWER_GUI_TARGET} PRIVATE
        Qt5::Script
        Qt5::ScriptTools
    )
elseif(XMACHOVIEWER_QT_MAJOR GREATER_EQUAL 6)
    target_link_libraries(${XMACHOVIEWER_GUI_TARGET} PRIVATE
        Qt${XMACHOVIEWER_QT_MAJOR}::Qml
    )
endif()

if(WIN32)
    target_link_libraries(${XMACHOVIEWER_GUI_TARGET} PRIVATE Wintrust Crypt32)
endif()

if(TARGET xmachoviewer_translations)
    add_dependencies(${XMACHOVIEWER_GUI_TARGET} xmachoviewer_translations)
endif()

if(UNIX AND NOT APPLE AND NOT XMACHOVIEWER_PORTABLE_LAYOUT)
    set(XMACHOVIEWER_RUNTIME_DESTINATION "${CMAKE_INSTALL_BINDIR}")
    set(XMACHOVIEWER_DOC_DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/doc/xmachoviewer")
    set(XMACHOVIEWER_DESKTOP_TEMPLATE "${CMAKE_CURRENT_SOURCE_DIR}/../../res/linux/xmachoviewer.desktop.in")
    set(XMACHOVIEWER_DESKTOP_FILE "${CMAKE_CURRENT_BINARY_DIR}/xmachoviewer.desktop")

    if(EXISTS "${XMACHOVIEWER_DESKTOP_TEMPLATE}")
        configure_file("${XMACHOVIEWER_DESKTOP_TEMPLATE}" "${XMACHOVIEWER_DESKTOP_FILE}" @ONLY)
    endif()
else()
    set(XMACHOVIEWER_RUNTIME_DESTINATION ".")
    set(XMACHOVIEWER_DOC_DESTINATION ".")
endif()

install(TARGETS ${XMACHOVIEWER_GUI_TARGET}
    RUNTIME DESTINATION ${XMACHOVIEWER_RUNTIME_DESTINATION}
    BUNDLE DESTINATION .
)

if(UNIX AND NOT APPLE AND NOT XMACHOVIEWER_PORTABLE_LAYOUT)
    install(FILES
        "${CMAKE_CURRENT_SOURCE_DIR}/../../LICENSE"
        "${CMAKE_CURRENT_SOURCE_DIR}/../../README.md"
        DESTINATION ${XMACHOVIEWER_DOC_DESTINATION}
        OPTIONAL
    )

    if(EXISTS "${XMACHOVIEWER_DESKTOP_FILE}")
        install(FILES "${XMACHOVIEWER_DESKTOP_FILE}"
            DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/applications")
    endif()

    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/../../res/linux/hicolor")
        install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/../../res/linux/hicolor/"
            DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/icons/hicolor")
    endif()
elseif(APPLE)
    # productbuild installs the bundle at /Applications. Keep documentation
    # inside the bundle instead of dropping loose files into /Applications.
    install(FILES
        "${CMAKE_CURRENT_SOURCE_DIR}/../../LICENSE"
        DESTINATION "${X_RESOURCES}"
        RENAME LICENSE.txt
        OPTIONAL
    )

    install(FILES
        "${CMAKE_CURRENT_SOURCE_DIR}/../../README.md"
        DESTINATION "${X_RESOURCES}"
        OPTIONAL
    )
else()
    install(FILES
        "${CMAKE_CURRENT_SOURCE_DIR}/../../LICENSE"
        DESTINATION .
        RENAME LICENSE.txt
        OPTIONAL
    )

    install(FILES
        "${CMAKE_CURRENT_SOURCE_DIR}/../../README.md"
        "${CMAKE_CURRENT_SOURCE_DIR}/../../res/license.txt"
        "${CMAKE_CURRENT_SOURCE_DIR}/../../res/readme.txt"
        DESTINATION .
        OPTIONAL
    )

    if(WIN32)
        install(FILES "${X_WINDOWS_ICON}"
            DESTINATION .
            OPTIONAL
        )
    endif()

    install(CODE [[file(WRITE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/portable" "")]])
endif()

if(APPLE)
    include("${XMACHOVIEWER_DEP_ROOT}/build_tools/cmake/macdeployqt.cmake")
endif()

if(WIN32)
    include("${XMACHOVIEWER_DEP_ROOT}/build_tools/cmake/deploy_qt_windows.cmake")
    include("${XMACHOVIEWER_DEP_ROOT}/build_tools/cmake/deploy_msvc.cmake")

    # The shared deploy helper does not yet cover these two directly linked
    # modules. Without them, the portable archive builds but cannot start.
    set(_xmachoviewer_extra_qt_dlls)
    foreach(_xmachoviewer_qt_module Concurrent PrintSupport)
        set(_xmachoviewer_qt_target
            "Qt${XMACHOVIEWER_QT_MAJOR}::${_xmachoviewer_qt_module}")
        get_target_property(_xmachoviewer_qt_dll
            "${_xmachoviewer_qt_target}" IMPORTED_LOCATION_RELEASE)
        if(NOT _xmachoviewer_qt_dll
           OR _xmachoviewer_qt_dll MATCHES "-NOTFOUND$")
            get_target_property(_xmachoviewer_qt_dll
                "${_xmachoviewer_qt_target}" IMPORTED_LOCATION)
        endif()
        if(NOT _xmachoviewer_qt_dll
           OR _xmachoviewer_qt_dll MATCHES "-NOTFOUND$"
           OR NOT EXISTS "${_xmachoviewer_qt_dll}")
            message(FATAL_ERROR
                "Release DLL not found for ${_xmachoviewer_qt_target}")
        endif()
        list(APPEND _xmachoviewer_extra_qt_dlls
            "${_xmachoviewer_qt_dll}")
    endforeach()
    install(FILES ${_xmachoviewer_extra_qt_dlls} DESTINATION .)

    # Select OpenSSL by the target architecture. CMAKE_SYSTEM_PROCESSOR can
    # describe the 64-bit host even for a Visual Studio Win32 target.
    if(MSVC AND XMACHOVIEWER_QT_MAJOR EQUAL 5)
        set(_xmachoviewer_openssl_root
            "${XMACHOVIEWER_DEP_ROOT}/build_tools/openssl")

        if(MSVC_VERSION EQUAL 1800)
            install(FILES
                "${_xmachoviewer_openssl_root}/winxp_x86/libeay32.dll"
                "${_xmachoviewer_openssl_root}/winxp_x86/ssleay32.dll"
                DESTINATION .
                OPTIONAL
            )
        elseif(CMAKE_SIZEOF_VOID_P EQUAL 8)
            install(FILES
                "${_xmachoviewer_openssl_root}/win_x64/libcrypto-1_1-x64.dll"
                "${_xmachoviewer_openssl_root}/win_x64/libssl-1_1-x64.dll"
                DESTINATION .
                OPTIONAL
            )
        else()
            install(FILES
                "${_xmachoviewer_openssl_root}/win_x86/libcrypto-1_1.dll"
                "${_xmachoviewer_openssl_root}/win_x86/libssl-1_1.dll"
                DESTINATION .
                OPTIONAL
            )
        endif()
    endif()
endif()
