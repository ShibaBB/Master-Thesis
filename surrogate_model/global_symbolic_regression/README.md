# Global Symbolic Regression

This folder is reserved for the planned global symbolic-regression model.

The intended comparison structure is:

- `surrogate_model/MLP`: MLP baseline model.
- `surrogate_model/segmented_symbolic_regression`: segmented symbolic-regression model.
- `surrogate_model/global_symbolic_regression`: one-formula global symbolic-regression model.

The global SR branch has not been implemented yet. It should reuse the shared teacher dataset and the symbolic scalar dataset format, but train one full-range formula over `100-2000 Hz` instead of one formula per frequency segment.

Current dataset:

- `surrogate_model/datasets/run1/global_SR/Wool_symbolic_global.mat`

Current data entry points:

- `run_global_symbolic_dataset_generation.m`
- `run_global_symbolic_dataset_inspection.m`
