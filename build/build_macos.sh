# sudo ~/Qt/Tools/CMake/CMake.app/Contents/bin/cmake-gui --install
cd ..
mkdir tmp_build
cd tmp_build
cmake -DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_PREFIX_PATH="~/Qt/5.15.2/clang_64" ..
make
Pack -G ZIP
