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

include_directories(${PROJECT_SOURCE_DIR}/../Controls/)
include_directories(${PROJECT_SOURCE_DIR}/../FormatDialogs/)
include_directories(${PROJECT_SOURCE_DIR}/../FormatWidgets/)
include_directories(${PROJECT_SOURCE_DIR}/../FormatWidgets/Binary/)
include_directories(${PROJECT_SOURCE_DIR}/../FormatWidgets/DEX/)
include_directories(${PROJECT_SOURCE_DIR}/../FormatWidgets/ELF/)
include_directories(${PROJECT_SOURCE_DIR}/../FormatWidgets/LE/)
include_directories(${PROJECT_SOURCE_DIR}/../FormatWidgets/MACH/)
include_directories(${PROJECT_SOURCE_DIR}/../FormatWidgets/MACHOFAT/)
include_directories(${PROJECT_SOURCE_DIR}/../FormatWidgets/MSDOS/)
include_directories(${PROJECT_SOURCE_DIR}/../FormatWidgets/MultiSearch/)
include_directories(${PROJECT_SOURCE_DIR}/../FormatWidgets/NE/)
include_directories(${PROJECT_SOURCE_DIR}/../FormatWidgets/PE/)
include_directories(${PROJECT_SOURCE_DIR}/../FormatWidgets/SearchSignatures/)
include_directories(${PROJECT_SOURCE_DIR}/../FormatWidgets/SearchStrings/)
include_directories(${PROJECT_SOURCE_DIR}/../StaticScan/)
include_directories(${PROJECT_SOURCE_DIR}/../XArchive/)
include_directories(${PROJECT_SOURCE_DIR}/../XArchive/3rdparty/bzip2/src/)
include_directories(${PROJECT_SOURCE_DIR}/../XArchive/3rdparty/lzma/src/)
include_directories(${PROJECT_SOURCE_DIR}/../XArchive/3rdparty/zlib/src/)
include_directories(${PROJECT_SOURCE_DIR}/../XCapstone/)
include_directories(${PROJECT_SOURCE_DIR}/../XCapstone/3rdparty/Capstone/src/include/)
include_directories(${PROJECT_SOURCE_DIR}/../XCppfilt/)
include_directories(${PROJECT_SOURCE_DIR}/../XCppfilt/3rdparty/cppfilt/src/)
include_directories(${PROJECT_SOURCE_DIR}/../XDEX/)
include_directories(${PROJECT_SOURCE_DIR}/../XDemangle/)
include_directories(${PROJECT_SOURCE_DIR}/../XDemangleWidget/)
include_directories(${PROJECT_SOURCE_DIR}/../XDisasmView/)
include_directories(${PROJECT_SOURCE_DIR}/../XEntropyWidget/)
include_directories(${PROJECT_SOURCE_DIR}/../XHashWidget/)
include_directories(${PROJECT_SOURCE_DIR}/../XHexView/)
include_directories(${PROJECT_SOURCE_DIR}/../XLLVMDemangler/3rdparty/)
include_directories(${PROJECT_SOURCE_DIR}/../XLLVMDemangler/3rdparty/llvm/Demangle/)
include_directories(${PROJECT_SOURCE_DIR}/../XMemoryMapWidget/)

