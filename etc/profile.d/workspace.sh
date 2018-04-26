# if not root
if [ "$UID" -ne 0 ]
then

  # hub
  alias git='hub'

  # python
  alias pip='pip3'
  alias python='python3'

fi
