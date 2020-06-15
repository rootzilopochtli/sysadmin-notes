#
# Lines added for git-prompt
#
git_prompt_sh='/usr/share/git-core/contrib/completion/git-prompt.sh'
if [ -f ${git_prompt_sh} ]; then
  source ${git_prompt_sh}
  export GIT_PS1_SHOWDIRTYSTATE=true
  export GIT_PS1_SHOWUNTRACKEDFILES=true
  export PS1='[\u@\h \W$(declare -F __git_ps1 &>/dev/null && __git_ps1 " (%s)")]\$ '
fi
