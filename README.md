
Heroku Skeleton
-------------

This is inspired by Mike Dory's work on
https://github.com/mikedory/Tornado-Heroku-Quickstart


Description
-------------

Simple, one line environment build
out for Tornado web applications

Runs on Heroku, under gunicorn


This is a bash script. The python
packages are installed into an
application specific virtual env (venv)
Usage
------

    bash <(curl -fsSL "http://bitly.com/heroku-skeleton") ~/path/to/appdir
    cd ~/path/to/app
    bash app/scripts/runlocal.sh

  

Or, you can clone the git repository

    # Download build_env.sh to your computer.
    git clone https://github.com/gregory80/heroku-skeleton.git
    chmod +x build_env.sh
    ./build_env.sh ~/path/to/appdir

This script is destructive. Use only on clean, empty directories.

After you install, initialize a git repository, activate virtual env, start foreman

    cd ~/path/to/appdir
    git init . && git add . && git commit -m "initial commit"
    source venv/bin/activate
    foreman start --procfile=Procfile 


Structure
---------

Installs the following python packages to virtual env

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
            runlocal.sh
        templates/
            main.html
    venv/
        bin/
            activate
    Procfile
    requirements.txt
    README.md



Activate virtual env
--------------
Activate the virtual env to enable the 
same pacakages that run under runlocal.sh

    source venv/bin/activate

Running foreman
--------------

    foreman start --procfile=Procfile 


Additional Information
------------------

Get environmental package config values using pip freeze.
Example

    pip freeze > requirements.txt 


Procfile is setup to be controlled via ruby's foreman. 
You may consider creating a Dev_Procfile for local
development

Enviromental config variables simulated in 
<code>.env</code> file, primarily  ENV, PORT and memcache values


gunicorn for heroku start code via 
https://github.com/mccutchen


Requirements
--------------

1. tornado 2.4
1. python 2.7
1. virtual env




