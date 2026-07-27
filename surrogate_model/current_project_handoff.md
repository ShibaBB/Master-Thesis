# Surrogate Model Project Handoff

This handoff describes the current state of `Fibers/surrogate_model`: model
branches, run logic, shared dataset structure, artifact layout, and Git/GitHub
sync policy. It is intended to give a new conversation enough context to work
on the project without first rediscovering the repository.

## Project Goal

The project compares lightweight surrogate models for a MATLAB JCAL acoustic
absorption teacher model.

Target mapping:

```text
material/acoustic parameters + frequency -> absorption coefficient alpha
```

The horizontal comparison is planned across three surrogate branches:

```text
1. MLP
2. segmented symbolic regression
3. global symbolic regression
```

All three models must use data from the same dataset run for a fair comparison.
The current shared dataset run is:

```text
surrogate_model/datasets/run1
```

## Repository Location And Remote

Current local workspace:

```text
C:/Users/liuzi/OneDrive/Master Thesis/Fibers
```

GitHub remote:

```text
https://github.com/ShibaBB/Master-Thesis
```

Current branch:

```text
main
```

The user is considering moving the working clone to a local non-OneDrive path,
for example:

```text
C:/Projects/Fibers
```

That is recommended for long PySR runs because OneDrive can lock or delay
frequently written PySR files.

## Top-Level Structure

Current relevant project layout:

```text
surrogate_model/
  README.md
  current_project_handoff.md
  data_generation/
  datasets/
    run1/
      dataset_manifest.json
      MLP/
        Wool_surrogate_dataset.mat
      segmented_SR/
        Wool_symbolic_segmented.mat
      global_SR/
        Wool_symbolic_global.mat
  MLP/
  segmented_symbolic_regression/
  global_symbolic_regression/
  docs/
```

Directory roles:

```text
data_generation/
  Shared MATLAB teacher dataset generation/inspection scripts.

datasets/
  Shared dataset runs. Horizontal model comparisons must use data from the
  same run folder.

MLP/
  MLP baseline training code, MLP notes, and MLP artifacts.

segmented_symbolic_regression/
  Active segmented symbolic regression branch. Uses PySR and trains separate
  formulas on predefined frequency segments.

global_symbolic_regression/
  Planned global symbolic regression branch. Dataset generation and inspection
  exist; formal PySR training/evaluation is not implemented yet.

docs/
  Background notes, original task descriptions, and strategy/reference files.
```

## Dataset Run Structure

The current dataset run is `run1`.

Manifest:

```text
surrogate_model/datasets/run1/dataset_manifest.json
```

Run contents:

```text
surrogate_model/datasets/run1/MLP/Wool_surrogate_dataset.mat
surrogate_model/datasets/run1/segmented_SR/Wool_symbolic_segmented.mat
surrogate_model/datasets/run1/global_SR/Wool_symbolic_global.mat
```

The comparison rule is:

```text
Use only datasets within the same run_id for horizontal comparison.
```

### Teacher / MLP Dataset

Teacher dataset file:

```text
surrogate_model/datasets/run1/MLP/Wool_surrogate_dataset.mat
```

Format:

```text
X: 1000 x 7
Y: 1000 x 64
```

Inputs:

```text
phi, h, sigma, alpha_infinity, lambda, lambda_prime, k0_prime
```

Output:

```text
alpha curve on freq_grid
```

Frequency range:

```text
100-2000 Hz, 64 frequency points
```

### Segmented SR Dataset

Segmented SR dataset file:

```text
surrogate_model/datasets/run1/segmented_SR/Wool_symbolic_segmented.mat
```

Format:

```text
scalar_frequency_expanded
```

Inputs:

```text
phi, h, sigma, alpha_infinity, lambda, lambda_prime, k0_prime, f
```

Output:

```text
alpha
```

Size:

```text
64000 scalar samples
```

Current frequency segments:

```text
low_100_700        100-700 Hz
midlow_700_1000    700-1000 Hz
midhigh_1000_1300  1000-1300 Hz
highlow_1300_1650  1300-1650 Hz
high_1650_2000     1650-2000 Hz
```

### Global SR Dataset

Global SR dataset file:

```text
surrogate_model/datasets/run1/global_SR/Wool_symbolic_global.mat
```

Format:

```text
scalar_frequency_expanded
```

Inputs:

```text
phi, h, sigma, alpha_infinity, lambda, lambda_prime, k0_prime, f
```

Output:

```text
alpha
```

Size:

```text
64000 scalar samples
```

Current global segment:

```text
global_100_2000    100-2000 Hz
```

