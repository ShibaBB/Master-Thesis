function config = segmented_dataset_run_config(dataset_run)
%SEGMENTED_DATASET_RUN_CONFIG Resolve the shared dataset paths for segmented SR.

script_dir = fileparts(mfilename('fullpath'));
surrogate_root = fileparts(script_dir);

if nargin < 1 || isempty(dataset_run)
    config_file = fullfile(script_dir, 'dataset_run_config.json');
    if ~exist(config_file, 'file')
        error('Segmented dataset run config not found: %s', config_file);
    end
    config_data = jsondecode(fileread(config_file));
    if ~isfield(config_data, 'default_dataset_run')
        error('dataset_run_config.json is missing default_dataset_run.');
    end
    dataset_run = config_data.default_dataset_run;
end

dataset_run = char(string(dataset_run));
if isempty(regexp(dataset_run, '^[A-Za-z0-9][A-Za-z0-9_-]*$', 'once'))
    error('Invalid dataset run name: %s', dataset_run);
end

config = struct();
config.dataset_run = dataset_run;
config.run_dir = fullfile(surrogate_root, 'datasets', dataset_run);
config.manifest_file = fullfile(config.run_dir, 'dataset_manifest.json');
config.teacher_dataset_file = fullfile(config.run_dir, 'MLP', 'Wool_surrogate_dataset.mat');
config.segmented_dataset_file = fullfile(config.run_dir, 'segmented_SR', 'Wool_symbolic_segmented.mat');
end
