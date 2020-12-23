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

if(ANDROID)
    set(Boost_VERBOSE True)
    set(BOOST_VERSION 1_74)
    set(BOOST_INCLUDE_DIR ${PROJECT_SOURCE_DIR}/../Boost-for-Android/build/out/${ANDROID_ABI}/include/boost-${BOOST_VERSION})
    message("-- Including Android boost: BOOST_INCLUDE_DIR=${BOOST_INCLUDE_DIR}")
    set(BOOST_LIBS_DIR ${PROJECT_SOURCE_DIR}/../Boost-for-Android/build/out/${ANDROID_ABI}/lib)
    include_directories(${BOOST_INCLUDE_DIR})
endif(ANDROID)

set(LIB_TYPE SHARED)
if(STATIC_LIB)
    set(LIB_TYPE STATIC)
endif(STATIC_LIB)

include_directories(${OpenCV_INCLUDE_DIRS} ${CMAKE_SOURCE_DIR}/include)
add_library(DBoW2 ${LIB_TYPE} ${SRCS_DBOW2})
target_link_libraries(DBoW2 ${OpenCV_LIBS})

