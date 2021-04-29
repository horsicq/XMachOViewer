QT       += core gui widgets

TARGET = xmachoviewer
TEMPLATE = app

CONFIG += c++11

SOURCES += \
        guimainwindow.cpp \
        main_gui.cpp \
        dialogoptions.cpp \
        dialogabout.cpp

HEADERS += \
        dialogoptions.h \
        dialogabout.h \
        guimainwindow.h

FORMS += \
        dialogoptions.ui \
        dialogabout.ui \
        guimainwindow.ui

include($$PWD/../build.pri)

XCONFIG += use_disasm
XCONFIG += use_extrabuttons

!contains(XCONFIG, archive_widget) {
    XCONFIG += archive_widget
    include($$PWD/../../_mylibs/archive_widget/archive_widget.pri)
}

!contains(XCONFIG, xoptions) {
    XCONFIG += xoptions
    include($$PWD/../../_mylibs/XOptions/xoptions.pri)
}

win32 {
    RC_ICONS = $$PWD/../icons/main.ico
}
macx {
    ICON = $$PWD/../icons/main.icns
}

RESOURCES += \
    rsrc.qrc
