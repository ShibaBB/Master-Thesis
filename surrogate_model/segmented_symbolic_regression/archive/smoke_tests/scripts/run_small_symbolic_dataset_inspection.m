%% Small Symbolic Dataset Inspection Driver
% This driver inspects the small symbolic dataset to validate the symbolic
% data preparation pipeline end to end.

clear;
clc;

script_dir = fileparts(mfilename('fullpath'));
smoke_root = fileparts(script_dir);
symbolic_root = fileparts(fileparts(smoke_root));

symbolic_inspection_config = struct();
symbolic_inspection_config.dataset_file = fullfile(smoke_root, 'generated_data', 'Wool_symbolic_dataset_small.mat');
symbolic_inspection_config.inspection_name = 'wool_segmented_symbolic_dataset_inspection_small';

run(fullfile(symbolic_root, 'inspect_segmented_symbolic_dataset.m'));
