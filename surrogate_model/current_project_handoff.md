# Surrogate Model Project Handoff

This handoff describes the current state of `surrogate_model`: model branches,
run logic, shared dataset structure, artifact layout, and Git/GitHub sync
policy. It is intended to give a new conversation enough context to continue
work without rediscovering the repository.

## Project Goal

The project compares surrogate models for a MATLAB JCAL acoustic absorption
teacher model.

Target mapping:

```text
material/acoustic parameters + frequency -> absorption coefficient alpha
```

The planned horizontal comparison has three model branches:

```text
1. MLP
2. segmented symbolic regression
3. global symbolic regression
```

All three branches must use data from the same dataset run for a fair
comparison. The current shared dataset run is now:

```text
surrogate_model/datasets/run2
```

`run1` remains in the repository as the earlier baseline dataset run. Do not
mix run1-trained models with run2-trained models in one horizontal comparison.

## Repository Location And Remote

The active local working copy has been moved off OneDrive. The current intended
workspace is:

```text
C:/MasterThesis_Project
```

GitHub remote:

```text
https://github.com/ShibaBB/Master-Thesis
```

Current working branch as last verified on 2026-08-03:

```text
agent/add-segmented-evaluation
```

The repository default branch remains `main`. The current working branch adds
the latest formal segmented SR evaluation and is published in draft PR #1:

```text
https://github.com/ShibaBB/Master-Thesis/pull/1
```

Current synchronization logic:

```text
Each computer keeps its own local hard-drive clone.
Training and analysis are run from the local clone, not from OneDrive.
GitHub is used to synchronize code, shared datasets, and analysis-ready
artifacts between computers.
Only one computer should train/write/push a given run at a time.
```

OneDrive is no longer part of the intended training workflow. This avoids file
locking, delayed sync, and slow frequent writes during PySR runs.

## Top-Level Structure

Relevant project layout:

```text
surrogate_model/
  README.md
  current_project_handoff.md
  data_generation/
  datasets/
    run1/
      historical baseline dataset run
    run2/
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
  Shared MATLAB teacher dataset generation and inspection scripts.

datasets/
  Shared dataset runs. Horizontal comparisons must use files from the same
  run folder.

MLP/
  MLP baseline code, notes, and MLP artifacts.

segmented_symbolic_regression/
  Active segmented symbolic regression branch. Uses PySR and trains separate
  formulas on predefined frequency segments.

global_symbolic_regression/
  Global symbolic regression branch. Fits and evaluates one PySR formula over
  the full 100-2000 Hz range.

docs/
  Background notes, original task descriptions, and strategy/reference files.
```

## Dataset Run Structure

The current dataset run is `run2`. It was generated successfully on 2026-08-03
with the same Wool/porosity/frequency configuration as run1, but with LHS
sampling seed `43` instead of run1's seed `42`. The different seed makes run2 a
new teacher sample rather than a byte-for-byte copy of run1.

Manifest:

```text
surrogate_model/datasets/run2/dataset_manifest.json
```

Run contents:

```text
surrogate_model/datasets/run2/MLP/Wool_surrogate_dataset.mat
surrogate_model/datasets/run2/segmented_SR/Wool_symbolic_segmented.mat
surrogate_model/datasets/run2/global_SR/Wool_symbolic_global.mat
```

Comparison rule:

```text
Use only datasets within the same run_id for horizontal model comparison.
Do not compare a model trained on one dataset run with a model trained on
another dataset run.
```

### Teacher / MLP Dataset

Teacher dataset file:

```text
surrogate_model/datasets/run2/MLP/Wool_surrogate_dataset.mat
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
surrogate_model/datasets/run2/segmented_SR/Wool_symbolic_segmented.mat
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
surrogate_model/datasets/run2/global_SR/Wool_symbolic_global.mat
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
The run2 MLP teacher dataset has been generated successfully.
No run2 MLP training was requested or performed.
Only the older small baseline artifact exists, so there is still no formal
run2 MLP comparison result.
```

Known artifact:

```text
surrogate_model/MLP/artifacts/wool_baseline_mlp_small
```

The MLP branch should use:

