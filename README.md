

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
  # Download build_env.sh to your computer.
  chmod +x build_env.sh
  ./build_env.sh ~/tmp/path/to/appdir

This script is destructive. Use only on clean, empty, directories.

After you install, initialize a git repository,
and active venv

    source venv/bin/activate


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

Run Foreman
--------------

    foreman start --procfile=Procfile 


Additional Information
------------------

boto is added for ec2 / s3 support. Redis
and Memcached are added as well as gunicorn

    pip freeze > requirements.txt 
builds the  virtual environment.

Procfile is setup to be controlled via ruby's Foreman. 
You may consider creating a DEV_Procfile for local
development

Enviromental settings simulated in 

    .env



