CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

LIST(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

INCLUDE("CxxFlags")
SET(CMAKE_CXX_FLAGS "${STRICT_CXX_FLAGS}")

SET(TinyThreadSource "${CMAKE_SOURCE_DIR}/third-party/tinythreadpp/source")
INCLUDE_DIRECTORIES("${TinyThreadSource}")

SET(InihSource "${CMAKE_SOURCE_DIR}/third-party/inih")
INCLUDE_DIRECTORIES("${CMAKE_SOURCE_DIR}/third-party/inih")

ADD_SUBDIRECTORY("src")
ADD_SUBDIRECTORY("test")
