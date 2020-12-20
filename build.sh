
cd Thirdparty/DBoW2
mkdir build && cd build
OPENCV_DIR=/home/iago/graffter/libs/opencv/opencv-4.1.1/build_linux_contrib_static_release/install/lib/cmake/opencv4
cmake -Wno-dev -DCMAKE_BUILD_TYPE=Release -D OpenCV_DIR=$OPENCV_DIR -DCMAKE_INSTALL_PREFIX=../install -DBUILD_Demo=OFF ..
make install -j
cd ../../..

cd Thirdparty/eigen
mkdir build && cd build
cmake -Wno-dev -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=../install ..
make install -j
cd ../../..

cd Thirdparty/g2o
mkdir build && cd build
cmake -Wno-dev -DCMAKE_BUILD_TYPE=Release ..
make -j
cd ../../..

cd Thirdparty/Pangolin
mkdir build && cd build
cmake -Wno-dev -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=../install -DBUILD_EXAMPLES=OFF -DBUILD_TOOLS=OFF -DBUILD_TESTS=OFF ..
make install -j
cd ../../..

echo "Uncompress vocabulary ..."

cd Vocabulary
tar -xf ORBvoc.txt.tar.gz
cd ..

echo "Configuring and building ORB_SLAM3 ..."

OPENCV_DIR=/home/iago/graffter/libs/opencv/opencv-4.1.1/build_linux_contrib_static_release/install/lib/cmake/opencv4
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DOpenCV_DIR=$OPENCV_DIR
make -j
