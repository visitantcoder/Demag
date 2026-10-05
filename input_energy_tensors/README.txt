OPTIONAL FOLDER
===============

RUN_ME works immediately using the six raw CSV files already included.

If you already have the previously approved CAP-CSDP tensors and want to
avoid rebuilding CAP-CSDP, copy the six MAT files here:

CAP_CSDP_D0_tensor.mat
CAP_CSDP_D10_tensor.mat
CAP_CSDP_D30_tensor.mat
CAP_CSDP_D50_tensor.mat
CAP_CSDP_D70_tensor.mat
CAP_CSDP_D100_tensor.mat

Each MAT file should contain a numeric H x W x 3 tensor, preferably named:
CAP_CSDP_energy_tensor

Then either:
  RUN_ME
(which automatically prefers a complete tensor set)

or:
  RUN_WSCN_ONLY
(which requires the tensor set).
