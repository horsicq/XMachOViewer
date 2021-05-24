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
        create_app_dir xmachoviewer
        
        cp -f $X_SOURCE_PATH/LICENSE                                        $X_SOURCE_PATH/release/$X_BUILD_NAME/
        cp -f $X_SOURCE_PATH/DEBIAN/control                                 $X_SOURCE_PATH/release/$X_BUILD_NAME/DEBIAN/
        sed -i "s/#ARCH#/$X_ARCHITECTURE/" $X_SOURCE_PATH/release/$X_BUILD_NAME/DEBIAN/control
        cp -f $X_SOURCE_PATH/build/release/xmachoviewer                     $X_SOURCE_PATH/release/$X_BUILD_NAME/usr/bin/
        cp -f $X_SOURCE_PATH/DEBIAN/xmachoviewer.desktop                    $X_SOURCE_PATH/release/$X_BUILD_NAME/usr/share/applications/
        cp -Rf $X_SOURCE_PATH/DEBIAN/hicolor/                               $X_SOURCE_PATH/release/$X_BUILD_NAME/usr/share/icons/
        cp -Rf $X_SOURCE_PATH/XStyles/qss/                                  $X_SOURCE_PATH/release/$X_BUILD_NAME/usr/lib/xmachoviewer/
        cp -f $X_SOURCE_PATH/gui_source/translation/*.qm                       $X_SOURCE_PATH/release/$X_BUILD_NAME/usr/lib/xmachoviewer/lang/
        mkdir -p $X_SOURCE_PATH/release/$X_BUILD_NAME/usr/lib/xmachoviewer/signatures
        cp -f $X_SOURCE_PATH/signatures/crypto.db                           $X_SOURCE_PATH/release/$X_BUILD_NAME/usr/lib/xmachoviewer/signatures/

        make_deb
        mv $X_SOURCE_PATH/release/$X_BUILD_NAME.deb $X_SOURCE_PATH/release/xmachoviewer_${X_RELEASE_VERSION}-${X_REVISION}_${X_ARCHITECTURE}.deb
        make_clear
    fi
fi
