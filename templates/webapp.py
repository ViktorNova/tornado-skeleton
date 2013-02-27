#!/usr/bin/python

"""
 A simple stub

 Includes: backbone.js, mustache.js, underscore.js
 and jQuery
"""
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


