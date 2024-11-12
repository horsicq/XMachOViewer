/* Copyright (c) 2019-2023 hors<horsicq@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
#include <QApplication>

#include "guimainwindow.h"
#include "xoptions.h"

int main(int argc, char *argv[])
{
#if QT_VERSION >= QT_VERSION_CHECK(5, 6, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
#ifdef Q_OS_MAC
#ifndef QT_DEBUG
    QCoreApplication::setLibraryPaths(QStringList(QString(argv[0]).remove("MacOS/XMachOViewer") + "PlugIns"));
#endif
#endif
    QCoreApplication::setOrganizationName(X_ORGANIZATIONNAME);
    QCoreApplication::setOrganizationDomain(X_ORGANIZATIONDOMAIN);
    QCoreApplication::setApplicationName(X_APPLICATIONNAME);
    QCoreApplication::setApplicationVersion(X_APPLICATIONVERSION);

    if ((argc == 2) && ((QString(argv[1]) == "--version") || (QString(argv[1]) == "-v"))) {
        QString sInfo = QString("%1 v%2").arg(X_APPLICATIONDISPLAYNAME, X_APPLICATIONVERSION);
        printf("%s\n", sInfo.toUtf8().data());

        return 0;
    }

    QApplication app(argc, argv);
    QApplication::setWindowIcon(QIcon(":/pics/main.png"));

    XOptions xOptions;

    xOptions.setName(X_OPTIONSFILE);

    xOptions.addID(XOptions::ID_VIEW_STYLE, "Fusion");
    xOptions.addID(XOptions::ID_VIEW_QSS, "");
    xOptions.addID(XOptions::ID_VIEW_LANG, "System");
    xOptions.addID(XOptions::ID_VIEW_FONT, "");

    xOptions.load();

    XOptions::adjustApplicationView(X_APPLICATIONNAME, &xOptions);

    GuiMainWindow w;
    w.show();

    return app.exec();
}
