#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <torch/script.h>
#include <unistd.h>
#include <string>
#include <string>  
#include <iostream> 
#include <sstream>   

#include <vector>

torch::jit::Module model;
std::stringstream printing_buffer;

// Note that you need to keep these alive while you're processing the lists on the Dart side
char *temp_print_buffer_ptr;
float *temp_out_data_ptr;



extern "C" __attribute__((visibility("default"))) __attribute__((used)) void
load_ml_model(const char *model_path) {
    model = torch::jit::load(model_path);
}


extern "C" __attribute__((visibility("default"))) __attribute__((used)) char*
get_printing_buffer_and_clear() {
    const int length = printing_buffer.str().length();

    delete[] temp_print_buffer_ptr;
    temp_print_buffer_ptr = new char[length + 1];
 
    strcpy(temp_print_buffer_ptr, printing_buffer.str().c_str());

    printing_buffer.str("");

    return temp_print_buffer_ptr;
}


extern "C" __attribute__((visibility("default"))) __attribute__((used)) float **
model_inference(float *input_data_ptr) {
    std::vector<torch::jit::IValue> inputs;

    auto options = torch::TensorOptions().dtype(torch::kFloat32);
    auto in_tensor = torch::from_blob(input_data_ptr, {17}, options);
    inputs.push_back(in_tensor);

    auto forward_output = model.forward(inputs);

    printing_buffer << "forward_output.tagKind(): " << forward_output.tagKind()  << std::endl;

    // Note that here I'm only allowing the output to be tensor, but this can be easily changed
    // Also for simplicity I only assume that output tensor has only one dimension
    auto out_tensor = forward_output.toTensor();
    int tensor_lenght = out_tensor.sizes()[0];

    printing_buffer << "out_tensor.sizes(): " << out_tensor.sizes()  << std::endl;

    delete[] temp_out_data_ptr;
    temp_out_data_ptr = new float [tensor_lenght];
    std::memcpy(temp_out_data_ptr, out_tensor.data_ptr<float>(), sizeof(float) *  tensor_lenght );

    // Maybe not so pretty, but you need to somehow return the array with information about number of elements
    float **out_data_with_length = new float *[2];
    float *out_data_length = new float[1];
    out_data_length[0] = tensor_lenght;
    out_data_with_length[0] = temp_out_data_ptr;
    out_data_with_length[1] = out_data_length;

    return out_data_with_length;
}
