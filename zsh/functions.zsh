function exists(){ test -e $1 }
function executable() { which $1 &> /dev/null }
function exec_if_executable() { executable $1 && $@ }
function exec_if_exists() { exists $1 && shift && $@ }
function source_if_exists() { exists $1 && . $1 }

function today() { date +"%Y%m%d" }
function now() { date +"%Y%m%d%H%M%S" }
function unixtime() { date +"%s" }

function psgrep() {
    if [ "$(uname -s)" = "Darwin" ]; then
      ps aux | grep -v grep | grep "$@" -i --color=auto
    else
      ps aufx | grep -v grep | grep "$@" -i --color=auto
    fi
}
function fname() { find . -iname "*$@*"; }
function mcd() { mkdir $1 && cd $1; }
function tsync() {
  if [ $# -eq 2 ]; then
    tar cz $1 | ssh $2 "tar xz"
  else
    echo "tsync [src] [dst]"
  fi
}

# peco
function gr() {
  local row=""
  local fn=""
  local line=""

  if [ -n "$1" ]; then
    if executable rg; then
      row=$(rg -n "$1" | peco --select-1 --query "$1")
    elif executable ag; then
      row=$(ag "$1" | peco --select-1 --query "$1")
    else
      row=$(grep "$1" -R * | peco --select-1 --query "$1")
    fi
  fi

  if [ -n "$row" ]; then
    fn=$(echo $row | cut -d ':' -f 1)
    line=$(echo $row | cut -d ':' -f 2)
    vim +$line $fn
  fi
}

function zle_search_git_repos() {
  local repo=""
  if [ -n "$1" ]; then
    repo=$(ghq list | sort | peco --select-1 --query "$1")
  else
    repo=$(ghq list | sort | peco --select-1)
  fi

  if [ -n "$repo" ]; then
    cd $(ghq root)/$repo
  fi
  zle reset-prompt
}

function zle_search_git_branch() {
  local branch=$(git branch | grep -v '*' | tr -d ' ' | peco --select-1 --query "$1")
  if [ -n "$branch" ]; then
    git checkout $branch
  fi
  zle reset-prompt
}

function zle_checkout_github_pr() {
  echo -ne "\nfetching github pr list ...\r"
  local pr=$(gh pr list | grep -v dependabot | peco --select-1 --query "$1")
  if [ -n "$pr" ]; then
    no=$(echo $pr | sed -Ee "s/^([0-9]+).*/\1/")
    echo -ne "checking out github pr ...\r"
    gh pr checkout $no
  fi
  echo -ne "\r"
  zle reset-prompt
}

function zle_search_history() {
  local history=""
  local reverse=""
  if executable tac; then
    reverse="tac"
  else
    reverse="tail -r"
  fi
  if [ -n "$1" ]; then
    history=$(\history -n 1 | $reverse | peco --select-1 --query "$1")
  else
    history=$(\history -n 1 | $reverse | peco --select-1)
  fi

  zle reset-prompt
  if [ -n "$history" ]; then
    BUFFER=$history
    CURSOR=${#BUFFER}

    #print -z $history
  fi
}


function t() {
  local session=""
  local cmd=""
  if [ -n "$1" ]; then
    session=$(tmux ls -F "#S" | peco --select-1 --query "$1")
  else
    session=$(tmux ls -F "#S" | peco --select-1)
  fi
  if [ -n "$session" ]; then
    if [ -z "$TMUX" ]; then
      cmd="attach"
    else
      cmd="switch-client"
    fi
    tmux $cmd -t $session
  fi
}

function tn() {
  local session=""
  local cmd=""

  if [ -f ".tmuxinator.yml" ]; then
    tmuxinator start
    return
  fi

  session=${$(basename $(pwd))//./-}
  if tmux has-session -t $session &> /dev/null; then
    if [ -z "$TMUX" ]; then
      cmd="attach"
    else
      cmd="switch-client"
    fi
    tmux $cmd -t $session
  else
    if [ -z "$TMUX" ]; then
      tmux new -s $session
    else
      tmux new -s $session -d
      tmux switch-client -t $session
    fi
  fi
}

function refresh_tmux() {
  if [ ! -z "$TMUX" ]; then
    tmux refresh-client -S
  fi
}

function xcode-uuid() {
  defaults read /Applications/Xcode.app/Contents/Info DVTPlugInCompatibilityUUID
}

function xcode-plugin-build() {
  xcodebuild -configuration Release
}

function gen-autoenv-pyvenv() {
  echo "source bin/activate" > .autoenv.zsh
  echo "deactivate"          > .autoenv_leave.zsh
  cd ..
  cd -
  cd ..
  cd -
}

# Mac
function pbtable() {
  local -A opthash
  zparseopts -D -M -A opthash -- p h -help=h
  if [ -n "$opthash[(i)-h]" ]; then
    cat <<-HELP

		Usage:
		  pbtable [options]

		Options:
		  -h, --help    Show this help message
		  -p            print table

		HELP
  elif [ -n "$opthash[(i)-p]" ]; then
    pbpaste | perl -pe 'BEGIN{ $i = 0 }; if ($i++ == 0) { for $c ("", "--") { print("|" . join("|", map { $c } split(/\t/, $_)) . "|\n") } } s/\t/ | /;s/^/| /;s/$/ |/'
  else
    pbpaste | perl -pe 'BEGIN{ $i = 0 }; if ($i++ == 0) { for $c ("", "--") { print("|" . join("|", map { $c } split(/\t/, $_)) . "|\n") } } s/\t/ | /;s/^/| /;s/$/ |/' | pbcopy
    echo copied!
  fi
}

function pbsb2md() {
  pbpaste | perl -pe 's/\[\* ([^\]]+)]/## $1/;s/\[(\S+) ([^\]]+)\]/[$2]($1)/' | pbcopy
}

function pbmd2sb() {
  pbpaste | perl -pe 's/## (.*)/\[\* $1]/;s/\[([^\]]+)\]\(([^\)]+)\)/\[$2 $1\]/;s/^\- / /;' | pbcopy
}

# anyenv
function clear_anyenv_path() {
  export PATH=$(echo $PATH | tr ":" "\n" | grep -v ".anyenv" | tr "\n" ":")
}

function strip_scrapbox_link() {
  pbpaste | perl -pe 's/    /  /g;s/\[([^\[\]\\(\)]*)\]\(https:\/\/scrapbox[^\)\[\]]*\)/$1/g' | pbcopy
}

function switch_dark_mode() {
  if [[ "$(uname -s)" == "Darwin" ]]; then
    local light="Light"
    local dark="Dark"
    local current=$(defaults read -g AppleInterfaceStyle 2>/dev/null)

    if [[ $current == $dark && $ITERM_PROFILE == $light ]]; then
      echo -ne "\033]50;SetProfile=Dark\a"
      export ITERM_PROFILE=$dark
    elif [[ -z "$current" && $ITERM_PROFILE == $dark ]]; then
      echo -ne "\033]50;SetProfile=$light\a"
      export ITERM_PROFILE=$light
    fi
  fi
}

# vim: set syn=sh :
