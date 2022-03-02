# Issue with `os.path.sep` after importing `pyproj` in a debugger with Python 3.10

## To recreate:

```shell
docker-compose build
docker-compose run --rm app python -m pdb debug_failure.py
```

Pressing `c` to continue (should) result in `AttributeErrors`:

```
Traceback (most recent call last):
  File "/usr/local/lib/python3.10/pdb.py", line 1723, in main
    pdb._runscript(mainpyfile)
  File "/usr/local/lib/python3.10/pdb.py", line 1583, in _runscript
    self.run(statement)
  File "/usr/local/lib/python3.10/bdb.py", line 597, in run
    exec(cmd, globals, locals)
  File "<string>", line 1, in <module>
  File "/app/debug_failure.py", line 5, in <module>
    os.path.sep
```

Stepping though in more detail reveals that this change occurs when invoking:

`_pyproj_global_context_initialize`

Furthermore, inspecting the `os.path` object reveals it now has an attribute
called `a` and an attribute called `p`.  These match the local variables in
the `os.path.join` method. Suggesting that the offending line in the Cython
code is this one:

https://github.com/pyproj4/pyproj/blob/8f0e1f7ddc5ba5a1992f939f91bb9ea023316219/pyproj/_datadir.pyx#L120


