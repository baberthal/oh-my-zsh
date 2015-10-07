# Some aliases for zeus. (See: https://github.com/burke/zeus)
# Zeus preloads your Rails environment and forks that process whenever
# needed. This effectively speeds up Rails' boot process to under 1 sec.

# Init
alias zi='zeus init'
alias zinit='zeus init'

# Start
alias zs='zeus start'
alias ztart='zeus start'

# Console
alias zc='zeus console'
alias zonsole='zeus console'

# Server
alias zsr='zeus server'
alias zerver='zeus server'

# Rake
alias zr='noglob zeus rake'
alias zake='noglob zeus rake'

# Generate
alias zg='zeus generate'
alias zenerate='zeus generate'
alias zd='zeus destroy'

# Runner
alias zrn='zeus runner'
alias zunner='zeus runner'

# Cucumber
alias zcu='zeus cucumber'
alias zucumber='zeus cucumber'

# Rspec
alias zspec='zeus rspec'

# Test
alias zt='zeus test'
alias zest='zeus test'

alias zu='zeus test test/unit/*'
alias zunits='zeus test test/unit/*'

alias zf='zeus test test/functional/*'
alias zunctional='zeus test test/functional/*'

alias za='zeus test test/unit/*; zeus test test/functional/; zeus cucumber'
alias zall='zeus test test/unit/*; zeus test test/functional/; zeus cucumber'

# Clean up crashed zeus instances.
alias zsw='rm .zeus.sock'
alias zweep='rm .zeus.sock'

# Reset database
alias zdbr='zeus rake db:reset db:test:prepare'
alias zdbreset='zeus rake db:reset db:test:prepare'

# Migrate and prepare database
alias zdbm='zeus rake db:migrate db:test:prepare'
alias zdbmigrate='zeus rake db:migrate db:test:prepare'

# Create database
alias zdbc='zeus rake db:create'

# Create, migrate and prepare database
alias zdbcm='zeus rake db:create db:migrate db:test:prepare'

_zake_refresh () {
    if [ -f .zake_tasks ]; then
        rm .zake_tasks
    fi
    echo "Generating .zake_tasks..." > /dev/stderr
    _zake_generate
    cat .zake_tasks
}

_zake_does_task_list_need_generating () {
    if [ ! -f .zake_tasks ]; then return 0;
    else
        if [[ "$OSTYPE" = darwin* ]]; then
            accurate=$(stat -f%m .zake_tasks)
            changed=$(stat -f%m Rakefile)
        else
            accurate=$(stat -c%Y .zake_tasks)
            changed=$(stat -c%Y Rakefile)
        fi
        return $(expr $accurate '>=' $changed)
    fi
}

_zake_generate () {
    rake --silent --tasks | cut -d " " -f 2 > .zake_tasks
}

_zake () {
    if [ -f Rakefile ]; then
        if _zake_does_task_list_need_generating; then
            echo "\nGenerating .zake_tasks..." > /dev/stderr
            _zake_generate
        fi
        compadd `cat .zake_tasks`
    fi
}

compdef _zake zake
alias zake_refresh='_zake_refresh'
