
Heroku Skeleton
-------------

Simple, one line environment builder for Tornado web apps.

Supports Procfile start / stop. Ideal for heroku

Adds static JS file compilation via Google Closure Compiler
web service API. Compile static files on any machine with an
internet connection. No need to install Java!

Leverages environmental specific configuration files.

Inspiration
------------

This is inspired by Mike Dory's work on
https://github.com/mikedory/Tornado-Heroku-Quickstart as well as 
[Ruby on Rails](http://rubyonrails.org/) fully integrated development
environment.

Setup a Build Environment
-------------

The fastest way to setup in an enviroment. Creates a heroku-ready, 
deployable environment in seconds.

    bash <(curl -fsSL "http://bitly.com/heroku-skeleton") ~/path/to/appdir
    cd ~/path/to/appdir
    bash app/scripts/runlocal.sh #starts server on http://localhost:5000


Clone Repos and Setup a Build Environment
---------------

Download build_env.sh to your computer using GIT

    git clone https://github.com/gregory80/heroku-skeleton.git
    bash heroku-skeleton/build_env.sh ~/path/to/appdir


After you install, initialize a git repository, activate virtual env, start the server
Once started, access your new Tornado application via http://localhost:5000

    cd ~/path/to/appdir
    bash app/scripts/runlocal.sh

Python Structure
---------

When INSTALL_PIP is true, installs the following python packages to your
application specific virtual env

    tornado
    gunicorn
    redis
    pylibmc
    beatutifulsoup4


Folder Structure
--------------
Builds the following directory
and file structure

    app/
        webapp.py
        ui_modules.py
        config/
            dev.conf
        hooks/
            pre-commit-msg.sh
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
            compile.sh
            closure_compile.py
        templates/
            main.html        
            ui_modules/
                scripttag.html
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
The build script will first attempt to utilize all template files from the
local build_templates/ directory.

Should any file fail, script will make a cURL call to the git repository
and fill in files from the remote version.

This means a local folder can 
be used to override any template files. You can easily
override this by setting a local build_templates folder
or if you are installing via cURL download one-liner
set it to fetch from a different repository for 
overriding <code>BASE_GIT</code> in the ~/.build_env.config
file. For example, if you wanted to use your own fork, edit 
the <code>~/.bash_env.config</code> in your home directory.


Edit the config file
-----------------

    ~/.build_env.config

    # override the value
    BASE_GIT="https://github.com/<GIT USERNAME>/heroku-skeleton/tree/master"


Activate virtual env
--------------
Activate the virtual env to enable the 
same pacakages that run under runlocal.sh

    source venv/bin/activate

Running honcho
--------------

Locally, starting the service to also include setting in your 
.env file, is done with honco 


    honcho start --procfile=Procfile 


Compilation Rules
-----------------
The JavaScript files are compiled with each commit, using the pre-commit-msg hook. 
Applications are assumed to be Single Page Applications. The compilation
script queries the HTML via the running webserver.

Script tags are parsed from the http://localhost:5000/. All scripts are 
subsequently queried to form a single, raw string.

This string of JavaScript code is sent to google closure compiler web service API
using the ADVANCED_COMPILATIONS option. 

Compiled script is substitued for individual files in any environment besides DEV



Additional Information
------------------

Get environmental package config values using pip freeze.

    pip freeze > requirements.txt 


Procfile is setup to be controlled via honcho
You may consider creating a Dev_Procfile for local
development

Enviromental config variables simulated in 
<code>.env</code> file, primarily  ENV, PORT and memcached host values.


gunicorn for heroku start code via 
https://github.com/mccutchen



Requirements
--------------

1. python 2.7
1. virtual env





