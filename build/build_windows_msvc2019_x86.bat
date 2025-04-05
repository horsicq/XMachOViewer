IF EXIST "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\VC\Auxiliary\Build\vcvarsall.bat" (
	call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\VC\Auxiliary\Build\vcvarsall.bat" x86
) ELSE (
	call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" x86
)

cd ..
mkdir tmp_build
cd tmp_build
cmake -DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_PREFIX_PATH="C:\Qt\5.15.2\msvc2019" -G "NMake Makefiles" ..
nmake
cpack

cd ..
xcopy /y /E tmp_build\packages\ packages\