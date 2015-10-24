function _chef_command() {
  if [[ $1 == 'generate' ]]; then
    shift 1
    command chef generate $@ -C 'J. Morgan Lieberthal' -m 'j.morgan.lieberthal@gmail.com' -I 'mit'
  else
    command chef $@
  fi
}

alias chef='nocorrect _chef_command'
compdef _chef_command=chef

alias cg="chef generate"
