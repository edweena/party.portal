'use strict'

app = require('angular').module('partyApp')

app.factory 'Twitter', require './twitter.service'
app.factory 'Auth', require './auth.service'
app.factory 'Graphics', require './graphics.service'
app.factory 'PhotoFetch', require './photofetch.service'