set(PROJECT_SOURCES
            ${XOPTIONS_SOURCES}
            ${XFORMATS_SOURCES}
            ${XQWT_SOURCES}
            ${ARCHIVE_WIDGET_SOURCES}
            ${XSHORTCUTS_SOURCES}
            ${SPECABSTRACT_SOURCES}
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
            ../FormatWidgets/DEX/dexsectionheaderwidget.ui
            ../FormatWidgets/DEX/dexwidget.ui
            ../FormatWidgets/DEX/dialogdex.ui
            ../FormatWidgets/DEX/dexsectionheaderwidget.cpp
            ../FormatWidgets/DEX/dexwidget.cpp
            ../FormatWidgets/DEX/dex_defs.cpp
            ../FormatWidgets/DEX/dialogdex.cpp
            ../FormatWidgets/DEX/dexprocessdata.cpp
            ../FormatWidgets/ELF/elfsectionheaderwidget.ui
            ../FormatWidgets/ELF/elfwidget.ui
            ../FormatWidgets/ELF/dialogelf.ui
            ../FormatWidgets/ELF/elfsectionheaderwidget.cpp
            ../FormatWidgets/ELF/elfwidget.cpp
            ../FormatWidgets/ELF/elf_defs.cpp
            ../FormatWidgets/ELF/dialogelf.cpp
            ../FormatWidgets/ELF/elfprocessdata.cpp
            ../FormatWidgets/LE/lesectionheaderwidget.ui
            ../FormatWidgets/LE/lewidget.ui
            ../FormatWidgets/LE/dialogle.ui
            ../FormatWidgets/LE/leprocessdata.cpp
            ../FormatWidgets/LE/lesectionheaderwidget.cpp
            ../FormatWidgets/LE/lewidget.cpp
            ../FormatWidgets/LE/le_defs.cpp
            ../FormatWidgets/LE/dialogle.cpp
            ../FormatWidgets/MultiSearch/dialogmultisearchprocess.cpp
            ../FormatWidgets/MultiSearch/dialogmultisearchprocess.ui
            ../FormatWidgets/MultiSearch/multisearch.cpp
            ../FormatWidgets/MACH/dialogmach.cpp
            ../FormatWidgets/MACH/dialogmach.ui
            ../FormatWidgets/MACH/mach_defs.cpp
            ../FormatWidgets/MACH/machprocessdata.cpp
            ../FormatWidgets/MACH/machsectionheaderwidget.cpp
            ../FormatWidgets/MACH/machsectionheaderwidget.ui
            ../FormatWidgets/MACH/machwidget.cpp
            ../FormatWidgets/MACH/machwidget.ui
            ../FormatWidgets/MACHOFAT/machofatwidget.cpp
            ../FormatWidgets/MACHOFAT/machofatwidget.ui
            ../FormatWidgets/MSDOS/msdoswidget.ui
            ../FormatWidgets/MSDOS/dialogmsdos.ui
            ../FormatWidgets/MSDOS/msdoswidget.cpp
            ../FormatWidgets/MSDOS/msdos_defs.cpp
            ../FormatWidgets/MSDOS/dialogmsdos.cpp
            ../FormatWidgets/NE/nesectionheaderwidget.ui
            ../FormatWidgets/NE/newidget.ui
            ../FormatWidgets/NE/dialogne.ui
            ../FormatWidgets/NE/neprocessdata.cpp
            ../FormatWidgets/NE/nesectionheaderwidget.cpp
            ../FormatWidgets/NE/newidget.cpp
            ../FormatWidgets/NE/ne_defs.cpp
            ../FormatWidgets/NE/dialogne.cpp
            ../FormatWidgets/PE/pesectionheaderwidget.ui
            ../FormatWidgets/PE/pewidget.ui
            ../FormatWidgets/PE/dialogpe.ui
            ../FormatWidgets/PE/pesectionheaderwidget.cpp
            ../FormatWidgets/PE/pewidget.cpp
            ../FormatWidgets/PE/pe_defs.cpp
            ../FormatWidgets/PE/dialogpe.cpp
            ../FormatWidgets/PE/peprocessdata.cpp
            ../FormatWidgets/SearchSignatures/dialogsearchsignatures.cpp
            ../FormatWidgets/SearchSignatures/dialogsearchsignatures.ui
            ../FormatWidgets/SearchSignatures/searchsignatureswidget.cpp
            ../FormatWidgets/SearchSignatures/searchsignatureswidget.ui
            ../FormatWidgets/SearchStrings/dialogsearchstrings.cpp
            ../FormatWidgets/SearchStrings/dialogsearchstrings.ui
            ../FormatWidgets/SearchStrings/searchstringswidget.cpp
            ../FormatWidgets/SearchStrings/searchstringswidget.ui
            ../FormatWidgets/dialogmodelinfo.cpp
            ../FormatWidgets/dialogmodelinfo.ui
            ../FormatWidgets/dialogprocessdata.cpp
            ../FormatWidgets/dialogprocessdata.ui
            ../FormatWidgets/dialogsectionheader.cpp
            ../FormatWidgets/dialogsectionheader.ui
            ../FormatWidgets/formatwidget.cpp
            ../FormatWidgets/invwidget.cpp
            ../FormatWidgets/processdata.cpp
            ../FormatWidgets/toolswidget.cpp
            ../FormatWidgets/toolswidget.ui
            ../StaticScan/dialogstaticscan.cpp
            ../StaticScan/dialogstaticscan.ui
            ../StaticScan/dialogstaticscanprocess.cpp
            ../StaticScan/dialogstaticscanprocess.ui
            ../StaticScan/formresult.cpp
            ../StaticScan/formresult.ui
            ../StaticScan/heurwidget.cpp
            ../StaticScan/heurwidget.ui
            ../StaticScan/staticscan.cpp
            ../StaticScan/staticscanitem.cpp
            ../StaticScan/staticscanitemmodel.cpp
            ../XArchive/xarchive.cpp
            ../XArchive/xarchives.cpp
            ../XArchive/xcab.cpp
            ../XArchive/xmachofat.cpp
            ../XArchive/xrar.cpp
            ../XArchive/xsevenzip.cpp
            ../XArchive/xzip.cpp
            ../XCapstone/xcapstone.cpp
            ../XCppfilt/xcppfilt.cpp
            ../XDEX/xandroidbinary.cpp
            ../XDEX/xdex.cpp
            ../XDemangle/xdemangle.cpp
            ../XDemangleWidget/dialogdemangle.cpp
            ../XDemangleWidget/dialogdemangle.ui
            ../XDemangleWidget/xdemanglewidget.cpp
            ../XDemangleWidget/xdemanglewidget.ui
            ../XDisasmView/dialogmultidisasm.cpp
            ../XDisasmView/dialogmultidisasm.ui
            ../XDisasmView/dialogmultidisasmsignature.cpp
            ../XDisasmView/dialogmultidisasmsignature.ui
            ../XDisasmView/xdisasmview.cpp
            ../XDisasmView/xmultidisasmwidget.cpp
            ../XDisasmView/xmultidisasmwidget.ui
            ../XEntropyWidget/dialogentropy.cpp
            ../XEntropyWidget/dialogentropy.ui
            ../XEntropyWidget/dialogentropyprocess.cpp
            ../XEntropyWidget/dialogentropyprocess.ui
            ../XEntropyWidget/entropyprocess.cpp
            ../XEntropyWidget/xentropywidget.cpp
            ../XEntropyWidget/xentropywidget.ui
            ../XHashWidget/dialoghash.cpp
            ../XHashWidget/dialoghash.ui
            ../XHashWidget/dialoghashprocess.cpp
            ../XHashWidget/dialoghashprocess.ui
            ../XHashWidget/hashprocess.cpp
            ../XHashWidget/xhashwidget.cpp
            ../XHashWidget/xhashwidget.ui
            ../XHexView/dialoghexview.cpp
            ../XHexView/dialoghexview.ui
            ../XHexView/xhexview.cpp
            ../XHexView/xhexviewwidget.cpp
            ../XHexView/xhexviewwidget.ui
            ../XMemoryMapWidget/dialogmemorymap.cpp
            ../XMemoryMapWidget/dialogmemorymap.ui
            ../XMemoryMapWidget/xmemorymapwidget.cpp
            ../XMemoryMapWidget/xmemorymapwidget.ui
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
