#pragma once

// @generated by torchgen/gen.py from Function.h

#include <ATen/Context.h>
#include <ATen/DeviceGuard.h>
#include <ATen/TensorUtils.h>
#include <ATen/TracerMode.h>
#include <ATen/core/Generator.h>
#include <ATen/core/Reduction.h>
#include <ATen/core/Tensor.h>
#include <c10/core/Scalar.h>
#include <c10/core/Storage.h>
#include <c10/core/TensorOptions.h>
#include <c10/util/Deprecated.h>
#include <c10/util/Optional.h>



#include <ATen/ops/_foreach_norm_ops.h>

namespace at {


// aten::_foreach_norm.Scalar(Tensor[] self, Scalar ord=2) -> Tensor[]
inline ::std::vector<at::Tensor> _foreach_norm(at::TensorList self, const at::Scalar & ord=2) {
    return at::_ops::_foreach_norm_Scalar::call(self, ord);
}

// aten::_foreach_norm.Scalar_out(Tensor[] self, Scalar ord=2, *, Tensor(a!)[] out) -> ()
inline void _foreach_norm_out(at::TensorList out, at::TensorList self, const at::Scalar & ord=2) {
    return at::_ops::_foreach_norm_Scalar_out::call(self, ord, out);
}

// aten::_foreach_norm.Scalar_out(Tensor[] self, Scalar ord=2, *, Tensor(a!)[] out) -> ()
inline void _foreach_norm_outf(at::TensorList self, const at::Scalar & ord, at::TensorList out) {
    return at::_ops::_foreach_norm_Scalar_out::call(self, ord, out);
}

}