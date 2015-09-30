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
    if [[ "$OSTYPE" == darwin* ]]; then
      local accurate=$(stat -f%m .gulp_tasks)
      local changed=$(stat -f%m gulp/tasks/**/* Gulpfile.js | sort -nr | head -n1)
    else
      local accurate=$(stat -c%Y .gulp_tasks)
      local changed=$(stat -c%Y gulp/tasks/**/* Gulpfile.js | sort -nr | head -n1)
    fi
    return $(expr $accurate '>=' $changed)
  fi
}

_gulp_generate () {
  gulp --silent --tasks-simple | cut -d " " -f 2 > .gulp_tasks
}

_gulp () {
  if [ -f Gulpfile.js ]; then
    if _gulp_task_list_needs_refresh; then
      echo "\nGenerating .gulp_tasks..." > /dev/stderr
      _gulp_generate
    fi
    compadd `cat .gulp_tasks`
  fi
}

compdef _gulp gulp
alias gulp_refresh='_gulp_refresh'