## Teacher Model Logic

The MATLAB teacher dataset is generated from the JCAL acoustic model. The
important conceptual chain is:

```text
getFluidProperties
-> getFiberConstraints
-> jcal_reflection
-> generate_teacher_dataset
```

Current material setup:

```text
material: Wool
porosity case: 92
frequency range: 100-2000 Hz
```

The MLP uses the curve-format teacher data directly. The symbolic regression
branches use scalar frequency-expanded versions derived from the same teacher
dataset.

## MLP Branch State

Branch directory:

```text
surrogate_model/MLP
```

Current status:

```text
Only a small baseline artifact exists.
It is not yet a formal horizontal comparison result.
```

Known artifact:

```text
surrogate_model/MLP/artifacts/wool_baseline_mlp_small
```

The MLP branch should use:

```text
surrogate_model/datasets/run1/MLP/Wool_surrogate_dataset.mat
```

## Segmented Symbolic Regression Branch State

Branch directory:

```text
surrogate_model/segmented_symbolic_regression
```

This is the most mature model branch. It trains separate PySR equations for
five frequency segments.

Important entry points:

```text
run_full_segmented_symbolic_dataset_generation.m
run_full_segmented_symbolic_dataset_inspection.m
train_segmented_symbolic_models.py
evaluate_segmented_symbolic_candidates.py
```

Current default output roots:

```text
artifacts/wool_segmented_symbolic_pysr_runs
artifacts/wool_segmented_symbolic_candidate_evaluation_runs
artifacts/wool_segmented_symbolic_dataset_inspection
```

Archived old pre-rename artifacts are grouped here:

```text
artifacts/archived_pre_segmented_rename_artifacts
```

Those archived folders are retained for traceability only. Current scripts do
not write to:

```text
wool_symbolic_pysr_segments_runs
wool_symbolic_candidate_evaluation_runs
wool_symbolic_dataset_inspection
```

### Latest Segmented SR Dataset Generation

The current segmented SR dataset in `run1` has been generated successfully:

```text
surrogate_model/datasets/run1/segmented_SR/Wool_symbolic_segmented.mat
```

### Latest Full Segmented SR Training

Latest completed full segmented SR training run:

```text
surrogate_model/segmented_symbolic_regression/artifacts/wool_segmented_symbolic_pysr_runs/20260727_130534_iter100_pop12_ps100_size28_allrows_run1_iter100_pop12_ps100_size28_allrows_serial
```

Configuration:

```text
niterations = 100
populations = 12
population_size = 100
maxsize = 28
rows used = all 64000 scalar samples
parallelism = serial
```

The `serial` setting was used because writing PySR outputs directly in a
OneDrive-synced directory previously caused a `hall_of_fame.csv` permission
error. The successful run was written first to a local temp path and then
copied back into the project artifact folder.

Training summary:

```text
segment              complexity   test_rmse   test_mae   test_r2
low_100_700          21           0.019665    0.014653   0.984641
midlow_700_1000       7           0.042303    0.032247   0.548369
midhigh_1000_1300    15           0.036071    0.024451   0.687001
highlow_1300_1650    10           0.033177    0.023955   0.819488
high_1650_2000        9           0.021833    0.014774   0.928872
```

### Latest Segmented SR Evaluation

Latest evaluation run:

```text
surrogate_model/segmented_symbolic_regression/artifacts/wool_segmented_symbolic_candidate_evaluation_runs/20260727_134601_20260727_130534_iter100_pop12_ps100_size28_allrows_run1_iter100_pop12_ps100_size28_allrows_serial_max_complexity
```

Selection rule:

```text
max_complexity = 16
```

Selected candidates:

```text
low_100_700          complexity 12
midlow_700_1000      complexity 11
midhigh_1000_1300    complexity 12
highlow_1300_1650    complexity 11
high_1650_2000       complexity 11
```

Overall selected-formula metrics:

```text
RMSE          0.0285096442
MAE           0.0198104144
max_abs_error 0.2480225671
R2            0.9875635954
```

This `max_complexity=16` evaluation is the current recommended segmented SR
result for interpretation and reporting.

## Global Symbolic Regression Branch State

Branch directory:

```text
surrogate_model/global_symbolic_regression
```

Current status:

```text
Dataset generation exists.
Dataset inspection exists.
Formal global PySR training/evaluation is not implemented yet.
```

Important entry points:

```text
run_global_symbolic_dataset_generation.m
run_global_symbolic_dataset_inspection.m
```

Current global dataset:

```text
surrogate_model/datasets/run1/global_SR/Wool_symbolic_global.mat
```

