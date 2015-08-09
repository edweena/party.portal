'use strict'

app = require('angular').module('partyApp')

app.directive 'partyPeople', require './people.directive'
app.directive 'instructions', require './instructions.directive'
app.directive 'login', require './login.directive'
app.directive 'audiomessage', require './audiomessage.directive'
app.directive 'chat', require './chat.directive'
app.directive 'camera', require './camera.directive'
app.directive 'addmusic', require './addmusic.directive'
app.directive 'settings', require './settings.directive'
app.directive 'addMusic', require './addmusic.directive'

