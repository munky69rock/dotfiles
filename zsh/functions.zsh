function exists(){ test -e $1 }
function executable() { which $1 &> /dev/null }
function exec_if_exectable() { executable $1 && shift && $@ }
function exec_if_exists() { exists $1 && shift && $@ }
function source_if_exists() { exists $1 && . $1 }

function lt() { ls -ltrsa "$@" | tail; }
function psgrep() { ps axuf | grep -v grep | grep "$@" -i --color=auto; }
function fname() { find . -iname "*$@*"; }
function remove_lines_from() { grep -F -x -v -f $2 $1; }
function mcd() { mkdir $1 && cd $1; }
function tsync() {
  if [ $# -eq 2 ]; then
	tar cz $1 | ssh $2 "tar xz"
  else
    echo "tsync [src] [dst]"
  fi
}

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

function xcode-uiid() {
  defaults read /Applications/Xcode.app/Contents/Info DVTPlugInCompatibilityUUID
}

# vim: set syn=sh :