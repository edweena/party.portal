'use strict'

app = require('angular').module('partyApp')

app.filter 'reverse', require './reverse.filter'
app.filter 'trusted', require './trusted.filter'
