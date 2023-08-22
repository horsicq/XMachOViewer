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
#include "guimainwindow.h"

#include "ui_guimainwindow.h"

GuiMainWindow::GuiMainWindow(QWidget *parent) : QMainWindow(parent), ui(new Ui::GuiMainWindow)
{
    ui->setupUi(this);
#ifdef USE_YARA
    XYara::initialize();
#endif
    g_pFile = nullptr;
    g_pXInfo = nullptr;
    g_pTempFile = nullptr;
    g_mode = MODE_UNKNOWN;

    ui->stackedWidget->setCurrentIndex(0);

    setWindowTitle(XOptions::getTitle(X_APPLICATIONDISPLAYNAME, X_APPLICATIONVERSION));

    setAcceptDrops(true);

    g_xOptions.setName(X_OPTIONSFILE);

    g_xOptions.addID(XOptions::ID_VIEW_STYLE, "Fusion");
    g_xOptions.addID(XOptions::ID_VIEW_QSS, "");
    g_xOptions.addID(XOptions::ID_VIEW_LANG, "System");
    g_xOptions.addID(XOptions::ID_VIEW_STAYONTOP, false);
    g_xOptions.addID(XOptions::ID_VIEW_SHOWLOGO, false);
    g_xOptions.addID(XOptions::ID_VIEW_FONT, "");
    g_xOptions.addID(XOptions::ID_FILE_SAVELASTDIRECTORY, true);
    g_xOptions.addID(XOptions::ID_FILE_SAVEBACKUP, true);
    g_xOptions.addID(XOptions::ID_FILE_SAVERECENTFILES, true);

#ifdef Q_OS_WIN
    g_xOptions.addID(XOptions::ID_FILE_CONTEXT, "*");
#endif

    DIEOptionsWidget::setDefaultValues(&g_xOptions);
    SearchSignaturesOptionsWidget::setDefaultValues(&g_xOptions);
    XHexViewOptionsWidget::setDefaultValues(&g_xOptions);
    XDisasmViewOptionsWidget::setDefaultValues(&g_xOptions);
    XOnlineToolsOptionsWidget::setDefaultValues(&g_xOptions);
    XInfoDBOptionsWidget::setDefaultValues(&g_xOptions);

    g_xOptions.addID(XOptions::ID_SCAN_YARARULESPATH, "$data/yara_rules");

    g_xOptions.load();

    g_xShortcuts.setName(X_SHORTCUTSFILE);
    g_xShortcuts.setNative(g_xOptions.isNative());

    g_xShortcuts.addGroup(XShortcuts::GROUPID_STRINGS);
    g_xShortcuts.addGroup(XShortcuts::GROUPID_SIGNATURES);
    g_xShortcuts.addGroup(XShortcuts::GROUPID_HEX);
    g_xShortcuts.addGroup(XShortcuts::GROUPID_DISASM);
    g_xShortcuts.addGroup(XShortcuts::GROUPID_FIND);

    g_xShortcuts.load();

    ui->widgetMACHO->setGlobal(&g_xShortcuts, &g_xOptions);
    ui->widgetMACHOFAT->setGlobal(&g_xShortcuts, &g_xOptions);

    connect(&g_xOptions, SIGNAL(openFile(QString)), this, SLOT(processFile(QString)));

    createMenus();

    adjustWindow();

    if (QCoreApplication::arguments().count() > 1) {
        QString sFileName = QCoreApplication::arguments().at(1);

        processFile(sFileName);
    }
}

GuiMainWindow::~GuiMainWindow()
{
    closeCurrentFile();
    g_xOptions.save();
    g_xShortcuts.save();

    DialogXInfoDBTransferProcess::saveDatabase(g_pXInfo);

    delete ui;
#ifdef USE_YARA
    XYara::finalize();
#endif
}

