#!/bin/bash -x

RELEASE_VERSION=$(cat "release_version.txt")
ARCHITECTURE=$(uname -m)
REVISION=$(date "+%Y%m%d")
echo $RELEASE_VERSION
SOURCE_PATH=$PWD

if [[ $ARCHITECTURE == *"x86_64"* ]]; then
    ARCHITECTURE="amd64"
fi

BUILD_NAME=die_${RELEASE_VERSION}-${REVISION}_${ARCHITECTURE}

cd $SOURCE_PATH

function makeproject
{
    cd $SOURCE_PATH/$1
    
    qmake $1.pro -spec linux-g++
    make -f Makefile clean
    make -f Makefile

    rm -rf Makefile
    rm -rf Makefile.Release
    rm -rf Makefile.Debug
    rm -rf object_script.*     

    cd $SOURCE_PATH
}

rm -rf $SOURCE_PATH/build

makeproject build_libs
makeproject gui_source

cd $SOURCE_PATH/gui_source
lupdate gui_source_tr.pro
cd $SOURCE_PATH

mkdir -p $SOURCE_PATH/release
rm -rf $SOURCE_PATH/release/$BUILD_NAME
mkdir -p $SOURCE_PATH/release/$BUILD_NAME
mkdir -p $SOURCE_PATH/release/$BUILD_NAME/DEBIAN
mkdir -p $SOURCE_PATH/release/$BUILD_NAME/usr
mkdir -p $SOURCE_PATH/release/$BUILD_NAME/usr/bin
mkdir -p $SOURCE_PATH/release/$BUILD_NAME/usr/lib
mkdir -p $SOURCE_PATH/release/$BUILD_NAME/usr/lib/xmachoviewer
mkdir -p $SOURCE_PATH/release/$BUILD_NAME/usr/lib/xmachoviewer/lang
mkdir -p $SOURCE_PATH/release/$BUILD_NAME/usr/lib/xmachoviewer/signatures
mkdir -p $SOURCE_PATH/release/$BUILD_NAME/usr/share
mkdir -p $SOURCE_PATH/release/$BUILD_NAME/usr/share/applications
mkdir -p $SOURCE_PATH/release/$BUILD_NAME/usr/share/icons

cp -f $SOURCE_PATH/build/release/xmachoviewer                     		$SOURCE_PATH/release/$BUILD_NAME/usr/bin/

cp -f $SOURCE_PATH/DEBIAN/control                     		    $SOURCE_PATH/release/$BUILD_NAME/DEBIAN/
cp -f $SOURCE_PATH/DEBIAN/xmachoviewer.desktop                     	    $SOURCE_PATH/release/$BUILD_NAME/usr/share/applications/
cp -f $SOURCE_PATH/LICENSE                     		            $SOURCE_PATH/release/$BUILD_NAME/
cp -Rf $SOURCE_PATH/XStyles/qss/ $SOURCE_PATH/release/$BUILD_NAME/usr/lib/xmachoviewer/

cp -Rf $SOURCE_PATH/DEBIAN/hicolor/ $SOURCE_PATH/release/$BUILD_NAME/usr/share/icons/

lrelease  $SOURCE_PATH/gui_source/translation/xmachoviewer_de.ts -qm  $SOURCE_PATH/release/$BUILD_NAME/usr/lib/xmachoviewer/lang/xmachoviewer_de.qm
lrelease  $SOURCE_PATH/gui_source/translation/xmachoviewer_es.ts -qm $SOURCE_PATH/release/$BUILD_NAME/usr/lib/xmachoviewer/lang/xmachoviewer_es.qm
lrelease  $SOURCE_PATH/gui_source/translation/xmachoviewer_fr.ts -qm  $SOURCE_PATH/release/$BUILD_NAME/usr/lib/xmachoviewer/lang/xmachoviewer_fr.qm
lrelease  $SOURCE_PATH/gui_source/translation/xmachoviewer_he.ts -qm $SOURCE_PATH/release/$BUILD_NAME/usr/lib/xmachoviewer/lang/xmachoviewer_he.qm
lrelease  $SOURCE_PATH/gui_source/translation/xmachoviewer_it.ts -qm $SOURCE_PATH/release/$BUILD_NAME/usr/lib/xmachoviewer/lang/xmachoviewer_it.qm
lrelease  $SOURCE_PATH/gui_source/translation/xmachoviewer_ja.ts -qm  $SOURCE_PATH/release/$BUILD_NAME/usr/lib/xmachoviewer/lang/xmachoviewer_ja.qm
lrelease  $SOURCE_PATH/gui_source/translation/xmachoviewer_ko.ts -qm $SOURCE_PATH/release/$BUILD_NAME/usr/lib/xmachoviewer/lang/xmachoviewer_ko.qm
lrelease  $SOURCE_PATH/gui_source/translation/xmachoviewer_pl.ts -qm  $SOURCE_PATH/release/$BUILD_NAME/usr/lib/xmachoviewer/lang/xmachoviewer_pl.qm
lrelease  $SOURCE_PATH/gui_source/translation/xmachoviewer_pt_BR.ts -qm  $SOURCE_PATH/release/$BUILD_NAME/usr/lib/xmachoviewer/lang/xmachoviewer_pt_BR.qm
lrelease  $SOURCE_PATH/gui_source/translation/xmachoviewer_pt.ts -qm  $SOURCE_PATH/release/$BUILD_NAME/usr/lib/xmachoviewer/lang/xmachoviewer_pt.qm
lrelease  $SOURCE_PATH/gui_source/translation/xmachoviewer_ru.ts -qm  $SOURCE_PATH/release/$BUILD_NAME/usr/lib/xmachoviewer/lang/xmachoviewer_ru.qm
lrelease  $SOURCE_PATH/gui_source/translation/xmachoviewer_tr.ts -qm $SOURCE_PATH/release/$BUILD_NAME/usr/lib/xmachoviewer/lang/xmachoviewer_tr.qm
lrelease  $SOURCE_PATH/gui_source/translation/xmachoviewer_vi.ts -qm  $SOURCE_PATH/release/$BUILD_NAME/usr/lib/xmachoviewer/lang/xmachoviewer_vi.qm
lrelease  $SOURCE_PATH/gui_source/translation/xmachoviewer_zh.ts -qm  $SOURCE_PATH/release/$BUILD_NAME/usr/lib/xmachoviewer/lang/xmachoviewer_zh.qm
lrelease  $SOURCE_PATH/gui_source/translation/xmachoviewer_zh_TW.ts -qm  $SOURCE_PATH/release/$BUILD_NAME/usr/lib/xmachoviewer/lang/xmachoviewer_zh_TW.qm

cp -f $SOURCE_PATH/signatures/crypto.db                     		$SOURCE_PATH/release/$BUILD_NAME/usr/lib/xmachoviewer/signatures/

#sudo chown root:root -R $SOURCE_PATH/release/$BUILD_NAME
#sudo chmod 0755 $SOURCE_PATH/release/$BUILD_NAME/usr/bin/xmachoviewer
#sudo chmod 0755 $SOURCE_PATH/release/$BUILD_NAME/usr/bin/xmachoviewerc
#sudo dpkg -b $SOURCE_PATH/release/$BUILD_NAME
#sudo rm -rf $SOURCE_PATH/release/$BUILD_NAME
#sudo chmod -R 777 $SOURCE_PATH/release/

dpkg -b $SOURCE_PATH/release/$BUILD_NAME
rm -rf $SOURCE_PATH/release/$BUILD_NAME
