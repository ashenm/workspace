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

# directory changer
workspace () {

  if [ $# -ne 0 ]
  then
    command cd $*
  elif [ -d $HOME/workspace ]
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
