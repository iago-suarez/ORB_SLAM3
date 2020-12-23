cmake_minimum_required(VERSION 2.8)
project(DBoW2)

#set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS}  -Wall  -O3 -march=native ")
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall  -O3 -march=native")

set(SRCS_DBOW2
        lib/BowVector.cpp
        lib/FORB.cpp
        lib/FeatureVector.cpp
        lib/ScoringObject.cpp
        lib/Random.cpp
        lib/Timestamp.cpp)

find_package(OpenCV 4 REQUIRED)

IF(ANDROID)
    set(Boost_DEBUG TRUE)
    set(Boost_COMPILER clang)
    set(Boost_USE_STATIC_LIBS TRUE)
    set(BOOST_OUT_CMAKE_DIR ${CMAKE_SOURCE_DIR}/../Boost-for-Android/build/out/${ANDROID_ABI}/lib/cmake)
    set(Boost_DIR ${BOOST_OUT_CMAKE_DIR}/Boost-1.74.0)
    set(boost_headers_DIR ${BOOST_OUT_CMAKE_DIR}/boost_headers-1.74.0)
    set(boost_serialization_DIR ${BOOST_OUT_CMAKE_DIR}/boost_serialization-1.74.0)
endif()

find_package(Boost COMPONENTS serialization)
message("-- Boost_FOUND=${Boost_FOUND}")
message("-- Boost_LIBRARIES=${Boost_LIBRARIES}")
message("-- Boost_INCLUDE_DIRS=${Boost_INCLUDE_DIRS}")
include_directories(${Boost_INCLUDE_DIRS})

set(LIB_TYPE SHARED)
if(STATIC_LIB)
    set(LIB_TYPE STATIC)
endif(STATIC_LIB)

include_directories(${OpenCV_INCLUDE_DIRS} ${CMAKE_SOURCE_DIR}/include)
add_library(DBoW2 ${LIB_TYPE} ${SRCS_DBOW2})
target_link_libraries(DBoW2 ${OpenCV_LIBS})

