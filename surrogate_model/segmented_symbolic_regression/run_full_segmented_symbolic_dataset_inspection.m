%% Full Segmented Symbolic Dataset Inspection Driver
% This driver inspects the default scalar segmented symbolic dataset before PySR
% training.

clear;
clc;

script_dir = fileparts(mfilename('fullpath'));

symbolic_inspection_config = struct();
symbolic_inspection_config.dataset_file = fullfile(fileparts(script_dir), 'datasets', 'run1', 'segmented_SR', 'Wool_symbolic_segmented.mat');
symbolic_inspection_config.inspection_name = 'wool_segmented_symbolic_dataset_inspection';

run(fullfile(script_dir, 'inspect_segmented_symbolic_dataset.m'));