```text
surrogate_model/datasets/run2/MLP/Wool_surrogate_dataset.mat
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

All active segmented-SR entry points now resolve their default dataset run
from:

```text
surrogate_model/segmented_symbolic_regression/dataset_run_config.json
```

The current default is `run2`. MATLAB generation/inspection and Python
training/evaluation therefore use the same run by default. Python also accepts
`--dataset-run`; standard `datasets/run*/...` paths are checked against it,
and evaluation refuses to combine a dataset with training metadata from a
different run.

Current output roots:

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
not write to the old unsegmented names:

```text
wool_symbolic_pysr_segments_runs
wool_symbolic_candidate_evaluation_runs
wool_symbolic_dataset_inspection
```

### Latest Segmented SR Dataset Generation

The current segmented SR dataset in `run2` has been generated successfully from
the run2 teacher dataset:

```text
surrogate_model/datasets/run2/segmented_SR/Wool_symbolic_segmented.mat
```

### Latest Full Segmented SR Training

Latest completed full segmented SR training run:

```text
surrogate_model/segmented_symbolic_regression/artifacts/wool_segmented_symbolic_pysr_runs/20260803_run2_iface_full
```

Configuration:

```text
niterations = 100
populations = 12
population_size = 100
maxsize = 28
rows used = all 64000 scalar samples
parallelism = serial
dataset run = run2
```

Training summary:

```text
segment              complexity   test_rmse   test_mae   test_r2
low_100_700          16           0.020634    0.015765   0.982880
midlow_700_1000      20           0.035650    0.027242   0.717309
midhigh_1000_1300    20           0.034049    0.024614   0.735508
highlow_1300_1650    14           0.024609    0.017281   0.906919
high_1650_2000       13           0.019416    0.013959   0.944005
```

### Latest Segmented SR Evaluation

Latest complete evaluation run:

```text
surrogate_model/segmented_symbolic_regression/artifacts/wool_segmented_symbolic_candidate_evaluation_runs/20260803_run2_iface_maxc16
```

This evaluation was produced successfully on the local hard-drive clone from
the full run2 training run listed above. Its analysis-ready artifacts are
included in the latest local commit; the branch may still need to be pushed
before another computer or draft PR #1 can see them.

Selection rule:

```text
max_complexity = 16
```

Selected candidates are identified by 1-based row/index in each segment's
equations CSV. Candidate index and expression complexity are different fields:

```text
segment              candidate_index   complexity
low_100_700          13                16
midlow_700_1000      12                16
midhigh_1000_1300    12                15
highlow_1300_1650    13                16
high_1650_2000       11                15
```

Overall selected-formula metrics:

```text
RMSE          0.0274685145
MAE           0.0194199672
max_abs_error 0.2047642883
R2            0.9884693013
```

This `max_complexity=16` evaluation is the current recommended segmented SR
result for run2 interpretation and reporting. The earlier run1 evaluation had
RMSE `0.0285096442`, MAE `0.0198104144`, and R2 `0.9875635954`; it remains a
historical within-run result and must not be substituted into a run2 horizontal
comparison.

This run was also the first full end-to-end validation of the shared segmented
dataset-run interface. Both training and evaluation resolved `run2` from
`dataset_run_config.json`, recorded `dataset_run: run2`, and passed the
training/evaluation metadata consistency check. All 96 candidate formulas
evaluated successfully.

Evaluation now applies output clipping to every candidate and selected formula:
`alpha_final = clip(alpha_raw, 0, 1)`. Candidate selection, reported metrics,
figures, and boundary diagnostics all use the clipped predictions. For this
run, the raw range was `-0.034435` to `1.072190`; 316 of 64000 predictions
(`0.49375%`) were clipped, and the final range is exactly `[0,1]`. Raw and
clipped diagnostics are both retained in `selected_combination_summary.json`.
The largest mean boundary excess change occurs near `1000 Hz` (`0.037185`),
followed by `700 Hz` (`0.034214`). These boundary effects are model-quality
limitations caused by independent segment formulas, not dataset-run interface
failures. Detailed values are also stored in `boundary_transition_metrics.csv`.

The first validation attempt used an automatically generated directory whose
deepest PySR path reached 265 characters and failed while Julia was opening
`hall_of_fame.csv`. The incomplete trace directory is:

```text
surrogate_model/segmented_symbolic_regression/artifacts/wool_segmented_symbolic_pysr_runs/20260803_115855_run2_iter100_pop12_ps100_size28_allrows_interface_validation_full_serial
```

The training entry point was then hardened to use shorter automatic names,
preflight Windows nested-path length, pass Julia forward-slash paths, prefer
the project-venv Julia executable, and use deterministic serial PySR settings.
The successful full run used the short explicit output directory above. The
deterministic/serial follow-up was verified with a five-segment smoke run under
the ignored `artifacts/_scratch` tree; the full run itself completed before the
deterministic flag was added, so an exact bit-for-bit retrain is not guaranteed.

### Local Environment And Smoke-Test Status

The full segmented training/evaluation pipeline has also been smoke-tested
successfully on `C:/MasterThesis_Project`. The verified local environment is:

```text
Python 3.11.9
PySR 1.5.10
Julia 1.11.9, installed inside the project venv through JuliaCall/JuliaPkg
MATLAB R2025b
venv: surrogate_model/segmented_symbolic_regression/.venv_py311
```

The venv is ignored by Git and must be recreated on another machine. The smoke
test verified all of the following:

```text
MATLAB teacher dataset: X = 1000 x 7, Y = 1000 x 64
segmented scalar dataset: X = 64000 x 8, y = 64000
all five segment names decoded correctly
PySR successfully called Julia/SymbolicRegression.jl
five-segment minimal training completed
candidate evaluation and figure generation completed
```

Committed local-disk smoke artifacts are retained under:

```text
surrogate_model/segmented_symbolic_regression/archive/smoke_tests/artifacts/
  segmented_local_disk_smoke_training_20260727_193327/
  segmented_local_disk_smoke_evaluation_20260727_193327/
