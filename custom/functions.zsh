# A clever ssh-wrapper that sets the tmux window name to the name of the host
# being accessed over ssh, then sets the name back to what it was before after
# the ssh session is closed.
#
ssh() {
# Do nothing if we are not inside tmux or ssh is called without arguments
  if [[ $# == 0 || -z $TMUX ]]; then
    command ssh $@
    return
  fi
  # The hostname is the last parameter (i.e. ${(P)#})
  local remote=${${(P)#}%.*}
  local old_name="$(tmux display-message -p '#W')"
  local renamed=0
  # Save the current name
  if [[ $remote != -* ]]; then
    renamed=1
    tmux rename-window ${remote#*@}
  fi
  command ssh $@
  if [[ $renamed == 1 ]]; then
    tmux rename-window "$old_name"
  fi
}

# The same type of thing as the function above, but closes the tmux pane /
# window upon leaving the ssh section. Incredible how much simpler it is than
# aboxe
#
ssx() {
 tmux rename-window "$*"
 command ssh "$@"
 exit
}

if [[ $(uname) =~ Darwin ]]; then
  source "${ZEXTRA_DIR}/mac_functions.zsh"
fi
