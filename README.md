[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=NF3FBD3KHMXDN)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/horsicq/XMachOViewer.svg)](https://github.com/horsicq/XMachOViewer/releases)
[![GitHub All Releases](https://img.shields.io/github/downloads/horsicq/XMachOViewer/total.svg)](https://github.com/horsicq/XMachOViewer/releases)
[![gitlocalized ](https://gitlocalize.com/repo/4736/whole_project/badge.svg)](https://github.com/horsicq/XTranslation)

MachO file viewer/editor for Windows, Linux and MacOS.

- Heuristic scan
- String viewer
- Hex viewer
- Disasm viewer(x86/64,ARM,PPC)
- Entropy viewer
- Hash viewer
- Crypto search
- Name demangling

![alt text](https://github.com/horsicq/XMachOViewer/blob/master/mascots/xmachoviewer.png "Mascot")

![alt text](https://github.com/horsicq/XMachOViewer/blob/master/docs/1.png "1")
![alt text](https://github.com/horsicq/XMachOViewer/blob/master/docs/2.png "2")
![alt text](https://github.com/horsicq/XMachOViewer/blob/master/docs/3.png "3")
![alt text](https://github.com/horsicq/XMachOViewer/blob/master/docs/4.png "4")
![alt text](https://github.com/horsicq/XMachOViewer/blob/master/docs/5.png "5")
![alt text](https://github.com/horsicq/XMachOViewer/blob/master/docs/6.png "6")
![alt text](https://github.com/horsicq/XMachOViewer/blob/master/docs/7.png "7")

How to build on Linux(Debian package)
=======

- sudo apt-get install git -y
- sudo apt-get install build-essential -y
- sudo apt-get install qt5-default -y
- sudo apt-get install qtbase5-dev -y
- sudo apt-get install qttools5-dev-tools -y

Clone project: git clone --recursive https://github.com/horsicq/XMachOViewer.git

Edit build_dpkg.sh ( check QMAKE_PATH variable)

Run build_dpkg.sh (bash -x build_dpkg.sh)

Install deb package: sudo dpkg -i release/[PackageName].deb

Run XMachOViewer: xmachoviewer [FileName]

How to build on OSX
=======

Install Qt 5.15.2: https://github.com/horsicq/build_tools

Clone project: git clone --recursive https://github.com/horsicq/XMachOViewer.git

Edit build_mac.bat ( check QMAKE_PATH variable)

Run build_mac.bat (bash -x build_mac.sh)

How to build on Windows(7-10)
=======

Install Visual Studio 2019: https://github.com/horsicq/build_tools

Install Qt 5.15.2 for VS2017: https://github.com/horsicq/build_tools

Install 7-Zip: https://github.com/horsicq/build_tools

Clone project: git clone --recursive https://github.com/horsicq/XMachOViewer.git

Edit build_win32.bat ( check QMAKE_PATH, VSVARS_PATH, SEVENZIP_PATH variables)

Edit build_win64.bat ( check QMAKE_PATH, VSVARS_PATH, SEVENZIP_PATH variables)

Run build_win32.bat

Run build_win64.bat
