##################################################
#
# Workspace Shell Initialisation
# https://github.com/ashenm/workspace
#
# Ashen Gunaratne
# mail@ashenm.ml
#
##################################################

# if not root
if [ `id -u` -ne 0 ]
then

  # hub
  alias git='hub'

  # asciidoctor
  alias asciidoctor-pdf='asciidoctor-pdf --require asciidoctor-mathematical --attribute mathematical-format=svg'

  # terminal colors
  export TERM='xterm-256color'

fi
