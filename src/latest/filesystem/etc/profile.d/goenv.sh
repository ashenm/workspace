export GOENV_ROOT="/opt/goenv"

if [ "${PATH#*$GOENV_ROOT/shims}" = "${PATH}" ]; then
  export PATH="$GOENV_ROOT/bin:$GOENV_ROOT/shims:$PATH"
fi
