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
