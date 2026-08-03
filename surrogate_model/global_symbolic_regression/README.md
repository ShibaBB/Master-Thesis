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
Training artifacts are written under `artifacts/wool_global_symbolic_pysr_runs`;
evaluation artifacts are written under
`artifacts/wool_global_symbolic_candidate_evaluation_runs`.

## Current Formal Run2 Result

Full training:

- `artifacts/wool_global_symbolic_pysr_runs/20260803_run2_full`
- 100 iterations, 12 populations, population size 100, maxsize 28
- all 64000 scalar rows

Recommended evaluation:

- `artifacts/wool_global_symbolic_candidate_evaluation_runs/20260803_run2_maxc21`
- selection rule: `max_complexity=21`
- selected candidate: 13, complexity 20
- RMSE: `0.0564852056`
- MAE: `0.0443311168`
- R2: `0.9512410095`

This is the current formal global-SR result for run2. Predictions are clipped
to the physical range `[0,1]` during candidate evaluation and reporting.
The earlier maxc16 result is retained as a simpler comparison point.
