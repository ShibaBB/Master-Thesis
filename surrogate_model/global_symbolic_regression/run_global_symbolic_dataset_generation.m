%% Global Symbolic Dataset Generation Driver
% This driver creates the one-segment scalar symbolic dataset for the
% planned global symbolic-regression model.

clear;
clc;

script_dir = fileparts(mfilename('fullpath'));
surrogate_root = fileparts(script_dir);

symbolic_dataset_config = struct();
symbolic_dataset_config.teacher_dataset_file = fullfile(surrogate_root, 'datasets', 'run1', 'MLP', 'Wool_surrogate_dataset.mat');
symbolic_dataset_config.output_file = fullfile(surrogate_root, 'datasets', 'run1', 'global_SR', 'Wool_symbolic_global.mat');
symbolic_dataset_config.segment_bounds_hz = [100, 2000];
symbolic_dataset_config.segment_names = {'global_100_2000'};

run(fullfile(surrogate_root, 'segmented_symbolic_regression', 'generate_segmented_symbolic_dataset.m'));
