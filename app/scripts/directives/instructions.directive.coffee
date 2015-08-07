'use strict'

$ = require 'cash-dom'

module.exports = (Auth) ->

    return {
        restrict: 'A'
        templateUrl: 'views/partials/instructions.html'
        link: (scope, element, attrs) ->

            scope.instructed = false


            scope.hasBeenInstructed = ->
                scope.instructed = true
                Auth.hasBeenInstructed = true


    }