void GuiMainWindow::createMenus()
{
    QMenu *pMenuFile = new QMenu(tr("File"), ui->menubar);
    QMenu *pMenuTools = new QMenu(tr("Tools"), ui->menubar);
    QMenu *pMenuHelp = new QMenu(tr("Help"), ui->menubar);

    ui->menubar->addAction(pMenuFile->menuAction());
    ui->menubar->addAction(pMenuTools->menuAction());
    ui->menubar->addAction(pMenuHelp->menuAction());

    QAction *pActionOpen = new QAction(tr("Open"), this);
    QAction *pActionClose = new QAction(tr("Close"), this);
    QAction *pActionExit = new QAction(tr("Exit"), this);
    QAction *pActionOptions = new QAction(tr("Options"), this);
    QAction *pActionAbout = new QAction(tr("About"), this);
    QAction *pActionShortcuts = new QAction(tr("Shortcuts"), this);
    QAction *pActionDemangle = new QAction(tr("Demangle"), this);

    pMenuFile->addAction(pActionOpen);
    pMenuFile->addMenu(g_xOptions.createRecentFilesMenu(this));
    pMenuFile->addAction(pActionClose);
    pMenuFile->addAction(pActionExit);
    pMenuTools->addAction(pActionDemangle);
    pMenuTools->addAction(pActionShortcuts);
    pMenuTools->addAction(pActionOptions);
    pMenuHelp->addAction(pActionAbout);

    connect(pActionOpen, SIGNAL(triggered()), this, SLOT(actionOpenSlot()));
    connect(pActionClose, SIGNAL(triggered()), this, SLOT(actionCloseSlot()));
    connect(pActionExit, SIGNAL(triggered()), this, SLOT(actionExitSlot()));
    connect(pActionOptions, SIGNAL(triggered()), this, SLOT(actionOptionsSlot()));
    connect(pActionAbout, SIGNAL(triggered()), this, SLOT(actionAboutSlot()));
    connect(pActionShortcuts, SIGNAL(triggered()), this, SLOT(actionShortcutsSlot()));
    connect(pActionDemangle, SIGNAL(triggered()), this, SLOT(actionDemangleSlot()));
}

void GuiMainWindow::actionOpenSlot()
{
    QString sDirectory = g_xOptions.getLastDirectory();

    QString sFileName = QFileDialog::getOpenFileName(this, tr("Open file") + QString("..."), sDirectory, tr("All files") + QString(" (*)"));

    if (!sFileName.isEmpty()) {
        processFile(sFileName);
    }
}

void GuiMainWindow::actionCloseSlot()
{
    closeCurrentFile();
}

void GuiMainWindow::actionExitSlot()
{
    this->close();
}

void GuiMainWindow::actionOptionsSlot()
{
    DialogOptions dialogOptions(this, &g_xOptions, XOptions::GROUPID_FILE);
    dialogOptions.exec();

    adjustWindow();
}

void GuiMainWindow::actionAboutSlot()
{
    DialogAbout dialogAbout(this);
    dialogAbout.exec();
}

void GuiMainWindow::adjustWindow()
{
    if (g_mode == MODE_MACHO) {
        ui->widgetMACHO->adjustView();
    } else if (g_mode == MODE_MACHOFAT) {
        ui->widgetMACHOFAT->adjustView();
    }

    g_xOptions.adjustWindow(this);

    if (g_xOptions.isShowLogo()) {
        ui->labelLogo->show();
    } else {
        ui->labelLogo->hide();
    }
}

