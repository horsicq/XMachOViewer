#!/bin/bash -x
export X_SOURCE_PATH=$PWD

cp -f $X_SOURCE_PATH/build/release/xmachoviewer                     /usr/bin/
cp -f $X_SOURCE_PATH/DEBIAN/xmachoviewer.desktop                    /usr/share/applications/
cp -Rf $X_SOURCE_PATH/DEBIAN/hicolor/                               /usr/share/icons/
cp -Rf $X_SOURCE_PATH/XStyles/qss/                                  /usr/lib/xmachoviewer/
mv $X_SOURCE_PATH/gui_source/translation/*.qm                       /usr/lib/xmachoviewer/lang/
mkdir -p  /usr/lib/xmachoviewer/signatures
cp -f $X_SOURCE_PATH/signatures/crypto.db                           /usr/lib/xmachoviewer/signatures/
