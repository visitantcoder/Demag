%% RUN_WSCN_ONLY
% Optional entry point.
%
% Use this only when you want to keep already generated/approved CAP-CSDP
% tensors unchanged. Put the six files into:
%
%   input_energy_tensors/
%
% Recommended names:
%   CAP_CSDP_D0_tensor.mat
%   CAP_CSDP_D10_tensor.mat
%   CAP_CSDP_D30_tensor.mat
%   CAP_CSDP_D50_tensor.mat
%   CAP_CSDP_D70_tensor.mat
%   CAP_CSDP_D100_tensor.mat
%
% Each MAT file should contain a numeric HxWx3 tensor, preferably named:
%   CAP_CSDP_energy_tensor
%
% Then run:
%   RUN_WSCN_ONLY

clear; clc; close all;

ROOT = fileparts(mfilename('fullpath'));
addpath(fullfile(ROOT,'src'));

run(fullfile(ROOT,'CHECK_REQUIREMENTS.m'));
WSCN_PUBLICATION_PIPELINE(ROOT,'TENSOR_ONLY');
