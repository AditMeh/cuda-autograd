#include <pybind11/pybind11.h>
#include <pybind11/numpy.h>

namespace py = pybind11;

__global__ void vecaddkernel(double*vec1, double* vec2, double *result){
    int i = threadIdx.x;
    result[i] = vec1[i] + vec2[i]; // vec addition
}

py::array_t<double> vec_add(py::array_t<double> input1, py::array_t<double> input2) {
    py::buffer_info buf1 = input1.request();
    py::buffer_info buf2 = input2.request();

    // Output buffer
    auto result = py::array_t<double>(buf1.size);
    py::buffer_info buf3 = result.request();

    if (buf1.ndim != 1 || buf2.ndim != 1)
        throw std::runtime_error("Number of dimensions must be one");

    if (buf1.size != buf2.size)
        throw std::runtime_error("Input shapes must match");


    double* vec1d; double* vec2d; double* resultd; // the d means device

    int len = buf1.size;

    cudaMalloc((void **) &vec1d, len * sizeof(double));
    cudaMemcpy((void*)vec1d, buf1.ptr, len * sizeof(double), cudaMemcpyHostToDevice);
    cudaMalloc((void **) &vec2d, len * sizeof(double));
    cudaMemcpy(vec2d, buf2.ptr, len * sizeof(double), cudaMemcpyHostToDevice);
    
    cudaMalloc((void **) &resultd, len * sizeof(double));

    dim3 dimBlock(len);
    dim3 dimGrid(1);
    
    vecaddkernel<<<dimGrid, dimBlock>>>(vec1d, vec2d, resultd);
    cudaMemcpy(buf3.ptr, resultd, len * sizeof(double), cudaMemcpyDeviceToHost);

    cudaFree(vec1d); cudaFree(vec2d); cudaFree(resultd);
    return result;
}

PYBIND11_MODULE(vecadd, m) {
    m.def("vec_add", &vec_add, "Add two NumPy arrays");
}