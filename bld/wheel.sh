#!/usr/bin/env bash
for p in $python_versions
  do
  /opt/python/$p/bin/pip install build
  /opt/python/$p/bin/pip install auditwheel
  /opt/python/$p/bin/python -m build --sdist --wheel
  /opt/python/$p/bin/python -m auditwheel repair dist/ectrans4py-*-$p-linux_x86_64.whl
  done
