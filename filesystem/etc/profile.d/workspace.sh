# if not root
if [ `id -u` -ne 0 ]
then

  # hub
  alias git='hub'

  # gnu
  alias time='command time -v'

  # python
  alias pip='pip3'
  alias python='python3'

fi
