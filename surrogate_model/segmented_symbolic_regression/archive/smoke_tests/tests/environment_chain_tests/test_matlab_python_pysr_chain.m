script_dir = fileparts(mfilename('fullpath'));
symbolic_root = fileparts(script_dir);

python_executable = fullfile(symbolic_root, '.venv_py311', 'Scripts', 'python.exe');
julia_executable = 'C:\Users\liuzi\.julia\juliaup\julia-1.11.9+0.x64.w64.mingw32\bin\julia.exe';

pyenv_info = pyenv('Version', python_executable);
disp(pyenv_info)

setenv('PYTHON_JULIAPKG_EXE', julia_executable);

sys_mod = py.importlib.import_module('sys');
disp("python_executable:")
disp(string(py.getattr(sys_mod, 'executable')))

np = py.importlib.import_module('numpy');
disp("numpy_version:")
disp(string(py.getattr(np, '__version__')))

pysr_mod = py.importlib.import_module('pysr');
disp("pysr_version:")
disp(string(py.getattr(pysr_mod, '__version__')))
