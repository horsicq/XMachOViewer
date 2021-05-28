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

    check_file "$X_SOURCE_PATH/build/release/xmachoviewer.app/Contents/MacOS/xmachoviewer"
    if [ -z "$X_ERROR" ]; then
        cp -R "$X_SOURCE_PATH/build/release/xmachoviewer.app" "$X_SOURCE_PATH/release/$X_BUILD_NAME"

        mkdir -p $X_SOURCE_PATH/release/$X_BUILD_NAME/xmachoviewer.app/Contents/Resources/signatures
        cp -R $X_SOURCE_PATH/signatures/crypto.db            $X_SOURCE_PATH/release/$X_BUILD_NAME/xmachoviewer.app/Contents/Resources/signatures
        cp -Rf $X_SOURCE_PATH/XStyles/qss                    $X_SOURCE_PATH/release/$X_BUILD_NAME/xmachoviewer.app/Contents/Resources/

        fiximport "$X_SOURCE_PATH/build/release/xmachoviewer.app/Contents/MacOS/xmachoviewer"

        deploy_qt_library QtWidgets xmachoviewer
        deploy_qt_library QtGui xmachoviewer
        deploy_qt_library QtCore xmachoviewer
        deploy_qt_library QtDBus xmachoviewer
        deploy_qt_library QtPrintSupport xmachoviewer
        deploy_qt_library QtSvg xmachoviewer
        deploy_qt_library QtOpenGL xmachoviewer
        deploy_qt_library QtConcurrent xmachoviewer

        deploy_qt_plugin platforms libqcocoa xmachoviewer
        deploy_qt_plugin platforms libqminimal xmachoviewer
        deploy_qt_plugin platforms libqoffscreen xmachoviewer

        make_release
        make_clear
    fi
fi