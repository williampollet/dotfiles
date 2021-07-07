ZSH=$HOME/.oh-my-zsh

# You can change the theme with another one:
#   https://github.com/robbyrussell/oh-my-zsh/wiki/themes
ZSH_THEME="robbyrussell"

# Useful plugins for Rails development with Sublime Text
plugins=(gitfast last-working-dir common-aliases sublime zsh-syntax-highlighting history-substring-search)

# Prevent Homebrew from reporting - https://github.com/Homebrew/brew/blob/master/share/doc/homebrew/Analytics.md
export HOMEBREW_NO_ANALYTICS=1
export PATH='~/.rbenv/shims:/usr/local/bin:/usr/local/share:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/sbin:/usr/local/share/npm/bin:/usr/X11/bin:/usr/texbin:~/bin'
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/9.3/bin
export PATH=$PATH:/Users/williampollet/Library/Python/2.7/bin
export EC2_HOME=/usr/local/ec2/ec2-api-tools-1.7.2.4
export PATH=$PATH:$EC2_HOME/bin
export DB_HOST_ADDR=192.168.59.103
export DB_HOST_PORT=5432
export API_REDIS_1_PORT_6379_TCP_ADDR=127.0.0.1
export API_REDIS_1_PORT_6379_TCP_PORT=6379
export GEMFURY_USER="kisskissbankbankandco"
export GEMFURY_API_TOKEN="FqDmiHzsLMUx9zFWoRrR"
export TELEX_HOST="http://52.30.18.32"
export TELEX_TOKEN=e4817a1410aeccc4f1294259a80f00d9195cd06d4619c7324432ea8fe3ccb67e
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

# Actually load Oh-My-Zsh
source "${ZSH}/oh-my-zsh.sh"

# Load rbenv if installed
export PATH="${HOME}/.rbenv/bin:${PATH}"
type -a rbenv > /dev/null && eval "$(rbenv init -)"

# Rails and Ruby uses the local `bin` folder to store binstubs.
# So instead of running `bin/rails` like the doc says, just run `rails`
# Same for `./node_modules/.bin` and nodejs
export PATH="./bin:./node_modules/.bin:${PATH}:/usr/local/sbin"

# Store your own aliases in the ~/.aliases file and load the here.
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# Encoding stuff for the terminal
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PATH=$PATH:/usr/local/mysql/bin
export DYLD_LIBRARY_PATH=/usr/local/mysql/lib:$DYLD_LIBRARY_PATH
export PGDATA=

# gringotts config
export GRINGOTTS_TOKEN=williampollet
export SANDBOX_PASSPHRASE=bUNbmkwiqo8CV3ienigfgjvSmGSJ4NJQFHAuVrXBwwTH6har0v


# aliases
alias c='git commit -m'
alias a='git add .'
alias g='git'
alias b='bundle'
alias push='git push origin'
alias check='git checkout'
alias gcb='git checkout -b'
alias gsquash='gpom && git reset --soft origin/master'
alias pm='git pull origin master'
alias telex='ssh william_pollet@52.30.18.32'
alias kisskissprod='ssh william_pollet@34.246.225.85'
alias lendoprod='ssh william_pollet@54.171.33.208'
alias gringottsprod='ssh william_pollet@52.213.67.205'
alias dataprod='ssh ec2-user@34.245.46.112'
alias clint='a && c "lint"'
alias gpom='git pull origin master'
alias pushlint='a && c "lint" && push'
alias ppushlint='a && c "lint" && ppush'
alias kisskiss='cd ~/Developer/repos/kisskissbankbank'
alias gringotts='cd ~/Developer/repos/gringotts'
alias lendo='cd ~/Developer/repos/kkbb-lendopolis'
alias dotfiles='cd ~/Developer/dotfiles'
alias credentials='cd ~/Developer/credentials'
alias gnb='git checkout -b'
alias branch='git branch'
alias newbranch='git checkout -b'
alias cmerge='a && c "fixing conflicts while merging master"'
alias killp='lsof -i tcp:${PORT_NUMBER} | awk 'NR!=1 {print $2}' | xargs kill'
alias be='bundle exec'
alias bi='bundle install'
alias dlsassymaps='cd ~/Developer/repos/kisskissbankbank/client/node_modules/kitten-components/vendor/assets/stylesheets/kitten/sassy-maps && npm install'
alias aliasline='echo "\e[1;35m------------------------------------------------------------\e[0m"'
alias boot='cd ~/Developer/dotfiles && osascript ./boot.scpt'
alias delete-squashed-branches='python ~/Developer/dotfiles/delete-squashed-branches'
alias lightboot='cd ~/Developer/dotfiles && osascript ./lightboot.scpt'
alias stashtrads='git checkout config/locales/'

