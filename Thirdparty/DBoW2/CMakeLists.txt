cmake_minimum_required(VERSION 2.8)
project(DBoW2)

#set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS}  -Wall  -O3 -march=native ")
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall  -O3 -march=native")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS}  -Wall  -O3")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall  -O3")

set(HDRS_DBOW2
  DBoW2/BowVector.h
  DBoW2/FORB.h 
  DBoW2/FClass.h       
  DBoW2/FeatureVector.h
  DBoW2/ScoringObject.h   
  DBoW2/TemplatedVocabulary.h)
set(SRCS_DBOW2
  DBoW2/BowVector.cpp
  DBoW2/FORB.cpp      
  DBoW2/FeatureVector.cpp
  DBoW2/ScoringObject.cpp)

set(HDRS_DUTILS
  DUtils/Random.h
  DUtils/Timestamp.h)
set(SRCS_DUTILS
  DUtils/Random.cpp
  DUtils/Timestamp.cpp)

if(ANDROID)
   SET(Boost_VERBOSE True)
   SET(BOOST_VERSION 1_74)
   SET(BOOST_INCLUDE_DIR ${CMAKE_SOURCE_DIR}/../Boost-for-Android/build/out/${ANDROID_ABI}/include/boost-${BOOST_VERSION})
   SET(BOOST_LIBS_DIR ${CMAKE_SOURCE_DIR}/../Boost-for-Android/build/out/${ANDROID_ABI}/lib)
   INCLUDE_DIRECTORIES(${BOOST_INCLUDE_DIR})
endif(ANDROID)

find_package(OpenCV)
if(NOT OpenCV_FOUND)
   find_package(OpenCV 2.4.3 QUIET)
   if(NOT OpenCV_FOUND)
      message(FATAL_ERROR "OpenCV > 2.4.3 not found.")
   endif()
endif()
MESSAGE("OPENCV VERSION: ${OpenCV_VERSION}")

IF(ANDROID)
   set(LIBRARY_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/lib/${ANDROID_ABI})
ELSE(ANDROID)
set(LIBRARY_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/lib)
ENDIF(ANDROID)

include_directories(${OpenCV_INCLUDE_DIRS})
add_library(DBoW2 SHARED ${SRCS_DBOW2} ${SRCS_DUTILS})
target_link_libraries(DBoW2 ${OpenCV_LIBS})

