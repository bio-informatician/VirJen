from flask import Flask, render_template, request, url_for, redirect, session, jsonify, flash, Blueprint, abort, Response
from flask_login import login_required, LoginManager, UserMixin, login_user, logout_user
import bcrypt
import datetime   # This will be needed later
import os
import bson
from dotenv import load_dotenv
from pprint import pprint # to print on screen
from wtforms import Form, StringField, SelectField
from notpull import Configuration
from flask import Flask, render_template, request, redirect, url_for, session
from flask_mysqldb import MySQL
import MySQLdb.cursors
import re
from notpull import Configuration

import itertools 

colorlist = ["#CFAFAF", "#C54E4E", "#CD3333", "FF4500", "#FF3D0D", "#33b249", "#5adbb5", "#a881af", "#80669d", "#dd7973", "#ffbd03", "#CD5C5C", "#F08080", "#FA8072", "#E9967A", "#FFA07A"]
app = Flask(__name__)
mysql = MySQL()

app.secret_key = Configuration.SECRET_KEY

app.config['MYSQL_USER'] = Configuration.config['user']
app.config['MYSQL_PASSWORD'] = Configuration.config['password']
app.config['MYSQL_DB'] = Configuration.config['database']
app.config['MYSQL_HOST'] = Configuration.config['host']

# Intialize MySQL
mysql = MySQL(app)
  
@app.route('/')
@app.route('/index', methods =['GET', 'POST'])
def index():
    page = 'index.html'
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute('SELECT COUNT(*), COUNT(DISTINCT sample.taxonomy_id) FROM sample;')
    record_numbers = cursor.fetchone()
    print(record_numbers)
    table_data = [record_numbers['COUNT(*)'],0,0,record_numbers['COUNT(DISTINCT sample.taxonomy_id)']]
    return render_template('template.html', page=page, loggedin = session, tableinfo = table_data)



@app.route('/login', methods =['GET', 'POST'])
def login():
    page = 'login.html'
    msg = ''
    if request.method == 'POST' and 'username' in request.form and 'password' in request.form:
        username = request.form['username']
        password = request.form['password']
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM flaskuser WHERE username = % s AND password = % s', (username, password, ))
        account = cursor.fetchone()
        if account:
            session['loggedin'] = True
            session['id'] = account['id']
            session['username'] = account['username']
            msg = 'Logged in successfully !'
            page = 'portal.html'
        else:
            session['loggedin'] = False
            msg = 'Incorrect username / password !'
    print(session)
    return render_template('template.html', page=page, msg = msg, loggedin = session)
  
@app.route('/logout')
def logout():
    session.pop('loggedin', None)
    session.pop('id', None)
    session.pop('username', None)
    return redirect(url_for('index'))
  
@app.route('/register', methods =['GET', 'POST'])
def register():
    page = 'register.html'
    msg = ''
    if request.method == 'POST' and 'inputTitle' in request.form:
        title = request.form['inputTitle']
        name = request.form['inputName']
        username = request.form['inputUserName']
        password = request.form['inputPassword']
        email = request.form['inputEmail']
        organization = request.form['inputOrganization']
        researchdomain = request.form['inputResearch']

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM flaskuser WHERE username = % s', (username, ))
        account = cursor.fetchone()
        if account:
            msg = 'Error: This username already exists!'
        else: 
            cursor.execute('INSERT INTO flaskuser VALUES (NULL, % s, % s, % s, % s, % s, % s, % s)', (title, name, username, password, email, organization, researchdomain))
            mysql.connection.commit()
            msg = 'You have successfully registered !'
            page = 'portal.html'
        return render_template('template.html', page=page, msg = msg, loggedin = False)
    else:
        msg = 'Please fill out the form !'
        return render_template('template.html', page=page, msg = msg, loggedin = False)


@app.route('/search')
def search():
    page = 'search.html'
    termcatlist = ["taxonomy_id","genome_coverage","source_db","sample_accession_number","samplecomponent"]
    return render_template('template.html', page = page, loggedin = session, tclist = termcatlist)

@app.route('/dashboard')
def dashboard():
    page = 'dashboard.html'
    return render_template('template.html', page = page, loggedin = session)
    
@app.route('/baltimore')
def baltimore():
    page = 'baltimore.html'
    return render_template('template.html', page = page, loggedin = session) 

@app.route('/families')
def families():
    page = 'families.html'
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute('SELECT name FROM taxonomy WHERE name_type = % s', ("Phylum", ))
    namelist = set([i["name"] for i in cursor.fetchall()])

    elist = [{a:b} for (a, b) in zip(namelist, colorlist)]
    #elist = [{a:b} for (a, b) in itertools.zip_longest(namelist, colorlist)]
    print(elist)
    return render_template('template.html', page = page, loggedin = session, nlist = elist)

@app.route('/about')
def about():
    page = 'about.html'
    return render_template('template.html', page = page, loggedin = session)

@app.route('/faq')
def faq():
    page = 'faq.html'
    return render_template('template.html', page = page, loggedin = session)


@app.route('/guide')
def guide():
    page = 'guide.html'
    return render_template('template.html', page = page, loggedin = session)
    

@app.route('/ftp')
def ftp():
    page = 'ftp.html'
    return render_template('template.html', page = page, loggedin = session)
    