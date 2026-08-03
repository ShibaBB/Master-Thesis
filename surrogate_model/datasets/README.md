# Dataset Runs

This folder stores comparison datasets by run.

Use one `run*` folder at a time when comparing MLP, segmented SR, and global SR.
This keeps all models tied to the same teacher data.

## Current Run

`run2` is the current comparison run. It was generated with Wool porosity 92,
1000 LHS teacher samples, 64 frequency points over 100-2000 Hz, and random seed
43. It contains:

- `MLP/Wool_surrogate_dataset.mat`
  - Curve-format teacher dataset.
  - Used directly by the MLP baseline.
- `segmented_SR/Wool_symbolic_segmented.mat`
  - Scalar frequency-expanded dataset derived from the run2 teacher dataset.
  - Uses the current segmented SR frequency split.
- `global_SR/Wool_symbolic_global.mat`
  - Scalar frequency-expanded dataset derived from the run2 teacher dataset.
  - Uses one global `100-2000 Hz` segment.
- `dataset_manifest.json`
  - Records the source/derived dataset relationship.

`run1` is retained as the earlier baseline run. Do not mix models trained on
run1 with models trained on run2 in a horizontal comparison.

For future experiments, create a new folder such as `run3` or `test1` with the
same structure.
