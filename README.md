[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=NF3FBD3KHMXDN)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/horsicq/XMachOViewer.svg)](https://github.com/horsicq/XMachOViewer/releases)
[![GitHub All Releases](https://img.shields.io/github/downloads/horsicq/XMachOViewer/total.svg)](https://github.com/horsicq/XMachOViewer/releases)
[![gitlocalized ](https://gitlocalize.com/repo/4736/whole_project/badge.svg)](https://gitlocalize.com/repo/4736/whole_project?utm_source=badge)

MachO file viewer/editor for Windows, Linux and MacOS.

![alt text](https://github.com/horsicq/XMachOViewer/blob/master/mascots/xmachoviewer.png "Mascot")

How to build on Linux
=======

Install Qt 5.15.2: https://github.com/horsicq/build_tools

Clone project: git clone --recursive https://github.com/horsicq/XMachOViewer.git

Edit build_lin64.bat ( check QT_PATH variable)

Run build_lin64.bat

How to build on OSX
=======

Install Qt 5.15.2: https://github.com/horsicq/build_tools

Clone project: git clone --recursive https://github.com/horsicq/XMachOViewer.git

Edit build_mac.bat ( check QT_PATH variable)

Run build_mac.bat

How to build on Windows(7-10)
=======

Install Visual Studio 2019: https://github.com/horsicq/build_tools

Install Qt 5.15.2 for VS2017: https://github.com/horsicq/build_tools

Install 7-Zip: https://github.com/horsicq/build_tools

Clone project: git clone --recursive https://github.com/horsicq/XMachOViewer.git

Edit build_win32.bat ( check VS_PATH,  SEVENZIP_PATH, QT_PATH variables)

Edit build_win64.bat ( check VS_PATH,  SEVENZIP_PATH, QT_PATH variables)

Run build_win32.bat

Run build_win64.bat
