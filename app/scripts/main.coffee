'use strict'

#REQUIRES
angular = require 'angular'
require 'angular-ui-router'
require 'angular-resource'
require 'angular-sanitize'
require 'angular-socket-io'
require 'angular-animate'
require 'angular-local-storage'
require 'ng-file-upload'



#APP DEPENDENCIES
requires = [
    'ui.router',
    'ngResource',
    'ngSanitize',
    'btford.socket-io',
    'LocalStorageModule',
    'ngFileUpload'
]


angular.module('partyApp', requires)

#CONTROLLERS
require './services'
require './controllers'
require './directives'


#ADD ROUTE STATES
angular.module('partyApp').config(require('./routes'))

