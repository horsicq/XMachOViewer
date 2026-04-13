IF EXIST "C:\Program Files\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvarsall.bat" (
	call "C:\Program Files\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvarsall.bat" x64
) ELSE (
	call "C:\Program Files\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvarsall.bat" x64
)

cd ..
mkdir tmp_build
cd tmp_build
cmake -DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_PREFIX_PATH="C:\Qt\6.10.1\msvc2022_64" -G "NMake Makefiles" ..
nmake
cpack -G ZIP

cd ..
xcopy /y /E tmp_build\packages\ packages\
