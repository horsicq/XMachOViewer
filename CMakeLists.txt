cmake_minimum_required(VERSION 3.10)

project(XMachOViewer)

if(WIN32)
    set (CMAKE_PREFIX_PATH "C:/Qt/5.15.2/msvc2019/")
endif()

if(APPLE)
    set (CMAKE_PREFIX_PATH $ENV{HOME}/Qt/5.15.2/clang_64/)
    set (CMAKE_OSX_ARCHITECTURES x86_64)
    add_compile_options(-Wno-deprecated-declarations)
    add_compile_options(-Wno-switch)
endif()

add_subdirectory(XCppfilt)
add_subdirectory(XCapstone)
add_subdirectory(XArchive)
add_subdirectory(XYara)
add_subdirectory(gui_source)

include(GNUInstallDirs)

install (TARGETS xmachoviewer)
install (FILES LINUX/xmachoviewer.desktop DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/applications/)
install (DIRECTORY LINUX/hicolor DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/icons)
install (DIRECTORY XStyles/qss DESTINATION ${CMAKE_INSTALL_LIBDIR}/xmachoviewer)
install (FILES signatures/crypto.db DESTINATION ${CMAKE_INSTALL_LIBDIR}/xmachoviewer/signatures)
install (DIRECTORY images DESTINATION ${CMAKE_INSTALL_LIBDIR}/xmachoviewer)