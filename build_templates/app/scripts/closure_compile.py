

# connect to closure compiler service web api

import tornado.options
from StringIO import StringIO

import httplib, urllib, sys
# from lxml import etree
# import beautifulsoup4
import os.path
import urlparse
import sys
from bs4 import BeautifulSoup

# Define the parameters for the POST request and encode them in
# a URL-safe format.
# ADVANCED_OPTIMIZATIONS
tornado.options.define("compilation_level", default="SIMPLE_OPTIMIZATIONS", type=str)
def read_url( host, path, params, method_type="GET" ):

	headers = {}
	if method_type == "POST":
		headers = { "Content-type": "application/x-www-form-urlencoded" }
	conn = httplib.HTTPConnection(host)
	conn.request(method_type, '%s' % path, params, headers)
	response = conn.getresponse()
	data = response.read()
	conn.close()
	return data		

def find_scriptsrc(html_str):
	soup = BeautifulSoup(html_str)	
	found_tags = soup.find_all("script", src=True)
	return [tag.get("src") for tag in found_tags]

def write_file(path, _str):
	f = open(path, 'w')
	f.write(_str)
	f.close()
def get_url(default_url="http://localhost:5000/"):
	if len(sys.argv) > 1:
		url = sys.argv[1]
	else:
		url = default_url
	return url

def compile_static_str( script_str, output="compiled_code" ):
	params = [   
	    ('output_format', 'text'),
	    ('js_code', script_str),
	    ('compilation_level', tornado.options.options.compilation_level),	    
	    ('output_info', output),
	]
	params_str = urllib.urlencode(params)
	closure_host = 'closure-compiler.appspot.com'
	return read_url(closure_host, '/compile', params_str, method_type="POST")
	

if __name__ == "__main__":

	config_path = os.path.join(os.path.dirname(__file__), "../config/%s.conf" % os.environ.get("ENV", "dev"))
	tornado.options.parse_config_file( config_path )
	url = get_url()
	_data = urlparse.urlparse(url)
	print _data
	compile_host = _data.netloc

	# find script tags, parsing HTML response
	try:
		urldata = read_url(compile_host, _data.path or "/", "")
	except Exception,e:
		print "ERROR, service not started"
		sys.exit(1)
	script_srcs = find_scriptsrc(urldata)
	script_str = ""
	for scripts in script_srcs:
		# fetch script contents
		script_str += read_url(compile_host, scripts, "")

	print compile_static_str(script_str, output="errors")
	# get stats for what we are compiling
	print compile_static_str(script_str, output="statistics")
	# print script_str
	# pass
	compiled_str = compile_static_str( script_str )
	filepath = os.path.join(os.path.dirname(__file__), "..", "static/js/compiled.js")
	print "Compiled length %s" % len(compiled_str)
	print "writing JS compiled string to %s" % filepath
 	write_file(filepath, compiled_str)	


	
