# if not root
if [ `id -u` -ne 0 ]
then

  # show git branch and status
  export GIT_PS1_SHOWDIRTYSTATE=1
  export PS1="\$(__git_ps1 \"(%s) \")$PS1"

fi
