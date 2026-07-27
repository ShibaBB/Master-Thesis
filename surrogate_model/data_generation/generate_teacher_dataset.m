%% Surrogate Dataset Generation
% This script generates training data for the first surrogate-model baseline.
% The current version is configured for Wool and starts from porosity 92,
% while keeping the workflow compatible with porosities 92 to 99.

clearvars -except surrogate_dataset_config;
clc;

script_dir = fileparts(mfilename('fullpath'));
surrogate_root = fileparts(script_dir);
project_root = fileparts(surrogate_root);
original_dir = pwd;
cleanup_obj = onCleanup(@() cd(original_dir)); %#ok<NASGU>
cd(project_root);

%% Configuration
fiberfolder = 'Wool';

available_porosityfolders = {'92', '93', '94', '95', '96', '97', '98', '99'};
selected_porosityfolders = {'92'};

freq_min = 100;
freq_max = 2000;
n_freq = 64;

n_samples = 1000;
sampling_method = 'lhs';
random_seed = 42;

output_dir = fullfile(surrogate_root, 'datasets', 'run1', 'MLP');
output_file = fullfile(output_dir, sprintf('%s_surrogate_dataset.mat', fiberfolder));

if exist('surrogate_dataset_config', 'var')
    if isfield(surrogate_dataset_config, 'fiberfolder'), fiberfolder = surrogate_dataset_config.fiberfolder; end
    if isfield(surrogate_dataset_config, 'available_porosityfolders'), available_porosityfolders = surrogate_dataset_config.available_porosityfolders; end
    if isfield(surrogate_dataset_config, 'selected_porosityfolders'), selected_porosityfolders = surrogate_dataset_config.selected_porosityfolders; end
    if isfield(surrogate_dataset_config, 'freq_min'), freq_min = surrogate_dataset_config.freq_min; end
    if isfield(surrogate_dataset_config, 'freq_max'), freq_max = surrogate_dataset_config.freq_max; end
    if isfield(surrogate_dataset_config, 'n_freq'), n_freq = surrogate_dataset_config.n_freq; end
    if isfield(surrogate_dataset_config, 'n_samples'), n_samples = surrogate_dataset_config.n_samples; end
    if isfield(surrogate_dataset_config, 'sampling_method'), sampling_method = surrogate_dataset_config.sampling_method; end
    if isfield(surrogate_dataset_config, 'random_seed'), random_seed = surrogate_dataset_config.random_seed; end
    if isfield(surrogate_dataset_config, 'output_dir'), output_dir = surrogate_dataset_config.output_dir; end
    if isfield(surrogate_dataset_config, 'output_file'), output_file = surrogate_dataset_config.output_file; end
end

%% Validate configuration
if ~all(ismember(selected_porosityfolders, available_porosityfolders))
    error('selected_porosityfolders must be chosen from 92 to 99.');
end

rng(random_seed);
freq_grid = linspace(freq_min, freq_max, n_freq);

%% Prepare storage
num_porosity_cases = numel(selected_porosityfolders);
samples_per_porosity = floor(n_samples / num_porosity_cases);
remainder_samples = mod(n_samples, num_porosity_cases);
samples_per_case = samples_per_porosity * ones(num_porosity_cases, 1);
samples_per_case(1:remainder_samples) = samples_per_case(1:remainder_samples) + 1;

X = zeros(n_samples, 7);
Y = zeros(n_samples, n_freq);

sample_metadata = struct( ...
    'fiberfolder', cell(n_samples, 1), ...
    'porosityfolder', cell(n_samples, 1), ...
    'thickness_mm', zeros(n_samples, 1), ...
    'air_temperature_K', zeros(n_samples, 1), ...
    'pressure_Pa', zeros(n_samples, 1), ...
    'relative_humidity', zeros(n_samples, 1));

parameter_names = {'phi', 'h', 'sigma', 'alpha_infinity', 'lambda', 'lambda_prime', 'k0_prime'};
target_name = 'alpha';