```

An additional later smoke test exists only as untracked local temporary output
under the old path requested for that test:

```text
surrogate_model/symbolic_regression/archive/smoke_tests/artifacts/
  current_machine_smoke_20260727_201458/
  current_machine_smoke_20260727_201458_eval/
```

That untracked `surrogate_model/symbolic_regression` tree contains smoke output
only. It is not an active model branch, was intentionally excluded from the
formal evaluation commit/PR, and should not be committed or deleted without an
explicit decision.

## Global Symbolic Regression Branch State

Branch directory:

```text
surrogate_model/global_symbolic_regression
```

Current status:

```text
The run2 global scalar dataset has been generated successfully.
Dataset generation, inspection, training, and evaluation code exist.
Formal run2 global training and max-complexity evaluation completed successfully.
```

Important entry points:

```text
run_global_symbolic_dataset_generation.m
run_global_symbolic_dataset_inspection.m
train_global_symbolic_model.py
evaluate_global_symbolic_candidates.py
```

Current global dataset:

```text
surrogate_model/datasets/run2/global_SR/Wool_symbolic_global.mat
```

Current global inspection artifact:

```text
surrogate_model/global_symbolic_regression/artifacts/wool_symbolic_global_dataset_inspection
```

The global inspection driver reuses the segmented inspection logic but
explicitly overrides the output directory so global artifacts stay under:

```text
surrogate_model/global_symbolic_regression/artifacts
```

Latest completed full global SR training run:

```text
surrogate_model/global_symbolic_regression/artifacts/wool_global_symbolic_pysr_runs/20260803_run2_full
```

Configuration:

```text
niterations = 100
populations = 12
population_size = 100
maxsize = 28
rows used = all 64000 scalar samples
parallelism = serial
dataset run = run2
```

The PySR-selected training equation has complexity 13, test RMSE `0.061594`,
test MAE `0.048990`, and test R2 `0.941964`.

Latest complete global evaluation run:

```text
surrogate_model/global_symbolic_regression/artifacts/wool_global_symbolic_candidate_evaluation_runs/20260803_run2_maxc21
```

The `max_complexity=21` rule selected candidate 13, complexity 20:

```text
((log(log(log(f) - 2.792401)) + (f * alpha_infinity / sigma))
 * log(log(f) - 3.343083)) + 0.17144258
