function g
  if [ "$argv" ]
    ghq list | peco --select-1 --query "$argv" | read repo
  else
    ghq list | peco | read repo
  end

  if [ $repo ]
    cd (ghq root)/$repo
  end
end
