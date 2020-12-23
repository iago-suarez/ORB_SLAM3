cmake_minimum_required(VERSION 2.8)
project(ORB_SLAM3)

IF(NOT CMAKE_BUILD_TYPE)
  SET(CMAKE_BUILD_TYPE Release)
ENDIF()

MESSAGE("Build type: " ${CMAKE_BUILD_TYPE})

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wdeprecated-declarations -O3 -Wno-deprecated")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wdeprecated-declarations -O3 -Wno-deprecated")
set (CMAKE_CXX_STANDARD 11)
add_definitions(-DCOMPILEDWITHC11)

LIST(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake_modules)

find_package(OpenCV REQUIRED COMPONENTS opencv_core opencv_calib3d opencv_highgui)
if(NOT OpenCV_FOUND)
   find_package(OpenCV 2.4.3 QUIET opencv_core opencv_calib3d)
   if(NOT OpenCV_FOUND)
      message(FATAL_ERROR "OpenCV > 2.4.3 not found.")
   endif()
endif()

MESSAGE("-- OPENCV VERSION: ${OpenCV_VERSION}")

SET(EIGEN3_INCLUDE_DIR ${PROJECT_SOURCE_DIR}/Thirdparty/eigen)

if(ANDROID)
    SET(Boost_VERBOSE True)
    SET(BOOST_VERSION 1_74)
    SET(Boost_INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/Thirdparty/Boost-for-Android/build/out/${ANDROID_ABI}/include/boost-${BOOST_VERSION})
    SET(Boost_LIBRARY_DIRS ${CMAKE_SOURCE_DIR}/Thirdparty/Boost-for-Android/build/out/${ANDROID_ABI}/lib)
    MESSAGE("-- Boost_INCLUDE_DIRS=${Boost_INCLUDE_DIRS}")
    message("-- Boost_LIBRARY_DIRS=${Boost_LIBRARY_DIRS}")
    INCLUDE_DIRECTORIES(${Boost_INCLUDE_DIRS})
    LINK_DIRECTORIES(${Boost_LIBRARY_DIRS})
else()
    find_package(Boost)
    MESSAGE("-- Boost_FOUND: ${Boost_FOUND}")
    MESSAGE("-- Boost_VERSION_STRING: ${Boost_VERSION_STRING}")
    MESSAGE("-- Boost_INCLUDE_DIRS: ${Boost_INCLUDE_DIRS}")
endif(ANDROID)

include_directories(
${PROJECT_SOURCE_DIR}
${PROJECT_SOURCE_DIR}/include
${PROJECT_SOURCE_DIR}/include/CameraModels
${EIGEN3_INCLUDE_DIR}
${Pangolin_INCLUDE_DIRS}
)

add_library(${PROJECT_NAME} SHARED
src/System.cc
src/Tracking.cc
src/LocalMapping.cc
src/LoopClosing.cc
src/ORBextractor.cc
src/ORBmatcher.cc
src/FrameDrawer.cc
src/Converter.cc
src/MapPoint.cc
src/KeyFrame.cc
src/Atlas.cc
src/Map.cc
src/MapDrawer.cc
src/Optimizer.cc
src/PnPsolver.cc
src/Frame.cc
src/KeyFrameDatabase.cc
src/Sim3Solver.cc
src/Initializer.cc
src/Viewer.cc
src/ImuTypes.cc
src/G2oTypes.cc
src/CameraModels/Pinhole.cpp
src/CameraModels/KannalaBrandt8.cpp
src/OptimizableTypes.cpp
src/MLPnPsolver.cpp
src/TwoViewReconstruction.cc)


set(DBoW2_INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/Thirdparty/DBoW2/include)
if(ANDROID)
    set(DBoW2_LIBS ${CMAKE_SOURCE_DIR}/Thirdparty/DBoW2/build-${ANDROID_ABI}/libDBoW2.so)
    set(g2o_LIBS ${CMAKE_SOURCE_DIR}/Thirdparty/g2o/build-${ANDROID_ABI}/libg2o.so)
    set(Pangolin_DIR ${CMAKE_SOURCE_DIR}/Thirdparty/Pangolin/install-${ANDROID_ABI}/lib/cmake/Pangolin)
