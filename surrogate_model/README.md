# Surrogate Model Workspace

## Folder Layout

- [data_generation](</C:/Users/liuzi/OneDrive/Master Thesis/Fibers/surrogate_model/data_generation>)
  - Shared dataset generation and dataset inspection scripts used by both MLP and symbolic-regression workflows.
- [MLP](</C:/Users/liuzi/OneDrive/Master Thesis/Fibers/surrogate_model/MLP>)
  - MLP-only training scripts, MLP artifacts, and MLP-specific notes.
- [segmented_symbolic_regression](</C:/Users/liuzi/OneDrive/Master Thesis/Fibers/surrogate_model/segmented_symbolic_regression>)
  - Current segmented symbolic-regression workflow using PySR.
  - This is the active segmented SR model branch.
- [global_symbolic_regression](</C:/Users/liuzi/OneDrive/Master Thesis/Fibers/surrogate_model/global_symbolic_regression>)
  - Current global symbolic-regression workflow using one full-range PySR
    formula over `100-2000 Hz`.
- [docs](</C:/Users/liuzi/OneDrive/Master Thesis/Fibers/surrogate_model/docs>)
  - General background notes, original strategy documents, and reference material.

## Dataset Runs

All model comparisons should use one dataset run at a time.

Current comparison dataset:

- `datasets/run2`
  - `MLP/Wool_surrogate_dataset.mat`: shared teacher curve dataset for MLP.
  - `segmented_SR/Wool_symbolic_segmented.mat`: scalar dataset for segmented SR.
  - `global_SR/Wool_symbolic_global.mat`: scalar dataset for global SR.
  - `dataset_manifest.json`: source and comparison metadata.

`datasets/run1` remains as the earlier baseline dataset run.

Use only datasets from the same `run*` folder when comparing MLP, segmented SR, and global SR.

## Recommended Entry Points

- Shared dataset generation:
  - [generate_teacher_dataset.m](/C:/Users/liuzi/OneDrive/Master%20Thesis/Fibers/surrogate_model/data_generation/generate_teacher_dataset.m:1)
- Shared dataset inspection:
  - [inspect_teacher_dataset.m](/C:/Users/liuzi/OneDrive/Master%20Thesis/Fibers/surrogate_model/data_generation/inspect_teacher_dataset.m:1)
- MLP baseline training:
  - [mlp_train_surrogate_baseline.m](/C:/Users/liuzi/OneDrive/Master%20Thesis/Fibers/surrogate_model/MLP/mlp_train_surrogate_baseline.m:1)
- Symbolic scalar dataset generation:
  - [generate_segmented_symbolic_dataset.m](/C:/Users/liuzi/OneDrive/Master%20Thesis/Fibers/surrogate_model/segmented_symbolic_regression/generate_segmented_symbolic_dataset.m:1)
- Symbolic scalar dataset inspection:
  - [inspect_segmented_symbolic_dataset.m](/C:/Users/liuzi/OneDrive/Master%20Thesis/Fibers/surrogate_model/segmented_symbolic_regression/inspect_segmented_symbolic_dataset.m:1)
- Symbolic-regression strategy:
  - [strategy_segmented_symbolic.md](/C:/Users/liuzi/OneDrive/Master%20Thesis/Fibers/surrogate_model/segmented_symbolic_regression/strategy_segmented_symbolic.md:1)
- Symbolic handoff note:
  - [segmented_symbolic_regression_handoff.md](/C:/Users/liuzi/OneDrive/Master%20Thesis/Fibers/surrogate_model/segmented_symbolic_regression/segmented_symbolic_regression_handoff.md:1)
- Global symbolic-regression training and evaluation:
  - [global_symbolic_regression](</C:/Users/liuzi/OneDrive/Master Thesis/Fibers/surrogate_model/global_symbolic_regression>)

## Naming Rule

- MLP-only scripts use the `mlp_` prefix.
- Shared teacher-data pipeline scripts live only under `data_generation/`.
- Segmented symbolic-regression files live under `segmented_symbolic_regression/`.
- Global symbolic-regression files live under `global_symbolic_regression/`.

This separation is intended to reduce accidental cross-calling between the MLP and symbolic-regression branches.
