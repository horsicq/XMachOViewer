cmake_minimum_required(VERSION 3.5)

include(../../../_mylibs/build_tools/cmake/deploy.cmake)
include(GNUInstallDirs)

project(xmachoviewer VERSION ${X_PROJECT_VERSION} LANGUAGES CXX)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(WIN32)
    set(CMAKE_EXE_LINKER_FLAGS    "${CMAKE_EXE_LINKER_FLAGS} /MANIFEST:NO")
    set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} /MANIFEST:NO")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} /MANIFEST:NO")
endif()

add_definitions(-DUSE_DEX)
add_definitions(-DUSE_PDF)
add_definitions(-DUSE_ARCHIVE)
add_definitions(-DUSE_YARA)

include(${CMAKE_CURRENT_LIST_DIR}/../../../_mylibs/archive_widget/archive_widget.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../../../_mylibs/XAboutWidget/xaboutwidget.cmake)

set(TS_FILES
    ../../res/translation/xmachoviewer_de.ts
)

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

#qt_create_translation(QM_FILES ${PROJECT_SOURCES} ${TS_FILES})
#qt_add_translation(QM_FILES ${TS_FILES})

if(WIN32)
    add_executable(xmachoviewer WIN32
        ${PROJECT_SOURCES}
        ../../res/resource.rc
    )
else()
    add_executable(xmachoviewer
        ${PROJECT_SOURCES}
    )
endif()

set_target_properties(xmachoviewer PROPERTIES
    ${BUNDLE_ID_OPTION}
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(xmachoviewer PRIVATE bzip2)
target_link_libraries(xmachoviewer PRIVATE lzma)
target_link_libraries(xmachoviewer PRIVATE zlib)
target_link_libraries(xmachoviewer PRIVATE capstone)
target_link_libraries(xmachoviewer PRIVATE cppfilt)
target_link_libraries(xmachoviewer PRIVATE yara)

target_link_libraries(xmachoviewer PRIVATE Qt${QT_VERSION_MAJOR}::Widgets)
target_link_libraries(xmachoviewer PRIVATE Qt${QT_VERSION_MAJOR}::Concurrent)
target_link_libraries(xmachoviewer PRIVATE Qt${QT_VERSION_MAJOR}::Network)
target_link_libraries(xmachoviewer PRIVATE Qt${QT_VERSION_MAJOR}::PrintSupport)
target_link_libraries(xmachoviewer PRIVATE Qt${QT_VERSION_MAJOR}::OpenGL)
target_link_libraries(xmachoviewer PRIVATE Qt${QT_VERSION_MAJOR}::Svg)
target_link_libraries(xmachoviewer PRIVATE Qt${QT_VERSION_MAJOR}::Sql)

if(${QT_VERSION_MAJOR} EQUAL 5)
    target_link_libraries(xmachoviewer PRIVATE Qt${QT_VERSION_MAJOR}::Script)
    target_link_libraries(xmachoviewer PRIVATE Qt${QT_VERSION_MAJOR}::ScriptTools)
endif()

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    target_link_libraries(xmachoviewer PRIVATE Qt${QT_VERSION_MAJOR}::Qml)
endif()

if(WIN32)
    target_link_libraries(xmachoviewer PRIVATE Wintrust)
    target_link_libraries(xmachoviewer PRIVATE Crypt32)
endif()

if(WIN32)
    install (TARGETS xmachoviewer DESTINATION "./")
    install (DIRECTORY ../../../_mylibs/Detect-It-Easy/db DESTINATION "./" OPTIONAL)
    install (DIRECTORY ../../../_mylibs/Detect-It-Easy/db_extra DESTINATION "./" OPTIONAL)
    install (DIRECTORY ../../../_mylibs/Detect-It-Easy/db_custom DESTINATION "./" OPTIONAL)
    install (DIRECTORY ../../../_mylibs/XInfoDB/info DESTINATION "./" OPTIONAL)
    install (DIRECTORY ../../../_mylibs/XStyles/qss DESTINATION "./" OPTIONAL)
    install (DIRECTORY ../../../_mylibs/XYara/yara_rules DESTINATION "./" OPTIONAL)
    install (FILES ../../../_mylibs/signatures/crypto.db DESTINATION "./signatures" OPTIONAL)
    deploy_qt()
    deploy_msvc()
elseif(APPLE)
    install(TARGETS xmachoviewer
        BUNDLE DESTINATION .
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    )
else()
    install (TARGETS xmachoviewer DESTINATION ${CMAKE_INSTALL_BINDIR})
    install (DIRECTORY ../../../_mylibs/Detect-It-Easy/db DESTINATION ${CMAKE_INSTALL_LIBDIR}/xmachoviewer OPTIONAL)
    install (DIRECTORY ../../../_mylibs/Detect-It-Easy/db_extra DESTINATION ${CMAKE_INSTALL_LIBDIR}/xmachoviewer OPTIONAL)
    install (DIRECTORY ../../../_mylibs/Detect-It-Easy/db_custom DESTINATION ${CMAKE_INSTALL_LIBDIR}/xmachoviewer OPTIONAL)
    install (DIRECTORY ../../../_mylibs/XInfoDB/info DESTINATION ${CMAKE_INSTALL_LIBDIR}/xmachoviewer OPTIONAL)
    install (DIRECTORY ../../../_mylibs/XStyles/qss DESTINATION ${CMAKE_INSTALL_LIBDIR}/xmachoviewer OPTIONAL)
    install (DIRECTORY ../../../_mylibs/XYara/yara_rules DESTINATION ${CMAKE_INSTALL_LIBDIR}/xmachoviewer OPTIONAL)
    install (FILES ../../../_mylibs/signatures/crypto.db DESTINATION ${CMAKE_INSTALL_LIBDIR}/xmachoviewer/signatures OPTIONAL)
endif()

# if(${QT_VERSION_MAJOR} EQUAL 6)
#     qt_finalize_executable(xmachoviewer)
# endif()
