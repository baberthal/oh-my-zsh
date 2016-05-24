_gulp_refresh () {
  if [ -f .gulp_tasks ]; then
    rm .gulp_tasks
  fi
  echo "Generating .gulp_tasks..." > /dev/stderr
  _gulp_generate
  cat .gulp_tasks
}

_gulp_task_list_needs_refresh () {
  if [ ! -f .gulp_tasks ]; then return 0;
  else
    local gulpfile=$(_gulpfile)
    if [[ "$OSTYPE" == darwin* ]]; then
      local accurate=$(stat -f%m .gulp_tasks)
      local changed=$(stat -f%m tools/tasks/**/* "${gulpfile}" | sort -nr | head -n1)
    else
      local accurate=$(stat -c%Y .gulp_tasks)
      local changed=$(stat -c%Y gulp/tasks/**/* "${gulpfile}" | sort -nr | head -n1)
    fi
    return $(expr $accurate '>=' $changed)
  fi
}

_gulp_generate () {
  gulp --silent --tasks-simple | cut -d " " -f 2 > .gulp_tasks
}

_gulpfile() {
  local possible=$(ls Gulpfile.* 2>/dev/null)

  if [[ -f "${possible}" ]]; then
    echo "${possible}" && return 0
  else
    return 1
  fi
}

_gulp () {
  local gulpfile=$(_gulpfile)
  if [[ -f "${gulpfile}" ]]; then
    if _gulp_task_list_needs_refresh; then
      echo "\nGenerating .gulp_tasks..." > /dev/stderr
      _gulp_generate
    fi
    compadd `cat .gulp_tasks`
  fi
}

compdef _gulp gulp
alias gulp_refresh='_gulp_refresh'
