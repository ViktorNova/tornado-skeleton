#!/bin/bash
#
#
# author: gregory tomlinson
# copyright: 2013
# Liscense: MIT
# 
# 
# Usage:
#     bash <(curl -fsSL "http://bitly.com/heroku-skeleton") ~/pah/myfunkkyapp
# 
# Strongly influenced by
# the great work by mike dory on Tornado-Heroku-Quickstart
# https://github.com/mikedory/Tornado-Heroku-Quickstart
#
# this is customized for my "style" of app format
# Assumes ruby Foreman is installed, adds
# ec2 support via boto. see README.md
#
# Uses Foreman to manage the server process
# via gunicorn
# 
# gunicorn for heroku start code via 
# https://github.com/mccutchen
# 
if [ $# -lt 1 ]; then
  echo "APP folder path required"
  exit 0
fi

echo "Startin heroku-skeleton stub out, version 1.0"
echo "Creating application $1"
sleep 1
mkdir -p $1
pushd $1

mkdir -p app/scripts app/static
pushd app
# in the app folder
touch webapp.py __init__.py
mkdir -p static/js static/css static/graphics templates
cd static/js
echo "Get static JS files"
curl -O http://code.jquery.com/jquery-1.9.1.js
curl -O https://raw.github.com/jeffreytierney/newT/master/newT.js
popd

touch README.md requirements.txt .gitignore .env
virtualenv venv --distribute
source venv/bin/activate

# install some tornado packages
pip install tornado
pip install gunicorn
pip install redis
pip install pylibmc
pip install boto #ec2 / s3 connector

pip freeze > requirements.txt

# make virtual env

echo "This is a stub, for tornado on heroku" > README.md
echo "*.pyc" >> .gitignore
echo ".DS_Store" >> .gitignore
echo ".env" >> .gitignore
echo "venv/" >> .gitignore
echo 'ENV="dev"' >> .env
echo 'PORT=5000' >> .env
echo 'MEMCACHE_SERVERS="127.0.0.1"' >> .env

echo "web: gunicorn -k tornado --workers=4 --bind=0.0.0.0:\$PORT 'app.webapp:webapp()'" > Procfile


VAR1=$(cat <<EOF
import tornado
import tornado.options
import tornado.web
import os.path
import sys
import time
import os
import redis
import pylibmc
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

class BasicHandler(tornado.web.RequestHandler):

    @property
    def db(self):
        return self.application.db
    def render(self, *args, **kwargs):
        
        kwargs.update({
            "autoescape":None,
            })
        self.set_header("Cache-Control", "no-cache, no-store, max-age=0, must-revalidate")
        self.set_header("Pragma", "no-cache")
        if 'chromeframe' in self.request.headers.get('User-Agent', []):
            self.set_header("X-UA-Compatible","chrome=1")
        return super(BasicHTMLHandler, self).render(*args, **kwargs)

class MainHandler(BasicHandler):
    def get(self):
        self.finish("I am the main")

class Application(tornado.web.Application):

    def __init__(self):
        handlers = [
                (r"^/$", MainHandler),
                ]
        settings = dict(
            cookie_secret="CHANGEMEPL3Z",
            template_path=os.path.join(os.path.dirname(__file__), "templates"),
            static_path=os.path.join(os.path.dirname(__file__), "static"),
            debug=True,
            xheaders=True,
            autoescape=None,
        )
        tornado.web.Application.__init__(self, handlers, **settings)

def webapp():
    app = Application()
    return app

EOF
)


VAR2=$(cat <<EOF

<!DOCTYPE HTML>
<html>
<head>
  <meta http-equiv="content-type" content="text/html; charset=utf-8" />

  <title>{{page_title}}</title>
  
</head>
<body>
  This is the main

<script src="{{static_url("js/jquery-1.9.1.js")}}" type="text/javascript" charset="utf-8"></script>
<script src="{{static_url("js/newT.js")}}" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript" charset="utf-8">
var _example_var = {{json_encode({"foo":"bar"})}}
</script>
</body>
</html>

EOF
)
echo "${VAR1}" > webapp.py
echo "${VAR2}" > templates/main.html
# leave the app/ dir
popd

echo "Create a new Heroku app?"
select yn in "yes" "no"; do
    case $yn in
        yes ) ./heroku.sh; break;;
        no ) echo "skipped. run heroku.sh for new heroku apps"; break;;
    esac
done

echo "Your application $1"

exit 0

