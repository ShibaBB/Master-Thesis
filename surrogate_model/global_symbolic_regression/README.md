# Global Symbolic Regression

This folder contains the global symbolic-regression model, which fits one
PySR equation over the full 100-2000 Hz frequency range.

The intended comparison structure is:

- `surrogate_model/MLP`: MLP baseline model.
- `surrogate_model/segmented_symbolic_regression`: segmented symbolic-regression model.
- `surrogate_model/global_symbolic_regression`: one-formula global symbolic-regression model.

The global SR branch reuses the shared teacher dataset and scalar symbolic
dataset format. The stored MATLAB schema contains one domain named
`global_100_2000`; training validates that exactly one domain is present.

Current dataset:

- `surrogate_model/datasets/run2/global_SR/Wool_symbolic_global.mat`

Current data entry points:

- `run_global_symbolic_dataset_generation.m`
- `run_global_symbolic_dataset_inspection.m`

Training and evaluation entry points:

- `train_global_symbolic_model.py`
- `evaluate_global_symbolic_candidates.py`

All entry points resolve the default dataset run from `dataset_run_config.json`.
Training and evaluation also read
`surrogate_model/datasets/run2/shared_curve_split.json`. Scalar rows are mapped
through `source_curve_index`; training, candidate selection, and final
evaluation use train, validation, and test source curves respectively. The
split is independent of frequency range and frequency-point count.
Training artifacts are written under `artifacts/wool_global_symbolic_pysr_runs`;
evaluation artifacts are written under
`artifacts/wool_global_symbolic_candidate_evaluation_runs`.

## Current Formal Run2 Result

Full training:

- `artifacts/wool_global_symbolic_pysr_runs/20260808_121026_run2`
- 100 iterations, 12 populations, population size 100, maxsize 28
- all 64000 scalar rows
- shared split rows: 44800 train, 9600 validation, 9600 test

Recommended evaluation:

- `artifacts/wool_global_symbolic_candidate_evaluation_runs/20260808_123902_run2_c21`
- selection rule: `max_complexity=21`
- selected candidate: 15, complexity 21
- test RMSE: `0.0442206187`
- test MAE: `0.0342617541`
- test R2: `0.9694026821`

This result uses the shared run2 source-curve split and is eligible for the
three-model horizontal comparison. Candidate selection uses validation curves;
the reported metrics use test curves. Predictions are clipped to the physical
range `[0,1]` during candidate evaluation and reporting. The 2026-08-03 full
training and maxc16/maxc21 evaluations predate the shared split and are retained
as historical comparison points only.
