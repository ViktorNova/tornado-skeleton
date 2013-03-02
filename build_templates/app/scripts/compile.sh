#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd $DIR > /dev/null
# source in env variables
. ../../venv/bin/activate
. ../../.env
python closure_compile.py http://localhost:${PORT}/
popd
exit 0