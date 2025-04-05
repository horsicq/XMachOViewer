call "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" x86
cd ..
mkdir tmp_build
cd tmp_build
cmake -DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_PREFIX_PATH="C:\Qt5.6.3\5.6.3\msvc2013" -G "NMake Makefiles" ..
nmake
cpack

cd ..
xcopy /y /E tmp_build\packages\ packages\