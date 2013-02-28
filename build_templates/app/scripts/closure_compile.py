

# connect to closure compiler service web api

import tornado.options
from StringIO import StringIO

import httplib, urllib, sys
from lxml import etree
import os.path
import urlparse
import sys
# Define the parameters for the POST request and encode them in
# a URL-safe format.

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

def build_params(src_lst):
	args = [
	    ('output_format', 'text'),
		('compilation_level', 'SIMPLE_OPTIMIZATIONS'),	    
	    ('output_info', 'compiled_code'),
	]
	lst = [('code_url', src) for src in src_lst]
	args.extend(lst)
	return args

def query_select_all(html_str, xpath_str):
	parser = etree.HTMLParser()	
	tree = etree.parse(StringIO(urldata), parser)	
	found_tags = tree.xpath( xpath_str )
	return found_tags

def write_file(path, _str):
	f = open(path, 'w')
	f.write(_str)
	f.close()

if __name__ == "__main__":
	if len(sys.argv) > 1:
		url = sys.argv[1]

	else:
		url = "http://localhost:5000/"
	_data = urlparse.urlparse(url)
	print _data
	compile_host = _data.netloc
	urldata = read_url(compile_host, _data.path or "/", "")

	script_tags = query_select_all(urldata, '//script[@src]')
	script_srcs = [tag.get("src") for tag in script_tags]
	script_str = ""
	for scripts in script_srcs:
		script_str += read_url(compile_host, scripts, "")

	# print script_str
	# pass
	params = [   
	    ('output_format', 'text'),
	    ('js_code', script_str),
		('compilation_level', 'SIMPLE_OPTIMIZATIONS'),	    
	    ('output_info', 'compiled_code'),
	]
	params_str = urllib.urlencode(params)
	closure_host = 'closure-compiler.appspot.com'
	compiled_str = read_url(closure_host, '/compile', params_str, method_type="POST")
	filepath = os.path.join(os.path.dirname(__file__), "..", "static/js/compiled.js")
	write_file(filepath, compiled_str)


	