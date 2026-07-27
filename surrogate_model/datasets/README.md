# Dataset Runs

This folder stores comparison datasets by run.

Use one `run*` folder at a time when comparing MLP, segmented SR, and global SR.
This keeps all models tied to the same teacher data.

## Current Run

`run1` contains:

- `MLP/Wool_surrogate_dataset.mat`
  - Curve-format teacher dataset.
  - Used directly by the MLP baseline.
- `segmented_SR/Wool_symbolic_segmented.mat`
  - Scalar frequency-expanded dataset derived from the run1 teacher dataset.
  - Uses the current segmented SR frequency split.
- `global_SR/Wool_symbolic_global.mat`
  - Scalar frequency-expanded dataset derived from the run1 teacher dataset.
  - Uses one global `100-2000 Hz` segment.
- `dataset_manifest.json`
  - Records the source/derived dataset relationship.

For future experiments, create a new folder such as `run2` or `test1` with the same structure.
