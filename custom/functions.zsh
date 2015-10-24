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

# A wrapper around less to open it with colors provided by pygments.
#
pygless()
{
  LESSOPEN="| pygmentize -f terminal256 -O style=solarized -g %s" less -R "$@";
}

# A function that gives the current directory the alias name of the argument
# passed in, and sources the directories file to immediately show the new name
# in the prompt
#
function name_dir() {
  local dirname=$1
  echo "${dirname}=`pwd`" >> "${ZEXTRA_DIR}/directories.zsh"
  source "${ZEXTRA_DIR}/directories.zsh"
}

# Mount and unmount the case-insensitive Android disk image
#
function mountAndroid() { hdiutil attach /Volumes/HDD/android.dmg -mountpoint /Volumes/android; }
function umountAndroid() { hdiutil detach /Volumes/android; }

# Get standard gitignore files for the passed in arguments
#
function gi() { curl -L -s https://www.gitignore.io/api/$@ ;}

# A function that copies a zsh plugin's files to $ZSH_CUSTOM
#
function customize() {
  # local tocopy=$1
  if is_plugin $ZSH $1; then
    local plugin="${ZSH}/plugins/${1}"
    local dest="${ZSH_CUSTOM}/plugins/${1}"
    cp -r $plugin $dest && cd $dest
  fi
}


function chef-encrypt() {
  local databag=$1
  shift 1
  local to_enc=$1
  shift 1
  local key
  if [[ -f "/tmp/encrypted_data_bag_secret" ]]; then
    key="/tmp/encrypted_data_bag_secret"
  else
    key=$3
    shift 1
  fi
  knife data bag from file $databag $to_enc --secret-file $key $@
}

function use-ruby() {
  rvm --ruby-version use $1 --create
}
