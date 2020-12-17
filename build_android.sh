echo "Configuring and building Thirdparty/DBoW2 ..."

CMAKE_FLAGS=" -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake -DANDROID_ABI=arm64-v8a -DANDROID_NDK=$ANDROID_NDK -DANDROID_PLATFORM=android-27 -DCMAKE_ANDROID_ARCH_ABI=arm64-v8a -DCMAKE_ANDROID_NDK=$ANDROID_NDK -DCMAKE_SYSTEM_NAME=Android -DCMAKE_SYSTEM_VERSION=27 -DANDROID_ARM_NEON=TRUE -D OpenCV_DIR=/home/iago/graffter/libs/opencv/OpenCV-android-sdk-3.4.12/sdk/native/jni"

cd Thirdparty
git clone git@github.com:moritz-wundke/Boost-for-Android.git
cd Boost-for-Android && git checkout dc37be02fd7e4bc87a184d0f6934da5a5beb7f51
sh build-android.sh
cd ..

cd Thirdparty/DBoW2
mkdir build-android-v8a && cd build-android-v8a
cmake -DCMAKE_BUILD_TYPE=Release $CMAKE_FLAGS ..
make -j

cd ../../g2o

Thirdparty/Boost-for-Android/build/out

echo "Configuring and building Thirdparty/g2o ..."

mkdir build-android-v8a
cd build-android-v8a
cmake -DCMAKE_BUILD_TYPE=Release $CMAKE_FLAGS ..
make -j

cd ../../../

echo "Uncompress vocabulary ..."

cd Vocabulary
tar -xf ORBvoc.txt.tar.gz
cd ..

echo "Configuring and building ORB_SLAM3 ..."

mkdir build-android-v8a
cd build-android-v8a
cmake -DCMAKE_BUILD_TYPE=Release $CMAKE_FLAGS ..
make -j
