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
export EC2_HOME=/usr/local/ec2/ec2-api-tools-1.7.2.4
export PATH=$PATH:$EC2_HOME/bin
export DB_HOST_ADDR=192.168.59.103
export DB_HOST_PORT=5432
export API_REDIS_1_PORT_6379_TCP_ADDR=127.0.0.1
export API_REDIS_1_PORT_6379_TCP_PORT=6379
. "/usr/local/opt/nvm/nvm.sh"
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


# aliases
alias c='git commit -m'
alias a='git add .'
alias g='git'
alias b='bundle'
alias push='git push origin'
alias check='git checkout'
alias pm='git pull origin master'
alias telex='ssh william_pollet@52.30.18.32'
alias kisskissprod='ssh william_pollet@34.246.225.85'
alias lendoprod='ssh william_pollet@54.171.33.208'
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

function ppush ()
{
  be pronto run --exit-code
  if [ $? != 0 ]; then
    print "${RED}Pronto found somme errors... Fix them before pushing to master!${NORMAL}"
    return 1
  else
    print "${GREEN}No errors found by pronto, pushing to github!${NORMAL}"
  fi
  push
}

export BUNDLER_EDITOR="'/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl'"
export PATH="/usr/local/opt/mysql@5.5/bin:$PATH"
export PATH="/usr/local/opt/mysql@5.6/bin:$PATH"
export PATH="/usr/local/opt/mysql@5.6/bin:$PATH"
