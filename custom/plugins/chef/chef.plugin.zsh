function _chef_command() {
  if [[ $1 == 'generate' ]]; then
    shift 1
    nocorrect command chef generate $@ -C 'J. Morgan Lieberthal' -m 'j.morgan.lieberthal@gmail.com' -I 'mit'
  else
    nocorrect command chef $@
  fi
}

alias chef='_chef_command'
compdef _chef_command=chef

alias cg="chef generate"
