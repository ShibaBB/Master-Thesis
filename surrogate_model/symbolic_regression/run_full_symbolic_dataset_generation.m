%% Full Symbolic Dataset Generation Driver
% This driver converts the default teacher dataset into the scalar symbolic
% dataset used by the segment-wise PySR training workflow.

clear;
clc;

script_dir = fileparts(mfilename('fullpath'));
surrogate_root = fileparts(script_dir);

symbolic_dataset_config = struct();
symbolic_dataset_config.teacher_dataset_file = fullfile(surrogate_root, 'data_generation', 'generated_data', 'Wool_surrogate_dataset.mat');
symbolic_dataset_config.output_file = fullfile(script_dir, 'generated_data', 'Wool_symbolic_dataset.mat');

run(fullfile(script_dir, 'generate_symbolic_dataset.m'));