void GuiMainWindow::processFile(QString sFileName)
{
    bool bIsFile = XBinary::isFileExists(sFileName);
    bool bIsDirectory = XBinary::isDirectoryExists(sFileName);

    QString sTitle = sFileName;

    if ((sFileName != "") && (bIsFile || bIsDirectory)) {
        QIODevice *pOpenDevice = nullptr;

        g_xOptions.setLastFileName(sFileName);

        closeCurrentFile();

        g_pXInfo = new XInfoDB;

        if (bIsFile) {
            g_pFile = new QFile;

            g_pFile->setFileName(sFileName);

            if (!g_pFile->open(QIODevice::ReadWrite)) {
                if (!g_pFile->open(QIODevice::ReadOnly)) {
                    closeCurrentFile();
                }
            }

            pOpenDevice = g_pFile;
        }

        QSet<XBinary::FT> ftArchiveAvailable;

        ftArchiveAvailable.insert(XBinary::FT_ZIP);

        if (XArchives::isArchiveOpenValid(g_pFile, ftArchiveAvailable) || bIsDirectory) {
            bool bError = false;

            QSet<XBinary::FT> ftOpenAvailable;

            ftOpenAvailable.insert(XBinary::FT_MACHO);
            ftOpenAvailable.insert(XBinary::FT_MACHO32);
            ftOpenAvailable.insert(XBinary::FT_MACHO64);
            ftOpenAvailable.insert(XBinary::FT_MACHOFAT);

            FW_DEF::OPTIONS options = {};
            options.sTitle = sFileName;
            options.bFilter = true;
            options.bNoWindowOpen = true;

            DialogArchive dialogArchive(this);
            dialogArchive.setGlobal(&g_xShortcuts, &g_xOptions);

            if (bIsFile) {
                dialogArchive.setDevice(g_pFile, options, ftOpenAvailable);
            } else if (bIsDirectory) {
                dialogArchive.setDirectory(sFileName, options, ftOpenAvailable);
            }

            if (dialogArchive.exec() == QDialog::Accepted) {
                QString sRecordName = dialogArchive.getCurrentRecordFileName();

                if (bIsFile) {
                    g_pTempFile = new QTemporaryFile;
                    g_pTempFile->open();

                    if (XArchives::decompressToFile(XBinary::getDeviceFileName(g_pFile), sRecordName, g_pTempFile->fileName())) {
                        pOpenDevice = g_pTempFile;
                    } else {
                        bError = true;
                    }
                } else  // Directory
                {
                    g_pFile = new QFile;
                    sTitle = sRecordName;

                    g_pFile->setFileName(sRecordName);

                    if (!g_pFile->open(QIODevice::ReadWrite)) {
                        if (!g_pFile->open(QIODevice::ReadOnly)) {
                            closeCurrentFile();
                        }
                    }

                    pOpenDevice = g_pFile;
                }
            } else {
                bError = true;
            }

            if (bError) {
                close();
                return;
            }
        }

        if (pOpenDevice) {
            if (XMACH::isValid(pOpenDevice)) {
                g_pXInfo->setData(g_pFile, XBinary::FT_MACHO);
                g_mode = MODE_MACHO;

                ui->stackedWidget->setCurrentIndex(1);
                g_formatOptions.bIsImage = false;
                g_formatOptions.nImageBase = -1;
                g_formatOptions.nStartType = SMACH::TYPE_INFO;
                ui->widgetMACHO->setGlobal(&g_xShortcuts, &g_xOptions);
                ui->widgetMACHO->setData(pOpenDevice, g_formatOptions, 0, 0, 0);
                ui->widgetMACHO->setXInfoDB(g_pXInfo);

                ui->widgetMACHO->reload();

                adjustWindow();

                setWindowTitle(sTitle);
            } else if (XMACHOFat::isValid(pOpenDevice)) {
                g_pXInfo->setData(g_pFile, XBinary::FT_MACHOFAT);
                g_mode = MODE_MACHOFAT;

                ui->stackedWidget->setCurrentIndex(2);
                g_formatOptions.bIsImage = false;
                g_formatOptions.nImageBase = -1;
                g_formatOptions.nStartType = SMACH::TYPE_INFO;
                ui->widgetMACHOFAT->setGlobal(&g_xShortcuts, &g_xOptions);
                ui->widgetMACHOFAT->setData(pOpenDevice, g_formatOptions, 0, 0, 0);
                ui->widgetMACHOFAT->setXInfoDB(g_pXInfo);

                ui->widgetMACHOFAT->reload();

                adjustWindow();

                setWindowTitle(sTitle);
            } else {
                QMessageBox::critical(this, tr("Error"), tr("It is not a valid file"));
            }
        } else {
            QMessageBox::critical(this, tr("Error"), tr("Cannot open file"));
        }
    } else {
        QMessageBox::critical(this, tr("Error"), tr("Cannot open file"));
    }
}

void GuiMainWindow::closeCurrentFile()
{
    ui->stackedWidget->setCurrentIndex(0);

    if (g_pXInfo) {
        delete g_pXInfo;
        g_pXInfo = nullptr;
    }

    if (g_pFile) {
        g_pFile->close();
        delete g_pFile;
        g_pFile = nullptr;
    }

    if (g_pTempFile) {
        g_pTempFile->close();
        delete g_pTempFile;
        g_pTempFile = nullptr;
    }

    ui->stackedWidget->setCurrentIndex(0);
    ui->widgetMACHO->cleanup();
    ui->widgetMACHOFAT->cleanup();

    setWindowTitle(QString("%1 v%2").arg(X_APPLICATIONDISPLAYNAME, X_APPLICATIONVERSION));
}

void GuiMainWindow::dragEnterEvent(QDragEnterEvent *event)
{
    event->acceptProposedAction();
}

void GuiMainWindow::dragMoveEvent(QDragMoveEvent *event)
{
    event->acceptProposedAction();
}

void GuiMainWindow::dropEvent(QDropEvent *event)
{
    const QMimeData *mimeData = event->mimeData();

    if (mimeData->hasUrls()) {
        QList<QUrl> urlList = mimeData->urls();

        if (urlList.count()) {
            QString sFileName = urlList.at(0).toLocalFile();

            sFileName = XBinary::convertFileName(sFileName);

            processFile(sFileName);
        }
    }
}

void GuiMainWindow::actionShortcutsSlot()
{
    DialogShortcuts dialogShortcuts(this);

    dialogShortcuts.setData(&g_xShortcuts);

    dialogShortcuts.exec();

    adjustWindow();
}

void GuiMainWindow::actionDemangleSlot()
{
    DialogDemangle dialogDemangle(this);

    dialogDemangle.exec();
}