alias ppushtest='safepush ppushtest'
alias ppush='safepush ppush'
alias prontorun='safepush prontorun'
alias ptest='safepush ptest'
alias pushandpr='safepush pushandpr'
alias test='safepush test'

function ls ()
{
   clear
   aliasline
   /bin/ls -la
   aliasline
   pwd
   aliasline
}

RED='\033[0;31m'
GREEN='\033[0;32m'
NORMAL='\033[0m'

function manualppush ()
{
  prontorunlight
  pushandpr
}


function manualppushtest ()
{
  test-or-create
  prontorun
  pushandpr
}

function manualprontotest ()
{
  test-or-create
  prontorun
}

function manualpushandpr ()
{
  if [ $? == 1 ]; then
    return 1
  fi

  print '##########################'
  print "## Pushing to Github... ##"
  print '##########################'
  git push origin

  if [ $? == 128 ]; then
    print "${GREEN}Syncing with github...${NORMAL}"

    git push --set-upstream origin $(git rev-parse --symbolic-full-name --abbrev-ref HEAD)

    if [ $? == 0 ]; then
      open "https://github.com/KissKissBankBank/kisskissbankbank/pull/new/$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)"
    fi
  fi
}

function prontorunlight ()
{
  print '#######################'
  print "## Running pronto... ##"
  print '#######################'

  be pronto run --exit-code

  if [ $? != 0 ]; then
    print "${RED}Pronto found somme errors... Fix them before pushing to master!${NORMAL}"
    return 1
  else
    print "${GREEN}No errors found by pronto, go for next step!${NORMAL}"
  fi
}

function manualprontorun ()
{
  if [ $? == 1 ]; then
    return 1
  fi

  print '#######################'
  print "## Running pronto... ##"
  print '#######################'

  be pronto run --exit-code

  if [ $? != 0 ]; then
    print "${RED}Pronto found somme errors... Fix them before pushing to master!${NORMAL}"
    return 1
  else
    print "${GREEN}No errors found by pronto, go for next step!${NORMAL}"
  fi
}

function manualspec-or-create ()
{
  if [ $? == 1 ]; then
    return 1
  fi

  print '##########################'
  print '## Testing new files... ##'
  print '##########################'
  ruby ~/Developer/dotfiles/rspecer.rb

  if [ $? == 1 ]; then
    print "${RED}Oops, a spec seems to be red or empty, be sure to complete it before you push${NORMAL}"
    return 1
  else
    print "${GREEN}Every spec operational, passing to the next step!${NORMAL}"
  fi
}

function manualtest-or-create ()
{
  print '##########################'
  print "## Testing new files... ##"
  print '##########################'

  ruby ~/Developer/dotfiles/rspecer.rb

  if [ $? == 1 ]; then
    print "${RED}Oops, a spec seems to be red or empty, be sure to complete it before you push${NORMAL}"
    return 1
  else
    print "${GREEN}Every spec operational, passing to the next step!${NORMAL}"
  fi
}

export BUNDLER_EDITOR="'/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl'"
export PATH="/usr/local/opt/mysql@5.5/bin:$PATH"
export PATH="/usr/local/opt/mysql@5.6/bin:$PATH"
export PATH="/usr/local/opt/mysql@5.6/bin:$PATH"

export NVM_DIR="${HOME}/.nvm"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
