%% Global Symbolic Dataset Inspection Driver
% This driver inspects the one-segment scalar symbolic dataset for the
% planned global symbolic-regression model.

clear;
clc;

script_dir = fileparts(mfilename('fullpath'));
surrogate_root = fileparts(script_dir);

symbolic_inspection_config = struct();
symbolic_inspection_config.dataset_file = fullfile(surrogate_root, 'datasets', 'run1', 'global_SR', 'Wool_symbolic_global.mat');
symbolic_inspection_config.inspection_name = 'wool_symbolic_global_dataset_inspection';

run(fullfile(surrogate_root, 'symbolic_regression', 'inspect_symbolic_dataset.m'));
