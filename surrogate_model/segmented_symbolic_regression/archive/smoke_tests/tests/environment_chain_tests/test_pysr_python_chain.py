import os
import sys

import numpy as np
from pysr import PySRRegressor


def main():
    print(f"python_executable: {sys.executable}")
    print(f"PYTHON_JULIAPKG_EXE: {os.environ.get('PYTHON_JULIAPKG_EXE')}")

    X = np.array(
        [
            [0.0, 0.0],
            [1.0, 0.0],
            [0.0, 1.0],
            [1.0, 1.0],
            [2.0, 1.0],
            [1.5, 0.5],
        ]
    )
    y = X[:, 0] + 2.0 * X[:, 1]

    model = PySRRegressor(
        niterations=5,
        populations=2,
        population_size=30,
        binary_operators=["+", "*"],
        unary_operators=[],
        maxsize=10,
        model_selection="best",
        progress=False,
        verbosity=0,
        temp_equation_file=False,
    )
    model.fit(X, y)

    print("equations_found:")
    print(model.equations_[["complexity", "loss", "equation"]].to_string(index=False))
    prediction = model.predict(np.array([[3.0, 4.0]]))[0]
    print(f"prediction_for_[3,4]: {prediction}")


if __name__ == "__main__":
    main()
