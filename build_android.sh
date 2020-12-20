echo "Configuring and building Thirdparty/DBoW2 ..."

cd Thirdparty
git clone git@github.com:moritz-wundke/Boost-for-Android.git
cd Boost-for-Android && git checkout dc37be02fd7e4bc87a184d0f6934da5a5beb7f51
sh build-android.sh --with-libraries=serialization
cd ../..

cd Vocabulary
tar -xf ORBvoc.txt.tar.gz
cd ..

echo "Configuring and building ORB_SLAM3 ..."

OPENCV_DIR=/home/iago/graffter/libs/opencv/OpenCV-android-sdk-4.1.1/sdk/native/jni
CMAKE_FLAGS=" -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake -DANDROID_ABI=arm64-v8a -DANDROID_NDK=$ANDROID_NDK -DANDROID_PLATFORM=android-27 -DCMAKE_ANDROID_ARCH_ABI=arm64-v8a -DCMAKE_ANDROID_NDK=$ANDROID_NDK -DCMAKE_SYSTEM_NAME=Android -DCMAKE_SYSTEM_VERSION=27 -DANDROID_ARM_NEON=TRUE"

mkdir build-android-v8a && cd build-android-v8a
cmake -DCMAKE_BUILD_TYPE=Release -D OpenCV_DIR=$OPENCV_DIR $CMAKE_FLAGS ..
make -j
