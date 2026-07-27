# Surrogate Model Workspace

## Folder Layout

- [data_generation](</C:/Users/liuzi/OneDrive/Master Thesis/Fibers/surrogate_model/data_generation>)
  - Shared dataset generation and dataset inspection scripts used by both MLP and symbolic-regression workflows.
- [MLP](</C:/Users/liuzi/OneDrive/Master Thesis/Fibers/surrogate_model/MLP>)
  - MLP-only training scripts, MLP artifacts, and MLP-specific notes.
- [symbolic_regression](</C:/Users/liuzi/OneDrive/Master Thesis/Fibers/surrogate_model/symbolic_regression>)
  - Current segmented symbolic-regression workflow using PySR.
  - This is the active segmented SR model branch.
- [global_symbolic_regression](</C:/Users/liuzi/OneDrive/Master Thesis/Fibers/surrogate_model/global_symbolic_regression>)
  - Placeholder for the planned global SR model branch.
  - It is intended for one full-range symbolic formula over `100-2000 Hz`.
- [docs](</C:/Users/liuzi/OneDrive/Master Thesis/Fibers/surrogate_model/docs>)
  - General background notes, original strategy documents, and reference material.

## Recommended Entry Points

- Shared dataset generation:
  - [generate_teacher_dataset.m](/C:/Users/liuzi/OneDrive/Master%20Thesis/Fibers/surrogate_model/data_generation/generate_teacher_dataset.m:1)
- Shared dataset inspection:
  - [inspect_teacher_dataset.m](/C:/Users/liuzi/OneDrive/Master%20Thesis/Fibers/surrogate_model/data_generation/inspect_teacher_dataset.m:1)
- MLP baseline training:
  - [mlp_train_surrogate_baseline.m](/C:/Users/liuzi/OneDrive/Master%20Thesis/Fibers/surrogate_model/MLP/mlp_train_surrogate_baseline.m:1)
- Symbolic scalar dataset generation:
  - [generate_symbolic_dataset.m](/C:/Users/liuzi/OneDrive/Master%20Thesis/Fibers/surrogate_model/symbolic_regression/generate_symbolic_dataset.m:1)
- Symbolic scalar dataset inspection:
  - [inspect_symbolic_dataset.m](/C:/Users/liuzi/OneDrive/Master%20Thesis/Fibers/surrogate_model/symbolic_regression/inspect_symbolic_dataset.m:1)
- Symbolic-regression strategy:
  - [strategy_symbolic.md](/C:/Users/liuzi/OneDrive/Master%20Thesis/Fibers/surrogate_model/symbolic_regression/strategy_symbolic.md:1)
- Symbolic handoff note:
  - [symbolic_regression_handoff.md](/C:/Users/liuzi/OneDrive/Master%20Thesis/Fibers/surrogate_model/symbolic_regression/symbolic_regression_handoff.md:1)
- Planned global symbolic-regression branch:
  - [global_symbolic_regression](</C:/Users/liuzi/OneDrive/Master Thesis/Fibers/surrogate_model/global_symbolic_regression>)

## Naming Rule

- MLP-only scripts use the `mlp_` prefix.
- Shared teacher-data pipeline scripts live only under `data_generation/`.
- Segmented symbolic-regression files live under `symbolic_regression/`.
- Global symbolic-regression files should live under `global_symbolic_regression/` once that model branch is implemented.

This separation is intended to reduce accidental cross-calling between the MLP and symbolic-regression branches.
