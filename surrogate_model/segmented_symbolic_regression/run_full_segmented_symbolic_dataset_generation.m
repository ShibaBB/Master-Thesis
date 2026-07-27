%% Full Segmented Symbolic Dataset Generation Driver
% This driver converts the default teacher dataset into the scalar segmented
% symbolic dataset used by the segment-wise PySR training workflow.

clear;
clc;

script_dir = fileparts(mfilename('fullpath'));
surrogate_root = fileparts(script_dir);

symbolic_dataset_config = struct();
symbolic_dataset_config.teacher_dataset_file = fullfile(surrogate_root, 'datasets', 'run1', 'MLP', 'Wool_surrogate_dataset.mat');
symbolic_dataset_config.output_file = fullfile(surrogate_root, 'datasets', 'run1', 'segmented_SR', 'Wool_symbolic_segmented.mat');

run(fullfile(script_dir, 'generate_segmented_symbolic_dataset.m'));
