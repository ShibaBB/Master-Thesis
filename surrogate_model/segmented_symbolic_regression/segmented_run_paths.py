"""Shared dataset-run resolution for segmented symbolic-regression entry points."""

from __future__ import annotations

import json
import re
from pathlib import Path


SCRIPT_DIR = Path(__file__).resolve().parent
SURROGATE_ROOT = SCRIPT_DIR.parent
RUN_CONFIG_FILE = SCRIPT_DIR / "dataset_run_config.json"
RUN_NAME_PATTERN = re.compile(r"^[A-Za-z0-9][A-Za-z0-9_-]*$")


def default_dataset_run() -> str:
    if not RUN_CONFIG_FILE.exists():
        raise FileNotFoundError(f"Segmented dataset run config not found: {RUN_CONFIG_FILE}")
    with RUN_CONFIG_FILE.open(encoding="utf-8") as file:
        config = json.load(file)
    return validate_dataset_run(config.get("default_dataset_run", ""))


def validate_dataset_run(dataset_run: str) -> str:
    if not RUN_NAME_PATTERN.fullmatch(dataset_run):
        raise ValueError(f"Invalid dataset run name: {dataset_run!r}")
    return dataset_run


def segmented_dataset_path(dataset_run: str) -> Path:
    dataset_run = validate_dataset_run(dataset_run)
    return SURROGATE_ROOT / "datasets" / dataset_run / "segmented_SR" / "Wool_symbolic_segmented.mat"


def run_id_from_dataset_path(dataset_file: Path) -> str | None:
    resolved = dataset_file.resolve()
    parts = resolved.parts
    for index, part in enumerate(parts[:-2]):
        if part.lower() == "datasets":
            return parts[index + 1]
    return None


def resolve_dataset_file(dataset_run: str, dataset_file: Path | None) -> tuple[Path, str]:
    dataset_run = validate_dataset_run(dataset_run)
    resolved_file = segmented_dataset_path(dataset_run) if dataset_file is None else dataset_file
    path_run = run_id_from_dataset_path(resolved_file)
    if path_run is not None and path_run != dataset_run:
        raise ValueError(
            f"Dataset run mismatch: --dataset-run={dataset_run!r}, but the dataset path belongs "
            f"to {path_run!r}: {resolved_file}"
        )
    return resolved_file, dataset_run if path_run is not None else "custom"


def training_dataset_run(training_dir: Path) -> str | None:
    metadata_file = training_dir / "training_metadata.json"
    if not metadata_file.exists():
        return None
    with metadata_file.open(encoding="utf-8") as file:
        metadata = json.load(file)
    recorded_run = metadata.get("dataset_run")
    if recorded_run:
        return str(recorded_run)
    dataset_file = metadata.get("dataset_file")
    if not dataset_file:
        return None
    dataset_path = Path(dataset_file)
    if not dataset_path.is_absolute():
        dataset_path = SURROGATE_ROOT.parent / dataset_path
    return run_id_from_dataset_path(dataset_path)
