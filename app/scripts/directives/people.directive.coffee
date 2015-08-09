'use strict'

module.exports = ($timeout, Twitter) ->
    return{
        restrict: 'EA'
        templateUrl: 'views/partials/partypeople.html'
        link: (scope, element, attrs) ->

            scope.users = []
            scope.tweets = []

            scope.people =
                open: false

                toggleOpen: ->
                    self = this
                    self.open = !self.open

            

            #TO-DO: RUN 24 HOUR IMAGE PROFILE UPDATE
            Twitter.tweets.getUsers().then((data) ->
                for item in data
                    scope.users.push item

                Twitter.tweets.getData().then((result) ->
                    scope.tweets = result
                    )
                )



    }