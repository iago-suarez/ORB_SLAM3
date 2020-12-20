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

find_package(OpenCV 3.0 QUIET)
if(NOT OpenCV_FOUND)
   find_package(OpenCV 2.4.3 QUIET)
   if(NOT OpenCV_FOUND)
      message(FATAL_ERROR "OpenCV > 2.4.3 not found.")
   endif()
endif()

include_directories(${OpenCV_INCLUDE_DIRS} ${CMAKE_SOURCE_DIR}/include)
add_library(DBoW2 SHARED ${SRCS_DBOW2})
target_link_libraries(DBoW2 ${OpenCV_LIBS})

