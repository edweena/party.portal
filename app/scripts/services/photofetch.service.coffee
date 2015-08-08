'use strict'


PhotoFetch = ($http, $q) ->

    photos = []

    return {
        
        get: ->

            deferred = $q.defer()

            if photos.length > 0
                deferred.resolve(photos)
            else
                $http.get 'https://twit-novel-test.herokuapp.com/api/screengrab'
                    .success((response) ->
                        deferred.resolve(response)
                    ).error((err) ->
                        deferred.reject(err)
                    )

            return deferred.promise;

    }


module.exports = PhotoFetch