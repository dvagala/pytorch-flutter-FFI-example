cmake_minimum_required(VERSION 3.4.1)  # for example
project(native_pytorch)

set(CMAKE_CXX_STANDARD 14)  # needed for libtorch

add_library( native_pytorch

             # Sets the library as a shared library.
             SHARED

             # Provides a relative path to your source file(s).
             ../ios/Classes/native_pytorch.cpp )