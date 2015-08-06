'use strict'

module.exports = ($timeout, Twitter) ->
    return{
        restrict: 'EA'
        templateUrl: 'views/partials/_partypeople.html'
        link: (scope, element, attrs) ->

            scope.users = []
            scope.tweets = []

            Twitter.getUsers().then((data) ->
                for item in data
                    scope.users.push item

                scope.message = 'Welcome to the party!'

                Twitter.getData().then((result) ->
                    scope.tweets = result
                    )
                )



    }