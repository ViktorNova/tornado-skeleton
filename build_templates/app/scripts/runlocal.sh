#!/bin/bash
#
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $DIR
pushd ../..
source venv/bin/activate
# start foreman, for local dev
honcho start --procfile=./Procfile
#
exit 0