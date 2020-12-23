#!/bin/bash
OPENCV_DIR=/home/iago/graffter/libs/opencv/opencv-4.1.1/build_linux_contrib_static_release/install/lib/cmake/opencv4

echo "--> Building DBoW2 library..."
cd Thirdparty/DBoW2
mkdir build && cd build
cmake -Wno-dev -DCMAKE_BUILD_TYPE=Release -D OpenCV_DIR=$OPENCV_DIR ..
make -j
cd ../../..

#cd Thirdparty/eigen
#mkdir build && cd build
#cmake -Wno-dev -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=../install ..
#make install -j
#cd ../../..

echo "--> Building g2o library..."
cd Thirdparty/g2o
mkdir build && cd build
cmake -Wno-dev -DCMAKE_BUILD_TYPE=Release ..
make -j
cd ../../..

echo "--> Building Pangolin library..."
cd Thirdparty/Pangolin
mkdir build && cd build
cmake -Wno-dev -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=../install -D BUILD_EXAMPLES=OFF ..
make install -j
cd ../../..

echo "Uncompress vocabulary ..."
cd Vocabulary
tar -xf ORBvoc.txt.tar.gz
cd ..

echo "Configuring and building ORB_SLAM3 ..."
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DOpenCV_DIR=$OPENCV_DIR ..
make -j