Current global inspection artifact:

```text
surrogate_model/global_symbolic_regression/artifacts/wool_symbolic_global_dataset_inspection
```

The global inspection driver reuses the segmented inspection script but now
explicitly overrides the output directory so global artifacts stay under:

```text
surrogate_model/global_symbolic_regression/artifacts
```

## Current Artifact Layout

Segmented SR current artifact roots:

```text
surrogate_model/segmented_symbolic_regression/artifacts/
  archived_pre_segmented_rename_artifacts/
  wool_segmented_symbolic_candidate_evaluation_runs/
  wool_segmented_symbolic_pysr_runs/
```

If segmented dataset inspection is run again, this current-name folder may also
appear:

```text
surrogate_model/segmented_symbolic_regression/artifacts/wool_segmented_symbolic_dataset_inspection
```

Global SR current artifact root:

```text
surrogate_model/global_symbolic_regression/artifacts/wool_symbolic_global_dataset_inspection
```

MLP current known artifact:

```text
surrogate_model/MLP/artifacts/wool_baseline_mlp_small
```

## Run Logic

A full fair comparison should use only one dataset run at a time. For the
current project state that means all model branches should read from:

```text
surrogate_model/datasets/run1
```

Current data generation sequence used successfully:

```text
1. Generate MLP teacher curve data:
   surrogate_model/data_generation/generate_teacher_dataset.m

2. Generate segmented SR scalar data:
   surrogate_model/segmented_symbolic_regression/run_full_segmented_symbolic_dataset_generation.m

3. Generate global SR scalar data:
   surrogate_model/global_symbolic_regression/run_global_symbolic_dataset_generation.m
```

Current segmented SR training/evaluation sequence:

```text
1. train_segmented_symbolic_models.py
   --niterations 100
   --populations 12
   --population-size 100
   --maxsize 28

2. evaluate_segmented_symbolic_candidates.py
   --selection-rule max_complexity
   --max-complexity 16
```

When training on a OneDrive-synced project folder, prefer writing PySR output
to a local scratch path first, then copying curated artifacts back into the
repo. This avoids OneDrive file locking and sync delays.

## Git And GitHub Sync Policy

Recommended working mode for two computers:

```text
Use a local, non-OneDrive clone on each computer.
Use GitHub to sync code, shared datasets, and analysis-ready artifacts.
Do not use Git as a dump for transient PySR training state.
```

Before starting work on either computer:

```powershell
git pull
```

After a successful training/evaluation run:

```powershell
git status
git add <code changes> <dataset/run manifest if changed> <analysis-ready artifacts>
git commit -m "Add segmented SR run ..."
git push
```

The other computer should then run:

```powershell
git pull
```

Files that should be committed when another computer needs to analyze a run
without retraining:

```text
segment_model_summary.csv
segment_model_summary.json
training_metadata.json
*_best_equation.json
equations/*.csv
candidate_metrics.csv
selected_candidates.csv
selected_combination_summary.json
figures/*.png
```

Files that should normally stay out of Git:

```text
.venv/
.venv_py311/
__pycache__/
pysr_runs/**/checkpoint.pkl
pysr_runs/**/*.bak
local scratch/tmp output folders
```

`models/*.pkl` are intentionally not ignored. Commit them only when another
computer needs to load PySR model objects directly. Most analysis should work
from:

```text
equations/*.csv
*_best_equation.json
candidate_metrics.csv
selected_candidates.csv
selected_combination_summary.json
```

`pysr_runs/**/hall_of_fame.csv` is also intentionally not globally ignored, but
the preferred portable candidate table is `equations/*.csv`. Commit raw
`hall_of_fame.csv` files only if a specific follow-up requires PySR's raw
output.

Current `.gitignore` policy ignores transient environments, Python caches,
PySR checkpoints, PySR `.bak` files, and local scratch/tmp folders while keeping
analysis-ready artifacts visible to Git.

## Important Caveats

The current workspace still has many unstaged/untracked changes because the
segmented symbolic regression branch was renamed from the old
`symbolic_regression` name and artifacts were reorganized. Do not use
destructive Git commands such as `git reset --hard` or `git checkout --` unless
the user explicitly requests it.

The old folder name:

```text
surrogate_model/symbolic_regression
```

has been replaced by:

```text
surrogate_model/segmented_symbolic_regression
```

Global SR should remain separate under:

```text
surrogate_model/global_symbolic_regression
```

Current segmented SR is mature enough for reporting-level inspection. Global
SR and MLP are not yet at the same formal comparison maturity.
