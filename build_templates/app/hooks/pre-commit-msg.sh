#!/bin/bash
#
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# echo $DIR
BASE_DIR=${DIR}/../../app
python ${BASE_DIR}/scripts/closure_compile.py
rc=$?
if [[ $rc != 0 ]] ; then
	echo "ALERT: Compilation NOT RUNNING"
	echo "Start webapp server to compile files"
	echo "during commits"
	echo "Exited code" $rc
    # exit $rc
else
	echo "Adding compiled.js to GIT"
	git add ${BASE_DIR}/static/js/compiled.js
fi
#
#
exit 0