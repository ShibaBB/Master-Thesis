# Global Symbolic Regression Smoke Test

This smoke test validates the run2 global-SR path from PySR training through
candidate evaluation and plotting.

Training configuration:

```text
dataset_run = run2
global domain = global_100_2000
max_samples = 500
niterations = 1
populations = 1
population_size = 20
maxsize = 8
parallelism = serial
```

Artifacts:

```text
artifacts/global_smoke_training_20260803
artifacts/global_smoke_evaluation_20260803
```

The smoke test completed successfully. Its low predictive accuracy is expected
from the intentionally minimal search budget and is not a formal model result.
