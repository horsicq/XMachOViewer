cd ..
mkdir tmp_build
cd tmp_build
cmake -DCMAKE_BUILD_TYPE=MinSizeRel ..
make
cpack -G DEB
cd ..
cp -Rf tmp_build/packages .

