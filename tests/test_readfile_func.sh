#!/bin/bash

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
function readTmplFile {
  echo $1
  if [ -f "$1" ];
  then
    # use the local copy
    # echo "Use local file: $1"
    echo $("$1")
    
  else
    # fail over to remote
    # echo "Use remote file"
    echo $(curl -fsSL "$2")  
  fi
  return 0
}

WEBAPP_STR=$(readTmplFile "${SCRIPTDIR}/templates/webapp.py" "https://raw.github.com/gregory80/heroku-skeleton/master/templates/webapp.py")
echo $WEBAPP_STR