
Heroku Skeleton
-------------

This is inspired by Mike Dory's work on
https://github.com/mikedory/Tornado-Heroku-Quickstart


Description
-------------

Simple, one line environment builder for Tornado web apps.

Runs on Heroku. Leverages 
Redis & memcached, Gunicorn and automatic 
static file compiliation. 

Python packages are installed into an
application specific virtual env (venv)


Setup a Build Environment
-------------

The fastest way to setup in an enviroment. Creates a heroku-ready, 
deployable environment.

    bash <(curl -fsSL "http://bitly.com/heroku-skeleton") ~/path/to/appdir
    cd ~/path/to/app
    bash app/scripts/runlocal.sh #start server on 5000


Clone Repos and Setup a Build Environment
---------------

    # Download build_env.sh to your computer.
    git clone https://github.com/gregory80/heroku-skeleton.git
    bash heroku-skeleton/build_env.sh ~/path/to/appdir


After you install, initialize a git repository, activate virtual env, start foreman
Access your new Tornado application via http://localhost:5000

    cd ~/path/to/appdir
    bash app/scripts/runlocal.sh

Python Structure
---------

When INSTALL_PIP is true, installs the following python packages to virtual env

    tornado
    gunicorn
    redis
    pylibmc
    lxml


Folder Structure
--------------
Builds the following directory
and file structure

    app/
        static/
            js/
              jquery-1.9.1.js
              backbone.js
              mustache.js
              underscore.js
              app.js
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
    .env
    .gitignore

Additional Configuration
---------------------

You can source in and override variables
using boolean values. Set these in the home
directory here

    ~/.build_env.config

Some examples:

    INSTALL_PIP
    INTALL_VENV
    JS_FILES    
    APP_FILES
    BASE_GIT
    SCRIPTDIR    

Local or Remote
---------------
the build script will first attempt
to pull all template files from the
local build_templates/ directory.

Should any item fail, it will resort
to a cURL to to the git repository
and fill in files from the remote
version.

This means a local folder can 
be used to override any template files. You can easily
override this by setting a local build_templates folder
or if you are running via CURL download one-liner
set it to fetch from a different repository for 
overriding <code>BASE_GIT</code> in the ~/.build_env.config
file. For example, if you wanted to use your own fork.

Edit the config file.

    ~/.build_env.config

    # override the value
    BASE_GIT="https://github.com/<GIT USERNAME>/heroku-skeleton/tree/master"


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
1. foreman ( a ruby package )




