#!/bin/sh -x
export QMAKE_PATH=$HOME/Qt/5.15.2/clang_64/bin/qmake

export X_SOURCE_PATH=$PWD
export X_BUILD_NAME=xmachoviewer_mac_portable
export X_RELEASE_VERSION=$(cat "release_version.txt")

source build_tools/mac.sh

check_file $QMAKE_PATH

if [ -z "$X_ERROR" ]; then
    make_init
    make_build "$X_SOURCE_PATH/xmachoviewer_source.pro"
    cd "$X_SOURCE_PATH/gui_source"
    make_translate "gui_source_tr.pro" xmachoviewer
    cd "$X_SOURCE_PATH"

    check_file "$X_SOURCE_PATH/build/release/XMachOViewer.app/Contents/MacOS/XMachOViewer"
    if [ -z "$X_ERROR" ]; then
        cp -R "$X_SOURCE_PATH/build/release/XMachOViewer.app" "$X_SOURCE_PATH/release/$X_BUILD_NAME"

        mkdir -p $X_SOURCE_PATH/release/$X_BUILD_NAME/XMachOViewer.app/Contents/Resources/signatures
        cp -R $X_SOURCE_PATH/signatures/crypto.db            $X_SOURCE_PATH/release/$X_BUILD_NAME/XMachOViewer.app/Contents/Resources/signatures
        cp -Rf $X_SOURCE_PATH/XStyles/qss                    $X_SOURCE_PATH/release/$X_BUILD_NAME/XMachOViewer.app/Contents/Resources/

        fiximport "$X_SOURCE_PATH/build/release/XMachOViewer.app/Contents/MacOS/XMachOViewer"

        deploy_qt_library QtWidgets XMachOViewer
        deploy_qt_library QtGui XMachOViewer
        deploy_qt_library QtCore XMachOViewer
        deploy_qt_library QtDBus XMachOViewer
        deploy_qt_library QtPrintSupport XMachOViewer
        deploy_qt_library QtSvg XMachOViewer
        deploy_qt_library QtOpenGL XMachOViewer
        deploy_qt_library QtConcurrent XMachOViewer

        deploy_qt_plugin platforms libqcocoa XMachOViewer
        deploy_qt_plugin platforms libqminimal XMachOViewer
        deploy_qt_plugin platforms libqoffscreen XMachOViewer

        make_release
        make_clear
    fi
fi