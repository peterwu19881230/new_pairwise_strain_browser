#ref: https://pythonspot.com/flask-with-static-html-files/

from flask import Flask, render_template, request
from flask_mysqldb import MySQL #has to install the package
##to install packages,do this : pip3.8 install (your_package) --user
import yaml #in the original video it was just yaml. pyaml might be a replacement for it

app = Flask(__name__)

#configure mysql
##ref: https://www.youtube.com/watch?v=6L3HNyXEais #use safe_load instead of load (https://github.com/yaml/pyyaml/wiki/PyYAML-yaml.load(input)-Deprecation)


db=yaml.safe_load(open('db.yaml'))
##in the db.yaml file there has to be a space between the key and the text (otherwise it won't be parsed properly)



app.config['MYSQL_HOST']=db['mysql_host']
app.config['MYSQL_USER']=db['mysql_user']
app.config['MYSQL_PASSWORD']=db['mysql_password']
app.config['MYSQL_DB']=db['mysql_db']
mysql= MySQL(app)

@app.route('/mysql/')
def get_mysql_data():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM strain_similarity")
    result = cur.fetchall()
    return render_template('mysql.html',result=result)



@app.route('/') #home page
def is_home():
	return "This is home"


@app.route('/main/') #home page
def get_main():
	return render_template('main.html')


@app.route('/hello/') #when in the url there's nothing after the home url, route to return "Hello World!"
def hello():
	return "Hello World!"

#read html by getting names from templates/
'''
@app.route('/<string:page_name>/',methods=['GET'])
def render_static(page_name):
    return render_template('%s.html' % page_name)
'''

#I can use this to get current directory: /home/peterwu19881230/mysite
@app.route('/current_dir/')
def get_current_dir():
  import os
  current_dir=os.getcwd()
  return current_dir


if __name__ == '__main__':
    app.run()