cmake_minimum_required(VERSION 3.16)

project(XMachOViewer VERSION ${X_PROJECT_VERSION} LANGUAGES CXX)

include(../../dep/build_tools/cmake/cpp_standart_setup.cmake)

add_definitions(-DUSE_DEX)
add_definitions(-DUSE_PDF)
add_definitions(-DUSE_ARCHIVE)
add_definitions(-DUSE_YARA)

if(WIN32)
    add_definitions(-DNOMINMAX)
endif()

if(CMAKE_BUILD_TYPE STREQUAL "Release" OR CMAKE_BUILD_TYPE STREQUAL "MinSizeRel")
include(../../dep/build_tools/cmake/init_translation.cmake)
endif()

include(${CMAKE_CURRENT_LIST_DIR}/../../dep/archive_widget/archive_widget.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../../dep/XAboutWidget/xaboutwidget.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../../dep/XStyles/xstyles.cmake)


set(PROJECT_SOURCES
        ${ARCHIVE_WIDGET_SOURCES}
        ${XABOUTWIDGET_SOURCES}
        dialogabout.cpp
        dialogabout.h
        dialogabout.ui
        dialogoptions.cpp
        dialogoptions.h
        dialogoptions.ui
        main_gui.cpp
        guimainwindow.cpp
        guimainwindow.h
        guimainwindow.ui
        rsrc.qrc
)

if(CMAKE_BUILD_TYPE STREQUAL "Release" OR CMAKE_BUILD_TYPE STREQUAL "MinSizeRel")
include(../../dep/build_tools/cmake/create_translation.cmake)
endif()

if(WIN32)
    add_executable(XMachOViewer
        WIN32
        ${PROJECT_SOURCES}
        ${QM_FILES}
        ../../res/resource_icon.rc
    )
elseif(APPLE)
    add_executable(XMachOViewer
        MACOSX_BUNDLE
        ${PROJECT_SOURCES}
        ${QM_FILES}
    )

    set_source_files_properties(${CMAKE_CURRENT_SOURCE_DIR}/../../res/main.icns PROPERTIES
        MACOSX_PACKAGE_LOCATION "Resources")
    target_sources(${PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../../res/main.icns)

else()
    add_executable(XMachOViewer
        ${PROJECT_SOURCES}
        ${QM_FILES}
    )
endif()

if(CMAKE_BUILD_TYPE STREQUAL "Release" OR CMAKE_BUILD_TYPE STREQUAL "MinSizeRel")
    if(APPLE)
        include(../../dep/build_tools/cmake/macdeployqt.cmake)
    endif()
endif()

target_link_libraries(XMachOViewer PRIVATE bzip2)
target_link_libraries(XMachOViewer PRIVATE lzma)
target_link_libraries(XMachOViewer PRIVATE zlib)
target_link_libraries(XMachOViewer PRIVATE capstone)
target_link_libraries(XMachOViewer PRIVATE cppfilt)
target_link_libraries(XMachOViewer PRIVATE yara)

target_link_libraries(XMachOViewer PRIVATE Qt${QT_VERSION_MAJOR}::Widgets)
target_link_libraries(XMachOViewer PRIVATE Qt${QT_VERSION_MAJOR}::Concurrent)
target_link_libraries(XMachOViewer PRIVATE Qt${QT_VERSION_MAJOR}::Network)
target_link_libraries(XMachOViewer PRIVATE Qt${QT_VERSION_MAJOR}::PrintSupport)
target_link_libraries(XMachOViewer PRIVATE Qt${QT_VERSION_MAJOR}::OpenGL)
target_link_libraries(XMachOViewer PRIVATE Qt${QT_VERSION_MAJOR}::Svg)
target_link_libraries(XMachOViewer PRIVATE Qt${QT_VERSION_MAJOR}::Sql)

if(${QT_VERSION_MAJOR} EQUAL 5)
    target_link_libraries(XMachOViewer PRIVATE Qt${QT_VERSION_MAJOR}::Script)
    target_link_libraries(XMachOViewer PRIVATE Qt${QT_VERSION_MAJOR}::ScriptTools)
endif()

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    target_link_libraries(XMachOViewer PRIVATE Qt${QT_VERSION_MAJOR}::Qml)
endif()

if(WIN32)
    target_link_libraries(XMachOViewer PRIVATE Wintrust)
    target_link_libraries(XMachOViewer PRIVATE Crypt32)
endif()

find_package(Threads REQUIRED)
target_link_libraries(XMachOViewer PRIVATE Threads::Threads)

if(WIN32)
    install (TARGETS XMachOViewer DESTINATION "./")
    include(../../dep/build_tools/cmake/deploy_qt_windows.cmake)
    include(../../dep/build_tools/cmake/deploy_msvc.cmake)
    include(../../dep/build_tools/cmake/deploy_openssl.cmake)
elseif(APPLE)
    install(TARGETS XMachOViewer
        BUNDLE DESTINATION .
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    )
else()
    install (TARGETS XMachOViewer DESTINATION ${CMAKE_INSTALL_BINDIR})
endif()
