function gb
  git branch | grep -v '*' | perl -pe 's/^\s+//' | peco --select-1 --query "$argv" | read branch
  if [ $branch ]
    git checkout $branch
  end
end
