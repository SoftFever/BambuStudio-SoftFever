#!/bin/sh

export BUILD_ARCH="arm64"

echo "\nbrew --prefix libiconv:\n"
brew --prefix libiconv
echo "\nbrew --prefix zstd:\n"
brew --prefix zstd
export LIBRARY_PATH=$LIBRARY_PATH:$(brew --prefix zstd)/lib/

WD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd $WD/deps
mkdir -p build
cd build
DEPS=$PWD/BambuStudio_dep
mkdir -p $DEPS
if [ "studio." != $1. ]; 
then
    echo "building deps..."
    echo "cmake ../ -DDESTDIR=$DEPS -DOPENSSL_ARCH=darwin64-${BUILD_ARCH}-cc -DCMAKE_BUILD_TYPE=Release -DCMAKE_OSX_ARCHITECTURES:STRING=${BUILD_ARCH}"
    cmake ../ -DDESTDIR="$DEPS" -DOPENSSL_ARCH="darwin64-${BUILD_ARCH}-cc" -DCMAKE_BUILD_TYPE=Release -DCMAKE_OSX_ARCHITECTURES:STRING=${BUILD_ARCH}
    cmake --build . --config Release --target all 
fi


if [ "deps." == "$1". ];
then
    exit 0
fi

cd $WD
mkdir -p build
cd build
echo "building studio..."
cmake .. -GXcode -DBBL_RELEASE_TO_PUBLIC=1 -DCMAKE_PREFIX_PATH="$DEPS/usr/local" -DCMAKE_INSTALL_PREFIX="$PWD/BambuStudio-SoftFever" -DCMAKE_BUILD_TYPE=Release -DCMAKE_MACOSX_RPATH=ON -DCMAKE_INSTALL_RPATH="$DEPS/usr/local" -DCMAKE_MACOSX_BUNDLE=ON -DCMAKE_OSX_ARCHITECTURES=${BUILD_ARCH}
cmake --build . --config Release --target ALL_BUILD 
mkdir -p BambuStudio-SoftFever
cd BambuStudio-SoftFever
rm -r ./BambuStudio-SoftFever.app
cp -pR ../src/Release/BambuStudio.app ./BambuStudio-SoftFever.app
resources_path=$(readlink ./BambuStudio-SoftFever.app/Contents/Resources)
rm ./BambuStudio-SoftFever.app/Contents/Resources
cp -R $resources_path ./BambuStudio-SoftFever.app/Contents/Resources
# extract version
ver=$(grep '^#define SoftFever_VERSION' ../src/libslic3r/libslic3r_version.h | cut -d ' ' -f3)
ver="${ver//\"}"
zip -FSr BambuStudio-SoftFever_V${ver}_Mac_${BUILD_ARCH}.zip BambuStudio-SoftFever.app

