##################################################
#
# Workspace Shell Initialisation
# https://github.com/ashenm/workspace
#
# Ashen Gunaratne
# mail@ashenm.ml
#
##################################################

# trailing pwd components
export PROMPT_DIRTRIM=2

# tmux session spawner
mux () {

  if [ $# -ne 1 ]
  then
    echo "Usage: $FUNCNAME DIRECTORY" >&2
    return 1
  fi

  MUX_SESSION_DIR="`readlink -f $1`"

  if [ ! -d $MUX_SESSION_DIR ]
  then
    echo "Cannot access '$1': No such file or directory" >&2
    return 2
  fi

  # TEMP remove once tmux upgraded to 3.1b
  # tmux new-session -d -c ${MUX_SESSION_DIR} -e MUX_SESSION_DIR=$MUX_SESSION_DIR -s ${MUX_SESSION_DIR##*/}
  export MUX_SESSION_DIR

  tmux new-session -d -c ${MUX_SESSION_DIR} -s ${MUX_SESSION_DIR##*/}

  for _ in 1 2
  do
    tmux new-window -d -c ${MUX_SESSION_DIR} -t ${MUX_SESSION_DIR##*/} || true
  done

  tmux attach-session -t ${MUX_SESSION_DIR##*/}

  export -n MUX_SESSION_DIR=

}

# directory changer
workspace () {

  if [ $# -ne 0 ]
  then
    command cd $*
  elif [ -d "$MUX_SESSION_DIR" ]
  then
    command cd $MUX_SESSION_DIR
  elif [ -d "$HOME/workspace" ]
  then
    command cd $HOME/workspace
  else
    command cd
  fi

}

# if not root
if [ `id -u` -ne 0 ]
then

  # directory changes
  alias cd='workspace'

  # hub
  alias git='hub'

  # asciidoctor
  alias asciidoctor-pdf='asciidoctor-pdf --require asciidoctor-diagram --require asciidoctor-mathematical \
    --attribute mathematical-format=svg --attribute pdf-theme=workspace --attribute pdf-themesdir=/usr/local/share/asciidoctor-pdf/data/themes'

  # plantuml
  alias plantuml='java -jar /usr/local/share/java/plantuml.jar'

  # node specifics
  alias eslint='eslint --plugin=html'

  # ditaa
  alias ditaa='java -jar /usr/local/share/java/ditaa.jar'

  # terminal colors
  export TERM='xterm-256color'

fi

# motd
if [ "$$" -eq 1 ]
then

  echo "                                                                   "
  echo "                                                                   "
  echo "                 W   O   R   K   S   P   A   C   E                 "
  echo "             https://hub.docker.com/r/ashenm/workspace             "
  echo "                                                                   "
  echo "                                                                   "

  test ! -S /run/docker.sock && \
    return

  echo " PortMapping                                                       "
  ports | sed 's/^/     /'
  echo "                                                                   "

fi
