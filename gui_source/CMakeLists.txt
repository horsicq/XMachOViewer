cmake_minimum_required(VERSION 3.5)

project(XMachOViewer VERSION 0.02 LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

file(MAKE_DIRECTORY ../release)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ../release)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ../release)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ../release)

find_package(QT NAMES Qt5 COMPONENTS Widgets REQUIRED)
find_package(Qt5 COMPONENTS Widgets REQUIRED)
find_package(Qt5 COMPONENTS Concurrent REQUIRED)
find_package(Qt5 COMPONENTS OpenGL REQUIRED)
find_package(Qt5 COMPONENTS PrintSupport REQUIRED)
find_package(Qt5 COMPONENTS Svg REQUIRED)

add_definitions(-DUSE_DEX)
add_definitions(-DUSE_ARCHIVE)

include(${PROJECT_SOURCE_DIR}/../XOptions/xoptions.cmake)
include(${PROJECT_SOURCE_DIR}/../Formats/xformats.cmake)
include(${PROJECT_SOURCE_DIR}/../XQwt/xqwt.cmake)
include(${PROJECT_SOURCE_DIR}/../archive_widget/archive_widget.cmake)
include(${PROJECT_SOURCE_DIR}/../XShortcuts/xshortcuts.cmake)
include(${PROJECT_SOURCE_DIR}/../SpecAbstract/specabstract.cmake)
include(${PROJECT_SOURCE_DIR}/../XMemoryMapWidget/xmemorymapwidget.cmake)
include(${PROJECT_SOURCE_DIR}/../XHashWidget/xhashwidget.cmake)
include(${PROJECT_SOURCE_DIR}/../XEntropyWidget/xentropywidget.cmake)
include(${PROJECT_SOURCE_DIR}/../FormatWidgets/allformatwidgets.cmake)
include(${PROJECT_SOURCE_DIR}/../XArchive/xarchives.cmake)
include(${PROJECT_SOURCE_DIR}/../XHexView/xhexview.cmake)
include(${PROJECT_SOURCE_DIR}/../XDisasmView/xdisasmview.cmake)
include(${PROJECT_SOURCE_DIR}/../XDemangleWidget/xdemanglewidget.cmake)
include(${PROJECT_SOURCE_DIR}/../XDemangle/xdemangle.cmake)
include(${PROJECT_SOURCE_DIR}/../StaticScan/heurwidget.cmake)

include_directories(${PROJECT_SOURCE_DIR}/../Controls/)
include_directories(${PROJECT_SOURCE_DIR}/../FormatDialogs/)
include_directories(${PROJECT_SOURCE_DIR}/../XCapstone/)
include_directories(${PROJECT_SOURCE_DIR}/../XCapstone/3rdparty/Capstone/src/include/)
include_directories(${PROJECT_SOURCE_DIR}/../XCppfilt/)
include_directories(${PROJECT_SOURCE_DIR}/../XCppfilt/3rdparty/cppfilt/src/)
include_directories(${PROJECT_SOURCE_DIR}/../XDEX/)
include_directories(${PROJECT_SOURCE_DIR}/../XLLVMDemangler/3rdparty/)
include_directories(${PROJECT_SOURCE_DIR}/../XLLVMDemangler/3rdparty/llvm/Demangle/)

set(PROJECT_SOURCES
            ${XOPTIONS_SOURCES}
            ${XFORMATS_SOURCES}
            ${XQWT_SOURCES}
            ${ARCHIVE_WIDGET_SOURCES}
            ${XSHORTCUTS_SOURCES}
            ${SPECABSTRACT_SOURCES}
            ${XMEMORYMAPWIDGET_SOURCES}
            ${XHASHWIDGET_SOURCES}
            ${XENTROPYWIDGET_SOURCES}
            ${ALLFORMATWIDGETS_SOURCES}
            ${XARCHIVES_SOURCES}
            ${XHEXVIEW_SOURCES}
            ${XDISASMVIEW_SOURCES}
            ${XDEMANGLEWIDGET_SOURCES}
            ${XDEMANGLE_SOURCES}
            ${HEURWIDGET_SOURCES}
            ../Controls/hexvalidator.cpp
            ../Controls/subclassofqstyleditemdelegate.cpp
            ../Controls/xabstracttableview.cpp
            ../Controls/xcomboboxex.cpp
            ../Controls/xdatetimeeditx.cpp
            ../Controls/xdevicetableview.cpp
            ../Controls/xlineedithex.cpp
            ../FormatDialogs/dialogdump.ui
            ../FormatDialogs/dialogdumpprocess.cpp
            ../FormatDialogs/dialogdumpprocess.ui
            ../FormatDialogs/dialoggotoaddress.cpp
            ../FormatDialogs/dialoggotoaddress.ui
            ../FormatDialogs/dialoghexsignature.cpp
            ../FormatDialogs/dialoghexsignature.ui
            ../FormatDialogs/dialoginfo.cpp
            ../FormatDialogs/dialoginfo.ui
            ../FormatDialogs/dialogsearch.cpp
            ../FormatDialogs/dialogsearch.ui
            ../FormatDialogs/dialogsearchprocess.cpp
            ../FormatDialogs/dialogsearchprocess.ui
            ../FormatDialogs/dialogtextinfo.cpp
            ../FormatDialogs/dialogtextinfo.ui
            ../FormatDialogs/dumpprocess.cpp
            ../FormatDialogs/searchprocess.cpp
            ../XCapstone/xcapstone.cpp
            ../XCppfilt/xcppfilt.cpp
            ../XDEX/xandroidbinary.cpp
            ../XDEX/xdex.cpp
            dialogabout.cpp
            dialogabout.ui
            dialogoptions.cpp
            dialogoptions.ui
            guimainwindow.cpp
            guimainwindow.ui
            main_gui.cpp
            rsrc.qrc
)

if(APPLE)
    add_library(${PROJECT_NAME} MODULE ${PROJECT_SOURCES})
    set_target_properties(${PROJECT_NAME} PROPERTIES
            MACOSX_BUNDLE_GUI_IDENTIFIER ntinfo.xmachoviewer
            MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
            MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
            BUNDLE TRUE)
    set(MACOSX_BUNDLE_ICON_FILE ../icons/main.icns)
else()
    if(WIN32)
        add_executable(${PROJECT_NAME} WIN32
            ${PROJECT_SOURCES}
        )
    else()
        add_executable(${PROJECT_NAME}
                ${PROJECT_SOURCES}
            )
    endif()
endif()

target_link_libraries(${PROJECT_NAME} bzip2)
target_link_libraries(${PROJECT_NAME} lzma)
target_link_libraries(${PROJECT_NAME} zlib)
target_link_libraries(${PROJECT_NAME} capstone)
target_link_libraries(${PROJECT_NAME} cppfilt)

target_link_libraries(${PROJECT_NAME} Qt5::Widgets)
target_link_libraries(${PROJECT_NAME} Qt5::Concurrent)
target_link_libraries(${PROJECT_NAME} Qt5::OpenGL)
target_link_libraries(${PROJECT_NAME} Qt5::PrintSupport)
target_link_libraries(${PROJECT_NAME} Qt5::Svg)

if(WIN32)
    target_link_libraries(${PROJECT_NAME} Wintrust)
    target_link_libraries(${PROJECT_NAME} Crypt32)
endif()
