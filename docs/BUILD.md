# Instructions to build XMachOViewer

## Docker

```bash
git clone https://github.com/horsicq/XMachOViewer.git
cd XMachOViewer
docker build .
```

## How to build on Linux

- Install prerequisite packages:

For Ubuntu 14.04-20.04

```bash
sudo apt-get install --quiet --assume-yes git build-essential qt5-default qtbase5-dev qttools5-dev-tools libqt5svg5-dev qtscript5-dev
```

For Ubuntu 22.04

```bash
sudo apt-get install --quiet --assume-yes git build-essential qtbase5-dev qttools5-dev-tools libqt5svg5-dev qtscript5-dev
```

- Clone this repo recursively:

```bash
git clone --recursive https://github.com/horsicq/XMachOViewer.git
```

- Run build script:

```bash
cd XMachOViewer
bash -x build_dpkg.sh
```

# How to build on Linux(Automake)

Qt framework has to be installed on the system.

- For (Ubuntu) Install GIT:

```bash
sudo apt-get install --quiet --assume-yes git
```

- For (Ubuntu 20.04) Install Qt Framework:

```bash
sudo apt-get install --quiet --assume-yes git build-essential qt5-default qtbase5-dev qttools5-dev-tools libqt5svg5-dev qtscript5-dev
```

- For (Ubuntu 22.04) Install Qt Framework:

```bash
sudo apt-get install --quiet --assume-yes git build-essential qtbase5-dev qttools5-dev-tools libqt5svg5-dev qtscript5-dev
```

- Clone this repo recursively:

```bash
git clone --recursive https://github.com/horsicq/XMachOViewer.git
```

- Build and install

```bash
cd XMachOViewer
chmod a+x configure
./configure
make
sudo make install
```

## How to build on OSX

Install Qt 5.15.2: https://github.com/horsicq/build_tools

Clone project: git clone --recursive https://github.com/horsicq/XMachOViewer.git

cd XMachOViewer

Edit build_mac.bat ( check QT_PATH variable)

Run build_mac.bat

## How to build on Windows(XP)

Install Visual Studio 2013: https://github.com/horsicq/build_tools

Install Qt 5.6.3 for VS2013: https://github.com/horsicq/build_tools

Install 7-Zip: https://www.7-zip.org/

Clone project: git clone --recursive https://github.com/horsicq/XMachOViewer.git

cd XMachOViewer

Edit build_winxp.bat ( check VS_PATH, SEVENZIP_PATH, QT_PATH variables)

Run build_winxp.bat

## How to build on Windows(7-10)

Install Visual Studio 2019: https://github.com/horsicq/build_tools

Install Qt 5.15.2 for VS2019: https://github.com/horsicq/build_tools

Install 7-Zip: https://www.7-zip.org/

Install Inno Setup: https://github.com/horsicq/build_tools

Clone project: git clone --recursive https://github.com/horsicq/XMachOViewer.git

cd XMachOViewer

Edit build_msvc_win32.bat ( check VSVARS_PATH, SEVENZIP_PATH, INNOSETUP_PATH, QMAKE_PATH variables)

Edit build_msvc_win64.bat ( check VSVARS_PATH, SEVENZIP_PATH, INNOSETUP_PATH, QMAKE_PATH variables)

Run build_win32.bat

Run build_win64.bat

## How to build with CMAKE

- Install prerequisite packages:

For (Ubuntu 20.04) Install Qt Framework:

```bash
sudo apt-get install --quiet --assume-yes git build-essential qt5-default qtbase5-dev qttools5-dev-tools libqt5svg5-dev qtscript5-dev
```

For (Ubuntu 22.04) Install Qt Framework:

```bash
sudo apt-get install --quiet --assume-yes git build-essential qtbase5-dev qttools5-dev-tools libqt5svg5-dev qtscript5-dev
```

- Clone this repo recursively:

```bash
git clone --recursive https://github.com/horsicq/XMachOViewer.git
```

- Build with CMake:

```bash
cd XMachOViewer
mkdir build
cmake . -B build
cd build
make -j4
```
