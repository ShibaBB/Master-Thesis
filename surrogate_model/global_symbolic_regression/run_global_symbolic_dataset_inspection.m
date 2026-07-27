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
symbolic_inspection_config.artifacts_dir = fullfile(script_dir, 'artifacts', symbolic_inspection_config.inspection_name);
symbolic_inspection_config.figures_dir = fullfile(symbolic_inspection_config.artifacts_dir, 'figures');

run(fullfile(surrogate_root, 'segmented_symbolic_regression', 'inspect_segmented_symbolic_dataset.m'));
