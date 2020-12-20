#!/bin/bash
ANDROID_ABI=arm64-v8a

CMAKE_FLAGS=" -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake -DANDROID_ABI=$ANDROID_ABI -DANDROID_NDK=$ANDROID_NDK -DANDROID_PLATFORM=android-27 -DCMAKE_ANDROID_ARCH_ABI=$ANDROID_ABI -DCMAKE_ANDROID_NDK=$ANDROID_NDK -DCMAKE_SYSTEM_NAME=Android -DCMAKE_SYSTEM_VERSION=27 -DANDROID_ARM_NEON=TRUE"
OPENCV_DIR=/home/iago/graffter/libs/opencv/OpenCV-android-sdk-4.1.1/sdk/native/jni

echo "Configuring and building Thirdparty/Boost-for-Android ..."
cd Thirdparty
git clone git@github.com:moritz-wundke/Boost-for-Android.git
cd Boost-for-Android && git checkout dc37be02fd7e4bc87a184d0f6934da5a5beb7f51
sh build-android.sh --with-libraries=serialization
cd ../..

echo "Configuring and building Thirdparty/DBoW2 ..."

cd Thirdparty/DBoW2
mkdir build-$ANDROID_ABI && cd build-$ANDROID_ABI
cmake -Wno-dev -DCMAKE_BUILD_TYPE=Release $CMAKE_FLAGS -D OpenCV_DIR=$OPENCV_DIR -DCMAKE_INSTALL_PREFIX=../install-$ANDROID_ABI -DBUILD_Demo=OFF ..
make install -j
cd ../../..

cd Vocabulary
tar -xf ORBvoc.txt.tar.gz
cd ..

echo "Configuring and building ORB_SLAM3 ..."


mkdir build-android-v8a && cd build-android-v8a
cmake -DCMAKE_BUILD_TYPE=Release -D OpenCV_DIR=$OPENCV_DIR $CMAKE_FLAGS ..
make -j

-DPangolin_DIR=/home/iago/workspace/pangolin_android/install-v8/lib/cmake/Pangolin/
-DPangolin_DIR=/home/iago/workspace/pangolin_android/install_linux/lib/cmake/Pangolin/

cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_EXAMPLES=OFF -DBUILD_TESTS=OFF -DBUILD_TOOLS=OFF -Wno-dev $CMAKE_FLAGS ..
