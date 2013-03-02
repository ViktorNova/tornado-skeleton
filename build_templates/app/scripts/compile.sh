#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $DIR > /dev/null
# virtual env
. ../../venv/bin/activate
# source in env variables
. ../../.env
python closure_compile.py http://localhost:${PORT}/
popd
exit 0