%% Generate dataset
row_start = 1;

for p_idx = 1:num_porosity_cases
    porosityfolder = selected_porosityfolders{p_idx};
    phi = str2double(porosityfolder) / 100;
    n_case = samples_per_case(p_idx);

    [thickness, temperature_K, pressure, rel_humidity, density_humid_air, ~, ~, eta, gamma, c, ~, Pr] = ...
        getFluidProperties(fiberfolder, porosityfolder);

    h = thickness * 1e-3;

    airProperties = struct();
    airProperties.density_humid_air = density_humid_air;
    airProperties.speed_of_sound = c;
    airProperties.impedance = density_humid_air * c;
    airProperties.eta = eta;
    airProperties.gamma = gamma;
    airProperties.Pr = Pr;
    airProperties.pressure = pressure;

    [lb_full, ub_full] = getFiberConstraints(fiberfolder, phi, airProperties);
    lb = lb_full(1:5);
    ub = ub_full(1:5);

    param_samples = sample_parameter_space(n_case, lb, ub, sampling_method);

    row_end = row_start + n_case - 1;

    for local_idx = 1:n_case
        sigma = param_samples(local_idx, 1);
        alpha_infinity = param_samples(local_idx, 2);
        lambda = param_samples(local_idx, 3);
        lambda_prime = param_samples(local_idx, 4);
        k0_prime = param_samples(local_idx, 5);

        [~, ~, alpha, ~, ~, ~, ~] = jcal_reflection( ...
            h, phi, sigma, alpha_infinity, lambda, lambda_prime, k0_prime, freq_grid, airProperties);

        global_idx = row_start + local_idx - 1;

        X(global_idx, :) = [phi, h, sigma, alpha_infinity, lambda, lambda_prime, k0_prime];
        Y(global_idx, :) = alpha(:).';

        sample_metadata(global_idx).fiberfolder = fiberfolder;
        sample_metadata(global_idx).porosityfolder = porosityfolder;
        sample_metadata(global_idx).thickness_mm = thickness;
        sample_metadata(global_idx).air_temperature_K = temperature_K;
        sample_metadata(global_idx).pressure_Pa = pressure;
        sample_metadata(global_idx).relative_humidity = rel_humidity;
    end

    fprintf('Generated %d samples for %s porosity %s.\n', n_case, fiberfolder, porosityfolder);
    row_start = row_end + 1;
end

%% Save dataset
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

dataset_info = struct();
dataset_info.fiberfolder = fiberfolder;
dataset_info.selected_porosityfolders = selected_porosityfolders;
dataset_info.available_porosityfolders = available_porosityfolders;
dataset_info.freq_min = freq_min;
dataset_info.freq_max = freq_max;
dataset_info.n_freq = n_freq;
dataset_info.freq_grid = freq_grid;
dataset_info.n_samples = n_samples;
dataset_info.samples_per_case = samples_per_case;
dataset_info.sampling_method = sampling_method;
dataset_info.random_seed = random_seed;
dataset_info.parameter_names = parameter_names;
dataset_info.target_name = target_name;

save(output_file, 'X', 'Y', 'freq_grid', 'dataset_info', 'sample_metadata');

fprintf('Saved dataset to %s\n', output_file);

%% Local functions
function samples = sample_parameter_space(n_samples, lb, ub, sampling_method)
    n_dims = numel(lb);

    switch lower(sampling_method)
        case 'lhs'
            if exist('lhsdesign', 'file') == 2
                unit_samples = lhsdesign(n_samples, n_dims, 'criterion', 'maximin', 'iterations', 50);
            else
                error(['sampling_method is set to ''lhs'', but lhsdesign is not available. ', ...
                       'Install the required MATLAB functionality or switch sampling_method to ''random''.']);
            end
        case 'random'
            unit_samples = rand(n_samples, n_dims);
        otherwise
            error('Unsupported sampling_method: %s', sampling_method);
    end

    samples = lb + unit_samples .* (ub - lb);
end