```

Full-dataset clipped metrics are RMSE `0.0564852056`, MAE `0.0443311168`,
max absolute error `0.2335056388`, and R2 `0.9512410095`. The raw prediction
range was `0.039444` to `1.208810`; 883 of 64000 predictions (`1.3796875%`)
were clipped to `[0,1]`. All 17 candidate formulas evaluated successfully.

The earlier `max_complexity=16` evaluation selected candidate 9, complexity
13, with RMSE `0.0614264381`, MAE `0.0487192655`, max absolute error
`0.2259478249`, and R2 `0.9423371711`. It remains the simpler comparison point;
the maxc21 result is the current recommended accuracy/complexity trade-off.

## Current Artifact Layout

Segmented SR current artifact roots:

```text
surrogate_model/segmented_symbolic_regression/artifacts/
  archived_pre_segmented_rename_artifacts/
  wool_segmented_symbolic_candidate_evaluation_runs/
  wool_segmented_symbolic_pysr_runs/
```

Segmented SR smoke-test artifacts are kept separately from formal artifacts:

```text
surrogate_model/segmented_symbolic_regression/archive/smoke_tests/artifacts/
```

If segmented dataset inspection is run again, this current-name folder may also
appear:

```text
surrogate_model/segmented_symbolic_regression/artifacts/wool_segmented_symbolic_dataset_inspection
```

Global SR current artifact root:

```text
surrogate_model/global_symbolic_regression/artifacts/
  wool_symbolic_global_dataset_inspection/
  wool_global_symbolic_pysr_runs/
  wool_global_symbolic_candidate_evaluation_runs/
```

Global SR smoke-test artifacts are kept under:

```text
surrogate_model/global_symbolic_regression/archive/smoke_tests/artifacts/
```

MLP current known artifact:

```text
surrogate_model/MLP/artifacts/wool_baseline_mlp_small
```

## Run Logic

A full fair comparison should use only one dataset run at a time. For the
current project state that means all model branches should read from:

```text
surrogate_model/datasets/run2
```

Current data generation sequence:

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

Current global SR training/evaluation sequence:

```text
1. train_global_symbolic_model.py
   --niterations 100
   --populations 12
   --population-size 100
   --maxsize 28

2. evaluate_global_symbolic_candidates.py
   --selection-rule max_complexity
   --max-complexity 21
```

MLP still does not have a formal run2 comparison result. The run2 datasets
already exist; do not regenerate them unless intentionally creating another
dataset run.

## Git And GitHub Sync Policy

Intended workflow for two computers:

```text
Computer A:
  git pull
  run local training/evaluation
  inspect outputs
  git add curated outputs and any code changes
  git commit
  git push

Computer B:
  git pull
  analyze the committed run or continue from the synchronized state
