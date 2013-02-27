#!/bin/bash
#
#
# author: gregory tomlinson
# copyright: 2013
# Liscense: MIT
# repos: https://github.com/gregory80/heroku-skeleton
# 
# 
# Usage:
#     bash <(curl -fsSL "http://bitly.com/heroku-skeleton") ~/path/to/app
#     cd ~/path/to/app
#     bash app/scripts/runlocal.sh #start server on port 5000
# 
# Strongly influenced by
# the work by mike dory on Tornado-Heroku-Quickstart
# https://github.com/mikedory/Tornado-Heroku-Quickstart
#
# this is customized for my "style" of app format
# Assumes ruby Foreman is installed, adds
# ec2 support via boto as well as
# redis and memcached via pylibmc 
# see README.md
#
# Uses Foreman to manage the server process
# via gunicorn
# 
# gunicorn for heroku start code via 
# https://github.com/mccutchen
# 
if [ $# -lt 1 ]; then
  echo "Usage: build_env.sh ../path/to/myapp"
  exit 1
fi

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


echo "Starting heroku-skeleton stub out, version 1.0"
echo "Report issues to github issues:"
echo "https://github.com/gregory80/heroku-skeleton"
echo "Creating application $1"
echo "...................."
sleep 1
#
# first create the directory
#
mkdir -p $1
pushd $1 > /dev/null
#
#
mkdir -p app/scripts app/static app/config
touch README.md requirements.txt .gitignore .env
# make virtual env
#
#
virtualenv venv --distribute
source venv/bin/activate

pushd app > /dev/null
# in the app folder
touch webapp.py __init__.py config/dev.conf scripts/runlocal.sh
#
#
mkdir -p static/js static/css static/graphics templates
pushd static/js > /dev/null
echo "Fetching static JS library files"
jsfiles=(
  'http://code.jquery.com/jquery-1.9.1.js' 
  'http://backbonejs.org/backbone.js'
  'http://underscorejs.org/underscore.js' 
  'https://raw.github.com/janl/mustache.js/master/mustache.js'
  )
for jsfile in ${jsfiles[@]}
do
  filepath=(${jsfile//\// })
  curl ${jsfile} -o ${filepath[${#filepath[@]}-1]} 2&> /dev/null
done
#
#
popd > /dev/null
#
# install some tornado packages
#ec2 / s3 connector
# redis and memcached
pip install tornado
pip install gunicorn 
pip install redis 
pip install pylibmc 
pip install boto 
pip install CoffeeScript
pip install lesscss
#
#
#
if [ -f "${SCRIPTDIR}/templates/webapp.py" ];
then
  # use the local copy
  echo "Use local file"
  WEBAPP_STR=$(<"${SCRIPTDIR}/templates/webapp.py")
  
else
  # fail over to remote
  WEBAPP_STR=<(curl -fsSL "https://raw.github.com/gregory80/heroku-skeleton/master/templates/webapp.py")  
fi

if [ -f "${SCRIPTDIR}/templates/main.html" ];
then
  echo "Use local file"   
  MAIN_STR=$(<"${SCRIPTDIR}/templates/main.html")
else
  WEBAPP_STR=<(curl -fsSL "https://raw.github.com/gregory80/heroku-skeleton/master/templates/main.html")  
fi

#value=$(<config.txt)
#
#
RUNSCRIPT_STR=$(cat <<EOF
#!/bin/bash
#
DIR="\$( cd "\$( dirname "\${BASH_SOURCE[0]}" )" && pwd )"
pushd \$DIR
pushd ../..
source venv/bin/activate
# start foreman
foreman start --procfile=./Procfile

exit 0
EOF
)
#
#
echo "${WEBAPP_STR}" > webapp.py
echo "${MAIN_STR}" > templates/main.html
echo "${RUNSCRIPT_STR}" > scripts/runlocal.sh
# leave the app/ dir
popd > /dev/null
#
# build the requirements file
#
pip freeze > requirements.txt
echo "This is a stub for tornado on heroku" > README.md
#
#
echo "*.pyc" >> .gitignore
echo ".DS_Store" >> .gitignore
echo ".env" >> .gitignore
echo "venv/" >> .gitignore
#
#
echo 'ENV="dev"' >> .env
echo 'PORT=5000' >> .env
echo 'MEMCACHE_SERVERS="127.0.0.1"' >> .env
#
#
echo 'app_name="my example app"' >> app/config/dev.conf
#
#
echo "web: gunicorn -k tornado --workers=4 --bind=0.0.0.0:\$PORT 'app.webapp:webapp()'" > Procfile
echo "...................................................."
echo "Your application $1"
echo "...................................................."
#
exit 0

