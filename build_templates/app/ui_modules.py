
import os
import tornado.web

class BasicModule(tornado.web.UIModule):
	def _foo(self):
		pass

class JSFiles(BasicModule):
	def render(self, js_files):
		return self.render_string( "ui_modules/scripttag.html", 
			js_files=js_files, 
			current_env=os.environ.get("ENV"),
			compiled_name="compiled" )
		