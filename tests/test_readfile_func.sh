#!/bin/bash

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
function readTmplFile {
  # echo $1
  if [ -f "$2" ];
  then
    # use the local copy
    # echo "Use local file: $1"
    # echo $("$1")
    echo ""
    echo "printing string"
    cat $2 > temp_test/webapp.py
  else
    echo $1
    # fail over to remote
    # echo "Use remote file $2"
    curl -fsSL "$3" -o "temp_test/$1" 2>/dev/null
  fi
  return 0
}

mkdir -p "temp_test/app"
readTmplFile "app/webapp.py" "${SCRIPTDIR}/build_templates/app/webapp.py" "https://raw.github.com/gregory80/heroku-skeleton/master/build_templates/app/webapp.py"
cat temp_test/app/webapp.py