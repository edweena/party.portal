'use strict'

app = require('angular').module('partyApp')

app.filter 'reverse', require './reverse.filter'
