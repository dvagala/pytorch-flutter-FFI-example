#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <torch/script.h>
#include <unistd.h>

#include <vector>

torch::jit::Module model;


extern "C" __attribute__((visibility("default"))) __attribute__((used)) int
native_add(int a, int b) {
    return a + b;
}

extern "C" __attribute__((visibility("default"))) __attribute__((used)) void
load_ml_model(const char *model_path) {
    model = torch::jit::load(model_path);
}

extern "C" __attribute__((visibility("default"))) __attribute__((used)) float **
model_inference(float *input_data_ptr) {
    std::vector<torch::jit::IValue> inputs;

    auto options = torch::TensorOptions().dtype(torch::kFloat32);
    auto in_tensor = torch::from_blob(input_data_ptr, {17}, options);
    inputs.push_back(in_tensor);

    auto forward_output = model.forward(inputs);

    // Note that here I'm only allowing the output to be tensor, but this can be easily changed
    // Also for simplicity I only assume that output tensor has only one dimension
    auto out_tensor = forward_output.toTensor();
    auto out_data_ptr = out_tensor.data_ptr<float>();
    auto out_tensor_first_dimemsion_length = out_tensor.sizes()[0];

    // Maybe not so pretty, but you need to somehow return the array with information about number of elements
    float **out_data_with_length = new float *[2];
    float *out_data_length = new float[1];
    out_data_length[0] = out_tensor_first_dimemsion_length;
    out_data_with_length[0] = out_data_length;
    out_data_with_length[1] = out_data_ptr;

    return out_data_with_length;
}
