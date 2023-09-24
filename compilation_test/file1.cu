#include <stdio.h>
#include <pybind11/pybind11.h>

namespace py = pybind11;

__global__ void mykernel(){
  printf("Hello from mykernel\n");
}

void hello(){
  mykernel<<<1,1>>>();
  cudaDeviceSynchronize();
}


PYBIND11_MODULE(example, m) {
    m.doc() = "pybind11 example plugin"; // optional module docstring
    m.def("hello", &hello, "A function that adds two numbers");
}