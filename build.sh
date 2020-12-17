echo "Configuring and building Thirdparty/DBoW2 ..."
#OPENCV_DIR=/home/iago/graffter/libs/opencv/opencv-4.4.0/build_linux_contrib_static_release/install/lib/cmake/opencv4
OPENCV_DIR=/home/iago/graffter/libs/opencv/opencv-4.1.1/build_linux_contrib_static_release/install/lib/cmake/opencv4

cd Thirdparty/DBoW2
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DOpenCV_DIR=$OPENCV_DIR
make -j

cd ../../g2o

echo "Configuring and building Thirdparty/g2o ..."

mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j

cd ../../../

echo "Uncompress vocabulary ..."

cd Vocabulary
tar -xf ORBvoc.txt.tar.gz
cd ..

echo "Configuring and building ORB_SLAM3 ..."

mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DOpenCV_DIR=$OPENCV_DIR
make -j
