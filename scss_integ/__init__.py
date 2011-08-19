import os

try:
    import scss
except ImportError:
    pass

else:
    # monkey patch to find scss sources packaged with this
    PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    load_paths = scss.LOAD_PATHS.split(',')
    scss_path = os.path.join(PROJECT_ROOT, 'scss-stylesheets')
    if scss_path not in load_paths:
        load_paths.append(scss_path)
        scss.LOAD_PATHS = ','.join(load_paths)
