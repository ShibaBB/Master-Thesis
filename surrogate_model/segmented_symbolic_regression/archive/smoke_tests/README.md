# Smoke Test Archive

This folder contains early symbolic-regression smoke-test material that is no
longer part of the normal modelling workflow.

It is kept for reproducibility and troubleshooting only.

## Contents

- `artifacts/`
  - old small/full smoke-test PySR outputs
  - old small symbolic dataset inspection output
  - old smoke candidate-evaluation output
- `generated_data/`
  - `Wool_symbolic_dataset_small.mat`
- `scripts/`
  - small symbolic dataset generation/inspection drivers
- `tests/`
  - early Python/MATLAB/PySR/Julia environment chain tests
- `notes/`
  - original PySR environment setup note
- `root_outputs/`
  - early PySR output folders that were previously created under the project root `outputs/`

## Current Workflow

Use the files in the parent `symbolic_regression` directory for normal work:

```text
run_full_segmented_symbolic_dataset_generation.m
run_full_segmented_symbolic_dataset_inspection.m
train_segmented_symbolic_models.py
evaluate_segmented_symbolic_candidates.py
```

Current training runs are stored under:

```text
../artifacts/wool_segmented_symbolic_pysr_runs
```

Current evaluation runs are stored under:

```text
../artifacts/wool_segmented_symbolic_candidate_evaluation_runs
```
