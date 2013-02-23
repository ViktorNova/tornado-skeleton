

Heroku Skeleton
-------------

This is inspired by Mike Dory's work
https://github.com/mikedory/Tornado-Heroku-Quickstart

This is a bash script. Relies on 
virtual env, which Heroku explicitly
names in their documentation.

Usage
------

  bash <(curl -fsSL "http://bitly.com/heroku-skeleton") ~/pah/myfunkkyapp
  

How to build your environment. The slower way

  ./build_env.sh ~/tmp/path/to/appdir

This script is destructive. Use on clean directories.


Structure
---------

Installs the following python
packages to virtual env

  tornado
  gunicorn
  redis
  pylibmc
  boto

Builds the following directory
and file structure

app/
    static/
        js/
          jquery-1.9.1.js
          newT.js
        css/
        graphics/
    scripts/
    templates/
        main.html
venv/
Procfile
requirements.txt



Activate virtual env
--------------

  source venv/bin/activate


Additional Information
------------------

boto is added for ec2 / s3 support. Redis
and Memcached are added as well as gunicorn

pip freeze > requirements.txt builds the 
virtual enviroment.

Procfile is setup to be controlled via ruby's Foreman

