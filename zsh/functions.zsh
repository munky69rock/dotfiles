function exists(){ test -e $1 }
function executable() { which $1 &> /dev/null }
function exec_if_exectable() { executable $1 && shift && $@ }
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

function g() {
  local repo=""
  if [ -n "$1" ]; then
    repo=$(ghq list | peco --select-1 --query "$1")
  else
    repo=$(ghq list | peco --select-1)
  fi

  if [ -n "$repo" ]; then
    cd $(ghq root)/$repo
  fi
}

function gb() {
  local branch=$(git branch | grep -v '*' | tr -d ' ' | peco --select-1 --query "$1")
  if [ -n "$branch" ]; then
    git checkout $branch
  fi
}

function h() {
  local history=""
  if [ -n "$1" ]; then
    history=$(\history -n 1 | tail -r | peco --select-1 --query "$1")
  else
    history=$(\history -n 1 | tail -r | peco --select-1)
  fi
  if [ -n "$history" ]; then
    print -z $history
  fi
}

function d() {
  local dir=""
  if [ -n "$1" ]; then
    dir=$(dirs -p | grep -v '^~$' | peco --select-1 --query "$1")
  else
    dir=$(dirs -p | grep -v '^~$' | peco --select-1)
  fi
  if [ -n "$dir" ]; then
    cd "${dir/\~/$HOME}"
  fi
}

function t() {
  local session=""
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
  tmux new -s ${$(basename $(pwd))/.*/}
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
  pbpaste | perl -pe 's/## $1/\[\* ([^\]]+)]/;s/\[([^\]]+)\]\(([^\)]+)\)/\[$2 $1\]/' | pbcopy
}

# anyenv
function clear_anyenv_path() {
  export PATH=$(echo $PATH | tr ":" "\n" | grep -v ".anyenv" | tr "\n" ":")
}

# vim: set syn=sh :
