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
#ifndef DIALOGOPTIONS_H
#define DIALOGOPTIONS_H

#include <QDialog>
#include <QDir>
#include <QFileDialog>
#include <QMessageBox>
#include <QSettings>

#include "../global.h"
#include "searchsignaturesoptionswidget.h"
#include "dieoptionswidget.h"
#include "xbinary.h"
#include "xdisasmviewoptionswidget.h"
#include "xhexviewoptionswidget.h"
#include "xinfodboptionswidget.h"
#include "xonlinetoolsoptionswidget.h"
#include "xoptions.h"

namespace Ui {
class DialogOptions;
}

class DialogOptions : public QDialog {
    Q_OBJECT

public:
    explicit DialogOptions(QWidget *pParent, XOptions *pOptions, XOptions::GROUPID groupId);
    ~DialogOptions();

private:
    Ui::DialogOptions *ui;
    DIEOptionsWidget *g_pDIEOptionsWidget;
    SearchSignaturesOptionsWidget *g_pSearchSignaturesOptionsWidget;
    XHexViewOptionsWidget *g_pXHexViewOptionsWidget;
    XDisasmViewOptionsWidget *g_pXDisasmViewOptionsWidget;
    XOnlineToolsOptionsWidget *g_pXOnlineToolsOptionsWidget;
    XInfoDBOptionsWidget *g_pXInfoDBOptionsWidget;
};

#endif  // DIALOGOPTIONS_H
