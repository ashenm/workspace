export PYENV_ROOT="/opt/pyenv"
export PYTHON_CONFIGURE_OPTS="--enable-optimizations --with-lto" PYTHON_CFLAGS="-march=native -mtune=native"

if [ "${PATH#*$PYENV_ROOT/shims}" = "${PATH}" ]; then
  export PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"
fi
