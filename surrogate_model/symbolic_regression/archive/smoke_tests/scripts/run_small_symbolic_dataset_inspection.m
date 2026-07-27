%% Small Symbolic Dataset Inspection Driver
% This driver inspects the small symbolic dataset to validate the symbolic
% data preparation pipeline end to end.

clear;
clc;

script_dir = fileparts(mfilename('fullpath'));

symbolic_inspection_config = struct();
symbolic_inspection_config.dataset_file = fullfile(script_dir, 'generated_data', 'Wool_symbolic_dataset_small.mat');
symbolic_inspection_config.inspection_name = 'wool_symbolic_dataset_inspection_small';

run(fullfile(script_dir, 'inspect_symbolic_dataset.m'));
