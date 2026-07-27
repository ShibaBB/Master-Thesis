%% Full Symbolic Dataset Inspection Driver
% This driver inspects the default scalar symbolic dataset before PySR
% training.

clear;
clc;

script_dir = fileparts(mfilename('fullpath'));

symbolic_inspection_config = struct();
symbolic_inspection_config.dataset_file = fullfile(script_dir, 'generated_data', 'Wool_symbolic_dataset.mat');
symbolic_inspection_config.inspection_name = 'wool_symbolic_dataset_inspection';

run(fullfile(script_dir, 'inspect_symbolic_dataset.m'));
