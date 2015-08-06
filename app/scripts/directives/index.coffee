'use strict'

app = require('angular').module('partyApp')

app.directive('partyPeople', require('./people.directive'))

# app.controller('MainCtrl', require('./main.controller'))
# app.controller('LoginCtrl', require('./login.controller'))