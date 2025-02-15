export RBENV_ROOT="/opt/rbenv"

if [ "${PATH#*$RBENV_ROOT/shims}" = "${PATH}" ]; then
  export PATH="$RBENV_ROOT/bin:$RBENV_ROOT/shims:$PATH"
fi
