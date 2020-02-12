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

# if not root
if [ `id -u` -ne 0 ]
then

  # hub
  alias git='hub'

  # asciidoctor
  alias asciidoctor-pdf='asciidoctor-pdf --require asciidoctor-mathematical --attribute mathematical-format=svg \
    --attribute pdf-theme=workspace --attribute pdf-themesdir=/usr/local/share/asciidoctor-pdf/data/themes'

  # terminal colors
  export TERM='xterm-256color'

  # motd
  echo "                                                                   "
  echo "                                                                   "
  echo "                 W   O   R   K   S   P   A   C   E                 "
  echo "             https://hub.docker.com/r/ashenm/workspace             "
  echo "                                                                   "
  echo "                                                                   "
  echo " PortMapping                                                       "
  ports | sed 's/^/     /'
  echo "                                                                   "

fi
