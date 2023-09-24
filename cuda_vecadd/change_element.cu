#include <pybind11/pybind11.h>
#include <pybind11/numpy.h>
#include <iostream>
namespace py = pybind11;

// __global__ void matmulkernel(float*vec1, float* vec2, float *result){
//     int i = threadIdx.x;
//     result[i] = vec1[i] + vec2[i]; // vec addition
// }

void change_element(py::array_t<double> input1) {
    py::buffer_info buf1 = input1.request();

    if (buf1.ndim != 1)
        throw std::runtime_error("Number of dimensions must be one");

    // std::cout << buf1.size << std::endl;
    double *ptr1 =  reinterpret_cast<double*>(buf1.ptr);

    ptr1[0] = 30;
}

PYBIND11_MODULE(change_element, m) {
    m.def("change_element", &change_element, "Add two NumPy arrays");
}