```

Use local hard-drive clones on both computers. Do not train from OneDrive.
Do not train from two computers at the same time against the same run/artifact
folder unless a separate run name is intentionally chosen.

Before starting work on either computer:

```powershell
git pull --ff-only
git status
```

After a successful training/evaluation run:

```powershell
git status
git add <code changes> <dataset/run manifest if changed> <analysis-ready artifacts>
git commit -m "Add segmented SR run ..."
git push
```

Files that should be committed when another computer needs to analyze a run
without retraining:

```text
dataset_manifest.json
datasets/run*/**/*.mat, when the dataset run is part of the shared comparison
segment_model_summary.csv
segment_model_summary.json
training_metadata.json
*_best_equation.json
equations/*.csv
candidate_metrics.csv
selected_candidates.csv
selected_combination_summary.json
figures/*.png
models/*.pkl, only when another computer needs to load PySR model objects
```

Files that should normally stay out of Git:

```text
.venv/
.venv_py311/
__pycache__/
*.pyc
pysr_runs/**/checkpoint.pkl
pysr_runs/**/*.bak
local scratch/tmp output folders
MATLAB autosave files
OS metadata files
```

`models/*.pkl` are intentionally not ignored, but they should be committed only
when they are needed for cross-computer analysis. Most analysis should work
from:

```text
equations/*.csv
*_best_equation.json
candidate_metrics.csv
selected_candidates.csv
selected_combination_summary.json
```

`pysr_runs/**/hall_of_fame.csv` is also intentionally not globally ignored,
but the preferred portable candidate table is `equations/*.csv`. Commit raw
`hall_of_fame.csv` files only if a specific follow-up requires PySR's raw
output.

The current `.gitignore` policy ignores transient environments, Python caches,
PySR checkpoints, PySR `.bak` files, and local scratch/tmp folders while keeping
analysis-ready artifacts visible to Git.

On Windows, long artifact paths can exceed the default Git path limit. The
local setup should keep this enabled:

```powershell
git config --global core.longpaths true
```

`core.longpaths` helps Git but does not guarantee that Python can create every
deep output path. The evaluation script's automatic directory name can exceed
the Windows path limit because it includes the full training-run name. If that
happens, pass an explicit short output directory, for example:

```powershell
--output-dir surrogate_model/segmented_symbolic_regression/artifacts/wool_segmented_symbolic_candidate_evaluation_runs/<timestamp>_<run_id>_maxc16
```

## Naming And Separation Rules

The old branch name:

```text
surrogate_model/symbolic_regression
```

has been replaced by:

```text
surrogate_model/segmented_symbolic_regression
```

Global SR must remain separate under:

```text
surrogate_model/global_symbolic_regression
```

Current segmented scripts and artifacts should use `segmented` in names where
possible. Old unsegmented artifact directories under
`archived_pre_segmented_rename_artifacts` are historical only and should not be
used as active output locations.

## Current Git State

The local hard-drive clone at `C:/MasterThesis_Project` was last verified on
2026-08-03 after completing the run2 data-generation, segmented-training, and
evaluation workflow:

```text
current branch: agent/add-segmented-evaluation
remote branch before the run2 commit: 024151a Add segmented SR max-complexity evaluation
main and origin/main: 71c905e Add local disk segmented SR smoke test artifacts
draft PR: #1, OPEN and MERGEABLE, targeting main
completed run2 work included in the next/current local commit:
  surrogate_model/datasets/run2/
  surrogate_model/segmented_symbolic_regression/artifacts/wool_segmented_symbolic_pysr_runs/20260803_run2_iter100_pop12_ps100_size28_allrows_serial/
  surrogate_model/segmented_symbolic_regression/artifacts/wool_segmented_symbolic_candidate_evaluation_runs/20260803_run2_maxc16/
latest curated interface-validation artifacts included in the current local commit:
  segmented training: 20260803_run2_iface_full/
  segmented evaluation: 20260803_run2_iface_maxc16/
remaining untracked local content intentionally excluded from commits:
  surrogate_model/symbolic_regression/ (temporary smoke output only)
  incomplete long-path attempt: 20260803_115855_run2_iter100_pop12_ps100_size28_allrows_interface_validation_full_serial/
  raw pysr_runs/ output and models/*.pkl from 20260803_run2_iface_full/
global-SR work included in the current local commit:
  global training/evaluation entry points and run2 configuration
  global smoke-test archive
  formal training: 20260803_run2_full/
  formal evaluations: 20260803_run2_maxc16/ and 20260803_run2_maxc21/
```

If a future conversation starts from this handoff, first run:

```powershell
cd C:\MasterThesis_Project
git status --short --branch
git pull --ff-only
```

Then check the current state of PR #1 and whether the local branch has been
pushed before choosing a branch or making new commits. At the time run2 was
completed, PR #1 contained only the earlier run1 evaluation; it will include
run2 only after the new commit is pushed. Do not discard the untracked smoke
directory.

## Current Maturity Summary

Current segmented SR is mature enough for reporting-level inspection. Its
recommended evaluation is the `max_complexity=16` selected-candidate evaluation
listed above for run2. The full run2 training and evaluation completed
successfully on this machine.

Global SR is now also mature enough for reporting-level inspection. Its
recommended run2 result is the `max_complexity=21` evaluation listed above.
The full run2 training and evaluation completed successfully on this machine.

MLP has a generated run2 teacher dataset, but no formal run2 training. The old
small baseline artifact is not at the same comparison maturity as segmented SR.

Immediate project next steps are:

```text
1. Review the run2 segmented and global SR artifacts and evaluations.
2. Decide how to commit/publish the global SR implementation and results.
3. Produce a formal MLP result on datasets/run2 using a comparison protocol
   compatible with the SR branches.
4. Then perform the three-model horizontal comparison.
```
