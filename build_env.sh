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
#     bash app/scripts/runlocal.sh
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
echo "Get static JS files"
curl -O http://code.jquery.com/jquery-1.9.1.js
curl -O https://raw.github.com/jeffreytierney/newT/master/newT.js
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
#
#
WEBAPP_STR=$(cat <<EOF
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

tornado.options.define("app_name", type=str)

class BasicHTMLHandler(tornado.web.RequestHandler):

    def render(self, *args, **kwargs):
        
        kwargs.update({
            "autoescape":None,
            })
        self.set_header("Cache-Control", "no-cache, no-store, max-age=0, must-revalidate")
        self.set_header("Pragma", "no-cache")
        if 'chromeframe' in self.request.headers.get('User-Agent', []):
            self.set_header("X-UA-Compatible","chrome=1")
        return super(BasicHTMLHandler, self).render(*args, **kwargs)

class MainHandler(BasicHTMLHandler):
    def get(self):
        logger.info("Hp request %s" % self.request)
        self.render(
            "main.html",
            page_title="Heroku & Tornado",
            )

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
    config_path = os.path.join(os.path.dirname(__file__), "config/%s.conf" % os.environ.get("ENV", "dev"))
    tornado.options.parse_config_file( config_path )
    logger.debug("Using config path: %s" % config_path)
    logger.debug(tornado.options.options) 
    app = Application()
    return app

EOF
)
#
#
#
MAIN_STR=$(cat <<EOF

<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<title>{{page_title}} | App</title>  
</head>
<body>
  <div class="container">
    This is the main container
  </div>

<script src="{{static_url("js/jquery-1.9.1.js")}}" type="text/javascript" charset="utf-8"></script>
<script src="{{static_url("js/newT.js")}}" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript" charset="utf-8">
var _example_var = {{json_encode({"foo":"bar"})}}
</script>
</body>
</html>

EOF
)
#
#
RUNSCRIPT_STR=$(cat <<EOF
#!/bin/bash

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

