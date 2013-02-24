
Heroku Skeleton
-------------

This is inspired by Mike Dory's work on
https://github.com/mikedory/Tornado-Heroku-Quickstart


Description
-------------

Simple, one line environment build
out for Tornado web applications

Runs on Heroku, under gunicorn


This is a bash script. Relies on 
virtual env, which Heroku explicitly
names in their documentation.

Usage
------

    bash <(curl -fsSL "http://bitly.com/heroku-skeleton") ~/path/to/appdir
  

Or, you can clone the git repository

    # Download build_env.sh to your computer.
    git clone https://github.com/gregory80/heroku-skeleton.git
    chmod +x build_env.sh
    ./build_env.sh ~/path/to/appdir

This script is destructive. Use only on clean, empty directories.

After you install, initialize a git repository, active venv, start foreman

    cd ~/path/to/appdir
    git init . && git add . && git commit -m "initial commit"
    source venv/bin/activate
    foreman start --procfile=Procfile 


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
    README.md



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

Builds the  virtual environment.

Procfile is setup to be controlled via ruby's Foreman. 
You may consider creating a DEV_Procfile for local
development

Enviromental settings simulated in, chiefly ENV, PORT and memcache
values

    .env



gunicorn for heroku start code via 
https://github.com/mccutchen


Requirements
--------------

tornado 2.4
python 2.7
virtual env




