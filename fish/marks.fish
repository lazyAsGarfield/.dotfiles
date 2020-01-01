# http://jeroenjanssens.com/2013/08/16/quickly-navigate-your-filesystem-from-the-command-line.html
export MARKPATH=$HOME/.marks

function jump
  if [ -z $argv[1] ]
    ls -l "$MARKPATH" | tr -s ' ' | cut -d' ' -f9- | awk NF | awk -F ' -> ' '{printf "    %-10s -> %s\n", $1, $2}'
  else
    if ! cd "$MARKPATH/$argv[1]"
      echo "No such mark: $argv[1]"
    end
  end
end

complete -e -c jump
complete -x -c jump -a '(ls -l "$MARKPATH" | tr -s " " | cut -d" " -f9,11- | awk NF | sed "s/ /"\t"/")'

function mark
  mkdir -p "$MARKPATH"; ln -s (pwd) "$MARKPATH/$argv[1]"
end

function unmark
  rm -i "$MARKPATH/$argv[1]"
end
