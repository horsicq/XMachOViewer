#!/bin/bash -x
export QMAKE_PATH=/usr/bin/qmake

export X_SOURCE_PATH=$PWD
export X_BUILD_NAME=xmachoviewer_linux_portable
export X_RELEASE_VERSION=$(cat "release_version.txt")

source build_tools/linux.sh

check_file $QMAKE_PATH

if [ -z "$X_ERROR" ]; then
    make_init
    make_build "$X_SOURCE_PATH/xmachoviewer_source.pro"
    cd "$X_SOURCE_PATH/gui_source"
    make_translate "gui_source_tr.pro"
    cd "$X_SOURCE_PATH"

    check_file "$X_SOURCE_PATH/build/release/xmachoviewer"
    if [ -z "$X_ERROR" ]; then
        create_deb_app_dir xmachoviewer
        
        export X_PACKAGENAME='xmachoviewer'
        export X_MAINTAINER='hors <horsicq@gmail.com>'
        
        export X_HOMEPAGE='http://ntinfo.biz'
        export X_DESCRIPTION='XMachOViewer is a MACH-O file viewer/editor.'
        
        if [ "$X_DEBIAN_VERSION" -ge "11" ]; then
            export X_DEPENDS='libqt5core5a, libqt5svg5, libqt5gui5, libqt5widgets5, libqt5opengl5, libqt5dbus5'
        else
            export X_DEPENDS='qt5-default, libqt5core5a, libqt5svg5, libqt5gui5, libqt5widgets5, libqt5opengl5, libqt5dbus5'
        fi
        
        create_deb_control $X_SOURCE_PATH/release/$X_BUILD_NAME/DEBIAN/control
        
        cp -f $X_SOURCE_PATH/build/release/xmachoviewer                     $X_SOURCE_PATH/release/$X_BUILD_NAME/usr/bin/
        cp -f $X_SOURCE_PATH/DEBIAN/xmachoviewer.desktop                    $X_SOURCE_PATH/release/$X_BUILD_NAME/usr/share/applications/
        sed -i "s/#VERSION#/$X_RELEASE_VERSION/"                            $X_SOURCE_PATH/release/$X_BUILD_NAME/usr/share/applications/xmachoviewer.desktop
        cp -Rf $X_SOURCE_PATH/DEBIAN/hicolor/                               $X_SOURCE_PATH/release/$X_BUILD_NAME/usr/share/icons/
        cp -Rf $X_SOURCE_PATH/XStyles/qss/                                  $X_SOURCE_PATH/release/$X_BUILD_NAME/usr/lib/xmachoviewer/
        mkdir -p $X_SOURCE_PATH/release/$X_BUILD_NAME/usr/lib/xmachoviewer/lang/
        cp -f $X_SOURCE_PATH/gui_source/translation/*.qm                    $X_SOURCE_PATH/release/$X_BUILD_NAME/usr/lib/xmachoviewer/lang/
        mkdir -p $X_SOURCE_PATH/release/$X_BUILD_NAME/usr/lib/xmachoviewer/signatures
        cp -f $X_SOURCE_PATH/signatures/crypto.db                           $X_SOURCE_PATH/release/$X_BUILD_NAME/usr/lib/xmachoviewer/signatures/

        make_deb
        mv $X_SOURCE_PATH/release/$X_BUILD_NAME.deb $X_SOURCE_PATH/release/xmachoviewer_${X_RELEASE_VERSION}_${X_OS_VERSION}_${X_ARCHITECTURE}.deb
        make_clear
    fi
fi
