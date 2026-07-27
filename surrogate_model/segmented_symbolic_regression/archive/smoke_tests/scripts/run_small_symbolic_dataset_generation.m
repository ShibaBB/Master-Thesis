%% Small Symbolic Dataset Generation Driver
% This driver converts the existing small teacher dataset into a scalar
% symbolic dataset for smoke testing the symbolic workflow.

clear;
clc;

script_dir = fileparts(mfilename('fullpath'));
smoke_root = fileparts(script_dir);
symbolic_root = fileparts(fileparts(smoke_root));

symbolic_dataset_config = struct();
symbolic_dataset_config.teacher_dataset_file = fullfile(smoke_root, 'data_generation', 'generated_data', 'Wool_surrogate_dataset_small.mat');
symbolic_dataset_config.output_file = fullfile(smoke_root, 'generated_data', 'Wool_symbolic_dataset_small.mat');

run(fullfile(symbolic_root, 'generate_segmented_symbolic_dataset.m'));
