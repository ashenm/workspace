export TFENV_ROOT="/opt/tfenv"

if [ "${PATH#*$TFENV_ROOT/bin}" = "${PATH}" ]; then
  export PATH="$TFENV_ROOT/bin:$PATH"
fi
