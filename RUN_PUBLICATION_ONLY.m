%% RUN_PUBLICATION_ONLY
% Generate only CAP-CSDP + WSCN publication/PPT figures.

clear; clc; close all;

ROOT = fileparts(mfilename('fullpath'));
addpath(fullfile(ROOT,'src'));

run(fullfile(ROOT,'CHECK_REQUIREMENTS.m'));
WSCN_PUBLICATION_PIPELINE(ROOT,'AUTO');