else(ANDROID)
    set(DBoW2_LIBS ${CMAKE_SOURCE_DIR}/Thirdparty/DBoW2/build/libDBoW2.so)
    set(g2o_LIBS ${CMAKE_SOURCE_DIR}/Thirdparty/g2o/build/libg2o.so)
    set(Pangolin_DIR ${CMAKE_SOURCE_DIR}/Thirdparty/Pangolin/install/lib/cmake/Pangolin)
endif(ANDROID)

MESSAGE("-- DBoW2_LIBS=${DBoW2_LIBS}")
MESSAGE("-- DBoW2_INCLUDE_DIRS=${DBoW2_INCLUDE_DIRS}")
include_directories(${DBoW2_INCLUDE_DIRS})

find_package(Pangolin REQUIRED)
message("-- Pangolin_FOUND=${Pangolin_FOUND}")
message("-- Pangolin_INCLUDE_DIRS=${Pangolin_INCLUDE_DIRS}")
include_directories(${Pangolin_INCLUDE_DIRS})

IF(ANDROID)
    set( BOOST_SERIALIZATION_LIB "${CMAKE_SOURCE_DIR}/Thirdparty/Boost-for-Android/build/out/${ANDROID_ABI}/lib/libboost_serialization-clang-mt-a64-1_74.a")
ELSE()
    set( BOOST_SERIALIZATION_LIB boost_serialization)
ENDIF()
target_link_libraries(${PROJECT_NAME}
${OpenCV_LIBS}
${EIGEN3_LIBS}
${Pangolin_LIBRARIES}
${DBoW2_LIBS}
${g2o_LIBS}
${BOOST_SERIALIZATION_LIB}
)

############################## Executalbes ##############################

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/Examples/RGB-D)
add_executable(rgbd_tum
Examples/RGB-D/rgbd_tum.cc)
target_link_libraries(rgbd_tum ${PROJECT_NAME})


set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/Examples/Stereo)

add_executable(stereo_kitti
Examples/Stereo/stereo_kitti.cc)
target_link_libraries(stereo_kitti ${PROJECT_NAME})

add_executable(stereo_euroc
Examples/Stereo/stereo_euroc.cc)
target_link_libraries(stereo_euroc ${PROJECT_NAME})

add_executable(stereo_tum_vi
Examples/Stereo/stereo_tum_vi.cc)
target_link_libraries(stereo_tum_vi ${PROJECT_NAME})

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/Examples/Monocular)

add_executable(mono_tum
Examples/Monocular/mono_tum.cc)
target_link_libraries(mono_tum ${PROJECT_NAME})

add_executable(mono_kitti
Examples/Monocular/mono_kitti.cc)
target_link_libraries(mono_kitti ${PROJECT_NAME})

add_executable(mono_euroc
Examples/Monocular/mono_euroc.cc)
target_link_libraries(mono_euroc ${PROJECT_NAME})

add_executable(mono_tum_vi
Examples/Monocular/mono_tum_vi.cc)
target_link_libraries(mono_tum_vi ${PROJECT_NAME})


set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/Examples/Monocular-Inertial)

add_executable(mono_inertial_euroc
Examples/Monocular-Inertial/mono_inertial_euroc.cc)
target_link_libraries(mono_inertial_euroc ${PROJECT_NAME})

add_executable(mono_inertial_tum_vi
Examples/Monocular-Inertial/mono_inertial_tum_vi.cc)
target_link_libraries(mono_inertial_tum_vi ${PROJECT_NAME})


set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/Examples/Stereo-Inertial)

add_executable(stereo_inertial_euroc
Examples/Stereo-Inertial/stereo_inertial_euroc.cc)
target_link_libraries(stereo_inertial_euroc ${PROJECT_NAME})


add_executable(stereo_inertial_tum_vi
Examples/Stereo-Inertial/stereo_inertial_tum_vi.cc)
target_link_libraries(stereo_inertial_tum_vi ${PROJECT_NAME})


