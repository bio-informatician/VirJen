from flask import Flask, render_template, request, redirect, url_for, session
import mysql.connector
import re
from notpull import Configuration

app = Flask(__name__)

# Change this to your secret key (can be anything, it's for extra protection)
app.secret_key = Configuration.SECRET_KEY

# Enter your database connection details below
config = Configuration.config
cnx = mysql.connector.connect(**config)
cursor = cnx.cursor()

sql_query = """
    CREATE TABLE IF NOT EXISTS `flaskuser` (
    `id` int NOT NULL AUTO_INCREMENT,
    `username` varchar(50) NOT NULL,
    `password` varchar(255) NOT NULL,
    `email` varchar(100) NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=UTF8MB4;
"""

# INSERT INTO `accounts` (`id`, `username`, `password`, `email`) VALUES (1, 'test', 'test', 'test@test.com'); """
cursor.execute(sql_query)

cnx.close()